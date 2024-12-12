----------------------------------------------------------------------------------
-- Output Storage Unit
--
-- Gregory Ling, 2024
----------------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity output_storage is
    generic(
        DATA_WIDTH : integer := 32;
        BRAM_DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 32;
        BRAM_ADDR_WIDTH : integer := 32;
        DIM_WIDTH : integer := 8;
        C_TID_WIDTH : integer := 1
    );
    port(
        S_AXIS_TREADY : out std_logic;
        S_AXIS_TDATA  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        S_AXIS_TLAST  : in  std_logic;
        S_AXIS_TID    : in  std_logic_vector(C_TID_WIDTH-1 downto 0);
        S_AXIS_TVALID : in  std_logic;

        BRAM_addr : out std_logic_vector(32-1 downto 0);
        BRAM_din : out std_logic_vector(BRAM_DATA_WIDTH-1 downto 0);
        BRAM_dout : in std_logic_vector(BRAM_DATA_WIDTH-1 downto 0);
        BRAM_en : out std_logic;
        BRAM_we : out std_logic_vector((BRAM_DATA_WIDTH/8)-1 downto 0);
        BRAM_rst : out std_logic;
        BRAM_clk : out std_logic;

        max_pooling : in std_logic;
        elements_per_channel : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        output_w : in std_logic_vector(DIM_WIDTH-1 downto 0);
        output_h : in std_logic_vector(DIM_WIDTH-1 downto 0);
        initial_offset : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        
        conv_complete : out std_logic;
        conv_idle : in std_logic;
        clk : in std_logic;
        rst : in std_logic
    );
end output_storage;

architecture Behavioral of output_storage is

    ----------------------------------------------------------------------------
    -- Type Definitions
    ----------------------------------------------------------------------------
    type t_state is (S_IDLE, S_LOAD_INIT, S_DELAY, S_READ, S_MODIFY, S_WRITE);

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal q_state,      n_state      : t_state;
    signal q_height_cnt, n_height_cnt : unsigned(DIM_WIDTH-1 downto 0);
    signal q_width_cnt,  n_width_cnt  : unsigned(DIM_WIDTH-1 downto 0);
    signal q_chan_cnt,   n_chan_cnt   : unsigned(1 downto 0);
    signal q_bram_addr,  n_bram_addr  : unsigned(31 downto 0);
    signal q_conv_done,  n_conv_done  : std_logic;
    signal q_data_reg,   n_data_reg   : std_logic_vector(BRAM_DATA_WIDTH-1 downto 0);
    signal q_bram_we,    n_bram_we    : std_logic_vector((BRAM_DATA_WIDTH/8)-1 downto 0);
    signal q_tdata,      n_tdata      : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal w_rmw_done                 : std_logic; -- indicates when a read-modify-write state machine cycle has completed
    signal w_height                   : unsigned(DIM_WIDTH-1 downto 0);
    signal w_width                    : unsigned(DIM_WIDTH-1 downto 0);
    signal w_height_ovf               : std_logic;
    signal w_width_ovf                : std_logic;
    signal w_chan_ovf                 : std_logic;
    signal w_cnt_incr                 : std_logic;
    signal w_load_offset              : std_logic;
    signal w_tready                   : std_logic;
    signal w_bram_en                  : std_logic;

    signal w_bram_addr_pool           : unsigned(31 downto 0);
    signal w_bram_addr_no_pool        : unsigned(31 downto 0);

    attribute MARK_DEBUG : string;

    attribute MARK_DEBUG of q_bram_addr : signal is "true";
    attribute MARK_DEBUG of max_pooling : signal is "true";
    attribute MARK_DEBUG of elements_per_channel : signal is "true";
    attribute MARK_DEBUG of output_w : signal is "true";
    attribute MARK_DEBUG of output_h : signal is "true";
    attribute MARK_DEBUG of initial_offset : signal is "true";
    attribute MARK_DEBUG of conv_complete : signal is "true";
    attribute MARK_DEBUG of conv_idle : signal is "true";

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
    S_AXIS_TREADY <= w_tready;

    BRAM_addr <= std_logic_vector(q_bram_addr(31 downto 2)) & "00";
    BRAM_din  <= q_data_reg;
    BRAM_en   <= w_bram_en;
    BRAM_we   <= q_bram_we;
    BRAM_rst  <= rst;
    BRAM_clk  <= clk;

    conv_complete <= q_conv_done;

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    ----------------------------------------------------------------------------
    w_height <= unsigned(output_h);

    w_width <= unsigned(output_w);

    w_height_ovf <= '1' when q_height_cnt = w_height - 1 and w_width_ovf = '1' else
                    '0';

    w_width_ovf  <= '1' when q_width_cnt = w_width - 1 and w_chan_ovf = '1' else
                    '0';

    w_chan_ovf   <= '1' when q_chan_cnt = "11" and n_chan_cnt = "00" else
                    '0';

    w_load_offset <= conv_idle;

    n_conv_done <= '1' when w_height_ovf = '1' else
                   '0' when conv_idle = '1' else
                   q_conv_done;

    n_tdata     <= S_AXIS_TDATA when S_AXIS_TVALID = '1' and w_tready = '1' else
                   q_tdata;

    n_bram_addr <= w_bram_addr_no_pool when max_pooling = '0' else
                   w_bram_addr_pool;

    w_bram_addr_no_pool <= resize(unsigned(initial_offset), 32)             when w_load_offset = '1' else
                           q_bram_addr - shift_left(unsigned(elements_per_channel), 1) - unsigned(elements_per_channel) + 1 when w_rmw_done = '1' and q_chan_cnt = "11" else
                           q_bram_addr + unsigned(elements_per_channel)     when w_rmw_done = '1' else
                           q_bram_addr;

    w_bram_addr_pool <= resize(unsigned(initial_offset), 32) when w_load_offset = '1' else
                        (((q_bram_addr + 1) - shift_left(unsigned(elements_per_channel), 1)) - unsigned(elements_per_channel)) - shift_right(unsigned(output_w), 1) when w_rmw_done = '1' and q_chan_cnt = "11" and w_width_ovf = '1' and q_height_cnt(0) = '0' else
                        -- (((q_bram_addr + 2) - shift_left(unsigned(elements_per_channel), 1)) - unsigned(elements_per_channel)) - shift_right(unsigned(output_w), 1) when w_rmw_done = '1' and q_chan_cnt = "11" and w_width_ovf = '1' and q_height_cnt(0) = '1' else
                        (((q_bram_addr + 1) - shift_left(unsigned(elements_per_channel), 1)) - unsigned(elements_per_channel)) when w_rmw_done = '1' and q_chan_cnt = "11" and w_width_ovf = '1' and q_height_cnt(0) = '1' else
                        (q_bram_addr - shift_left(unsigned(elements_per_channel), 1)) - unsigned(elements_per_channel) when w_rmw_done = '1' and q_chan_cnt = "11" and q_width_cnt(0) = '0' else -- repeat current width and height
                        ((q_bram_addr + 1) - shift_left(unsigned(elements_per_channel), 1)) - unsigned(elements_per_channel) when w_rmw_done = '1' and q_chan_cnt = "11" and q_width_cnt(0) = '1' else
                        q_bram_addr + unsigned(elements_per_channel) when w_rmw_done = '1' else
                        q_bram_addr;

    n_height_cnt <= (others => '0')  when w_height_ovf = '1' else
                    q_height_cnt + 1 when w_width_ovf = '1'  else
                    q_height_cnt;
                   
    n_width_cnt  <= (others => '0') when w_width_ovf = '1' else
                    q_width_cnt + 1 when w_chan_ovf = '1'          else
                    q_width_cnt;

    n_chan_cnt   <= q_chan_cnt + 1 when w_cnt_incr = '1' else
                    q_chan_cnt;

    ----------------------------------------------------------------------------
    -- Asynchronous Processes
    ----------------------------------------------------------------------------
    SM_PROC : process(q_state, q_data_reg, q_tdata, q_height_cnt, q_width_cnt, q_bram_addr, q_bram_we, conv_idle, S_AXIS_TVALID, BRAM_dout, max_pooling)
    begin

        n_state <= q_state;
        n_data_reg <= q_data_reg;
        n_bram_we  <= q_bram_we;

        w_rmw_done    <= '0';
        w_cnt_incr    <= '0';
        w_tready      <= '0';
        w_bram_en     <= '0';
        -- w_load_offset <= '0';

        case q_state is
        
            when S_IDLE =>
                w_tready <= '1';

                if S_AXIS_TVALID = '1' then
                    n_state <= S_DELAY;

                    w_bram_en <= '1'; -- one cycle delay for BRAM reads, so need to set up here
                end if;

            when S_LOAD_INIT =>
                n_state <= S_DELAY;

                w_bram_en <= '1';

            when S_DELAY =>
                n_state <= S_READ;

            when S_READ =>
                n_data_reg <= BRAM_dout; -- save off the data we requested last cycle

                n_state <= S_MODIFY;

            when S_MODIFY =>
                n_state <= S_WRITE;

                n_bram_we <= (others => '1');

                if (q_width_cnt(0) = '0' and q_height_cnt(0) = '0') or max_pooling = '0' then
                    -- first pass at output, don't need to compare (or not pooling)
                    case q_bram_addr(1 downto 0) is
                        when "00" =>
                            n_data_reg(7 downto 0) <= q_tdata;
    
                        when "01" =>
                            n_data_reg(15 downto 8) <= q_tdata;
    
                        when "10" =>
                            n_data_reg(23 downto 16) <= q_tdata;
    
                        when "11" =>
                            n_data_reg(31 downto 24) <= q_tdata;
    
                        when others =>
                            null;
                    end case;
                else
                    -- second or later pass at output, need to compare
                    case q_bram_addr(1 downto 0) is
                        when "00" =>
                            if signed(q_tdata) > signed(q_data_reg(7 downto 0)) then
                                n_data_reg(7 downto 0) <= q_tdata;
                            end if;
    
                        when "01" =>
                            if signed(q_tdata) > signed(q_data_reg(15 downto 8)) then
                                n_data_reg(15 downto 8) <= q_tdata;
                            end if;
    
                        when "10" =>
                            if signed(q_tdata) > signed(q_data_reg(23 downto 16)) then
                                n_data_reg(23 downto 16) <= q_tdata;
                            end if;
    
                        when "11" =>
                            if signed(q_tdata) > signed(q_data_reg(31 downto 24)) then
                                n_data_reg(31 downto 24) <= q_tdata;
                            end if;
    
                        when others =>
                            null;
                    end case;
                end if;

            when S_WRITE =>
                w_rmw_done <= '1'; -- we have completed another cycle
                w_cnt_incr <= '1';

                w_bram_en  <= '1';
                n_bram_we  <= (others => '0');

                n_state <= S_IDLE;

            when others =>
                n_state <= S_IDLE;

        end case;

    end process SM_PROC;

    ----------------------------------------------------------------------------
    -- Synchronous Processes
    ----------------------------------------------------------------------------
    SYNC_PROC : process(clk, rst)
    begin

        if rst = '1' then
            q_state      <= S_IDLE;
            q_height_cnt <= (others => '0');
            q_width_cnt  <= (others => '0');
            q_chan_cnt   <= (others => '0');
            q_bram_addr  <= (others => '0');
            q_conv_done  <= '0';
            q_data_reg   <= (others => '0');
            q_bram_we    <= (others => '0');
            q_tdata      <= (others => '0');
        elsif rising_edge(clk) then
            q_state      <= n_state;
            q_height_cnt <= n_height_cnt;
            q_width_cnt  <= n_width_cnt;
            q_chan_cnt   <= n_chan_cnt;
            q_bram_addr  <= n_bram_addr;
            q_conv_done  <= n_conv_done;
            q_data_reg   <= n_data_reg;
            q_bram_we    <= n_bram_we;
            q_tdata      <= n_tdata;
        end if;

    end process SYNC_PROC;

end Behavioral;
