----------------------------------------------------------------------------------
-- Input & Filter Index Generator
--
-- Gregory Ling, 2024
----------------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity index_gen is
    generic(
        DIM_WIDTH : integer := 32;
        INPUT_ADDR_WIDTH : integer := 32;
        FILTER_ADDR_WIDTH : integer := 32;
        OUTPUT_ADDR_WIDTH : integer := 32
    );
    port(
        filter_w : in std_logic_vector(DIM_WIDTH-1 downto 0); -- Filter dimension width (Filter width)
        filter_h : in std_logic_vector(DIM_WIDTH-1 downto 0); -- Filter dimension height (Filter height)
        filter_c : in std_logic_vector(DIM_WIDTH-1 downto 0); -- Filter dimension channels (Filter channels == Input channels)
        output_w : in std_logic_vector(DIM_WIDTH-1 downto 0); -- Output dimension width (Output width)
        output_h : in std_logic_vector(DIM_WIDTH-1 downto 0); -- Output dimension height (Output height)
        input_end_diff_fw : in std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0); -- Amount to add to addr when completing a filter row
        input_end_diff_fh : in std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0); -- Amount to add to addr when completing a filter column
        input_end_diff_fc : in std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0); -- Amount to add to addr when completing a filter channel
        input_end_diff_ow : in std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0); -- Amount to add to addr when completing an output row
        
        M_AXIS_TREADY : in std_logic;
        M_AXIS_TDATA_input_addr : out std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0);
        M_AXIS_TDATA_filter_addr : out std_logic_vector(FILTER_ADDR_WIDTH-1 downto 0);
        M_AXIS_TLAST : out std_logic;
        M_AXIS_TVALID : out std_logic;

        conv_idle : in std_logic; -- When the convolution is idle, reset the index generator. Starts counting on falling edge
        rst : in std_logic;
        clk : in std_logic
    );
end index_gen;

architecture Behavioral of index_gen is

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    -- These counts directly add to the address for the 
    signal q_filter_channel_offset, n_filter_channel_offset : unsigned(DIM_WIDTH-1 downto 0);
    signal q_filter_height_offset,  n_filter_height_offset  : unsigned(DIM_WIDTH-1 downto 0);
    signal q_filter_width_offset,   n_filter_width_offset   : unsigned(DIM_WIDTH-1 downto 0);
    signal q_output_width_offset,   n_output_width_offset   : unsigned(DIM_WIDTH-1 downto 0);
    signal q_output_height_offset,  n_output_height_offset  : unsigned(DIM_WIDTH-1 downto 0);

    -- These count the number of times a counter has been incremented
    signal q_filter_channel_cnt, n_filter_channel_cnt : unsigned(DIM_WIDTH-1 downto 0);
    signal q_filter_height_cnt,  n_filter_height_cnt  : unsigned(DIM_WIDTH-1 downto 0);
    signal q_filter_width_cnt,   n_filter_width_cnt   : unsigned(DIM_WIDTH-1 downto 0);
    signal q_output_width_cnt,   n_output_width_cnt   : unsigned(DIM_WIDTH-1 downto 0);
    signal q_output_height_cnt,  n_output_height_cnt  : unsigned(DIM_WIDTH-1 downto 0);

    signal q_filter_addr, n_filter_addr : signed(FILTER_ADDR_WIDTH-1 downto 0);
    signal q_input_addr,  n_input_addr  : signed(INPUT_ADDR_WIDTH-1 downto 0);

    signal q_tvalid_pipeline, n_tvalid_pipeline : std_logic_vector(1 downto 0);

    signal q_done, n_done : std_logic;

    signal w_filter_channel_ovf : std_logic;
    signal w_filter_height_ovf  : std_logic;
    signal w_filter_width_ovf   : std_logic;
    signal w_output_height_ovf  : std_logic;
    signal w_output_width_ovf   : std_logic;

    signal w_count_active       : std_logic;

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
    M_AXIS_TDATA_filter_addr <= std_logic_vector(q_filter_addr);
    M_AXIS_TDATA_input_addr  <= std_logic_vector(q_input_addr);
    -- M_AXIS_TVALID            <= q_tvalid_pipeline(1);
    M_AXIS_TVALID            <= not conv_idle;
    M_AXIS_TLAST             <= w_output_height_ovf;

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    ----------------------------------------------------------------------------
    -- n_tvalid_pipeline(0) <= not conv_idle;
    -- n_tvalid_pipeline(1) <= q_tvalid_pipeline(0);

    -- Generate overflow signals based on counter states relative to their maximum values
    w_filter_channel_ovf <= '1' when q_filter_channel_cnt = unsigned(filter_c) - 1 and w_filter_height_ovf = '1' else
                            '0';
    w_filter_height_ovf  <= '1' when q_filter_height_cnt = unsigned(filter_h) - 1 and w_filter_width_ovf = '1' else
                            '0';
    w_filter_width_ovf   <= '1' when q_filter_width_cnt = unsigned(filter_w) - 1 else
                            '0';
    w_output_height_ovf  <= '1' when q_output_height_cnt = unsigned(output_h) - 1 and w_output_width_ovf = '1' else
                            '0';
    w_output_width_ovf   <= '1' when q_output_width_cnt = unsigned(output_w) - 1 and w_filter_channel_ovf = '1' else
                            '0';

    w_count_active       <= (not conv_idle) and (not q_done);

    -- n_filter_channel_offset <= (others => '0')      when w_filter_channel_ovf = '1' or conv_idle = '1' else -- TODO check that this is a correct interpretation of conv_idle
    --                         q_filter_channel_offset when M_AXIS_TREADY = '0' else
    --                         q_filter_channel_offset + 1;

    -- n_filter_height_offset  <= (others => '0')                                   when w_filter_height_ovf = '1' or conv_idle = '1'  else
    --                         q_filter_height_offset + unsigned(input_end_diff_fc) when w_filter_width_ovf = '1'                    else
    --                         q_filter_height_offset;

    -- n_filter_width_offset   <= (others => '0')                                  when w_filter_width_ovf = '1' or conv_idle = '1' else
    --                         q_filter_width_offset + unsigned(input_end_diff_fw) when w_filter_channel_ovf = '1'                   else
    --                         q_filter_width_offset;
    
    -- n_output_height_offset  <= (others => '0')                                   when w_output_height_ovf = '1' or conv_idle = '1' else
    --                         q_output_height_offset + unsigned(input_end_diff_fh) when w_output_width_ovf = '1'                     else
    --                         q_output_height_offset;

    -- n_output_width_offset   <= (others => '0')                                  when conv_idle = '1'           else
    --                         q_output_width_offset + unsigned(input_end_diff_ow) when w_filter_height_ovf = '1' else
    --                         q_output_width_offset;

    n_filter_channel_cnt    <= (others => '0')      when w_filter_channel_ovf = '1' or conv_idle = '1' else -- TODO check that this is a correct interpretation of conv_idle
                            q_filter_channel_cnt + 1 when w_filter_height_ovf = '1' else
                            q_filter_channel_cnt;

    n_filter_height_cnt  <= (others => '0')      when w_filter_height_ovf = '1' or conv_idle = '1'  else
                            q_filter_height_cnt + 1 when w_filter_width_ovf = '1'                    else  -- increment whenever the previous counter rolls over
                            q_filter_height_cnt;
    
    n_filter_width_cnt   <= (others => '0')     when w_filter_width_ovf = '1' or conv_idle = '1' else
                            q_filter_width_cnt + 1  when M_AXIS_TREADY = '1' and w_count_active = '1' else
                            q_filter_width_cnt;
        
    n_output_height_cnt  <= (others => '0')      when w_output_height_ovf = '1' or conv_idle = '1' else
                            q_output_height_cnt + 1 when w_output_width_ovf = '1'                     else
                            q_output_height_cnt;
    
    n_output_width_cnt   <= (others => '0')     when w_output_width_ovf = '1' or conv_idle = '1' else
                            q_output_width_cnt + 1 when w_filter_channel_ovf = '1' else
                            q_output_width_cnt;

    -- Add to the address based on which counters overflow
    -- n_filter_addr <= resize(q_filter_width_offset + q_filter_height_offset + q_filter_channel_offset, FILTER_ADDR_WIDTH);

    -- n_input_addr  <= resize(q_output_width_offset + q_output_height_offset + q_filter_width_offset + q_filter_height_offset + q_filter_channel_offset, INPUT_ADDR_WIDTH);

    n_filter_addr <= (others => '0') when w_filter_channel_ovf = '1' else
                     q_filter_addr + 1 when w_count_active = '1' else
                     q_filter_addr;

    -- q_filter_addr + resize(signed(input_end_diff_fh), FILTER_ADDR_WIDTH) when w_filter_height_ovf = '1' else
    -- q_filter_addr + resize(signed(input_end_diff_fw), FILTER_ADDR_WIDTH) when w_filter_width_ovf = '1' else

    n_input_addr <= (others => '0') when w_output_height_ovf = '1' else
                    q_input_addr + signed(input_end_diff_ow) when w_output_width_ovf = '1' else
                    q_input_addr + signed(input_end_diff_fc) when w_filter_channel_ovf = '1' else
                    q_input_addr + signed(input_end_diff_fh) when w_filter_height_ovf = '1' else
                    q_input_addr + signed(input_end_diff_fw) when w_filter_width_ovf = '1' else
                    q_input_addr + 1 when w_count_active = '1' else
                    q_input_addr;

    n_done <= '1' when w_output_height_ovf = '1' and q_done = '0' else
              '0' when conv_idle = '1' and q_done = '1' else
              q_done;

    ----------------------------------------------------------------------------
    -- Synchronous Processes
    ----------------------------------------------------------------------------
    SYNC_PROC : process(rst, clk)
    begin

        if rst = '1' then
            -- q_filter_channel_offset <= (others => '0');
            -- q_filter_height_offset  <= (others => '0');
            -- q_filter_width_offset   <= (others => '0');
            -- q_output_height_offset  <= (others => '0');
            -- q_output_width_offset   <= (others => '0');
            q_filter_channel_cnt    <= (others => '0');
            q_filter_height_cnt     <= (others => '0');
            q_filter_width_cnt      <= (others => '0');
            q_output_height_cnt     <= (others => '0');
            q_output_width_cnt      <= (others => '0');
            q_filter_addr           <= (others => '0');
            q_input_addr            <= (others => '0');
            -- q_tvalid_pipeline       <= (others => '0');
            q_done                  <= '0';
        elsif rising_edge(clk) then
            -- q_filter_channel_offset <= n_filter_channel_offset;
            -- q_filter_height_offset  <= n_filter_height_offset;
            -- q_filter_width_offset   <= n_filter_width_offset;
            -- q_output_height_offset  <= n_output_height_offset;
            -- q_output_width_offset   <= n_output_width_offset;
            q_filter_channel_cnt    <= n_filter_channel_cnt;
            q_filter_height_cnt     <= n_filter_height_cnt ;
            q_filter_width_cnt      <= n_filter_width_cnt  ;
            q_output_height_cnt     <= n_output_height_cnt ;
            q_output_width_cnt      <= n_output_width_cnt  ;
            q_filter_addr           <= n_filter_addr       ;
            q_input_addr            <= n_input_addr        ;
            -- q_tvalid_pipeline       <= n_tvalid_pipeline;
            q_done                  <= n_done;
        end if;

    end process SYNC_PROC;

end Behavioral;
