----------------------------------------------------------------------------------
-- Dequantization Unit
--
-- Gregory Ling, 2024
----------------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dequantization is
    generic(
        C_DATA_WIDTH : integer := 32;
        C_TID_WIDTH : integer := 1;
        C_OUT_WIDTH : integer := 8
    );
    port(
        S_AXIS_TREADY : out std_logic;
        S_AXIS_TDATA  : in  std_logic_vector(C_DATA_WIDTH-1 downto 0);
        S_AXIS_TLAST  : in  std_logic;
        S_AXIS_TID    : in  std_logic_vector(C_TID_WIDTH-1 downto 0);
        S_AXIS_TVALID : in  std_logic;

        relu : in std_logic;
        q_scale : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
        q_zero : in std_logic_vector(C_OUT_WIDTH-1 downto 0);

        M_AXIS_TREADY : in  std_logic;
        M_AXIS_TDATA  : out std_logic_vector(C_OUT_WIDTH-1 downto 0);
        M_AXIS_TLAST  : out std_logic;
        M_AXIS_TID    : out std_logic_vector(C_TID_WIDTH-1 downto 0);
        M_AXIS_TVALID : out std_logic;

        clk : in std_logic;
        rst : in std_logic
    );
end dequantization;

architecture Behavioral of dequantization is

    ----------------------------------------------------------------------------
    -- Constant Definitions
    ----------------------------------------------------------------------------
    constant C_UPPER_BITS_ZERO : signed((C_DATA_WIDTH - C_OUT_WIDTH) downto 0) := (others => '0');
    constant C_UPPER_BITS_ONE  : signed((C_DATA_WIDTH - C_OUT_WIDTH) downto 0) := (others => '1');

    ----------------------------------------------------------------------------
    -- Type Declarations
    ----------------------------------------------------------------------------
    type t_tid_arr is array (0 to 3) of std_logic_vector(C_TID_WIDTH-1 downto 0);

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal q_scaled,    n_scaled    : signed(C_DATA_WIDTH-1 downto 0);
    signal q_relued,    n_relued    : signed(C_DATA_WIDTH-1 downto 0);
    signal q_zeroed,    n_zeroed    : signed(C_DATA_WIDTH-1 downto 0);
    signal q_saturated, n_saturated : signed(C_OUT_WIDTH-1 downto 0);
    signal q_tvalid,    n_tvalid    : std_logic_vector(3 downto 0); -- valid signal for each stage of pipeline
    signal q_tlast,     n_tlast     : std_logic_vector(3 downto 0);
    signal q_tid,       n_tid       : t_tid_arr;

    attribute MARK_DEBUG : string;

    attribute MARK_DEBUG of q_scaled : signal is "true";
    attribute MARK_DEBUG of q_relued : signal is "true";
    attribute MARK_DEBUG of q_zeroed : signal is "true";
    attribute MARK_DEBUG of q_saturated : signal is "true";
    attribute MARK_DEBUG of q_tvalid : signal is "true";
    
    attribute MARK_DEBUG of relu : signal is "true";
    attribute MARK_DEBUG of q_scale : signal is "true";
    attribute MARK_DEBUG of q_zero : signal is "true";

    signal w_slave_tready           : std_logic;
    signal w_mult_result            : signed((2*C_DATA_WIDTH)-1 downto 0);
    signal w_scaled_tready          : std_logic;
    signal w_relued_tready          : std_logic;
    signal w_zeroed_tready          : std_logic;
    signal w_saturated_tready       : std_logic;
    signal w_tready_arr             : std_logic_vector(3 downto 0);

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
    M_AXIS_TDATA  <= std_logic_vector(q_saturated);
    M_AXIS_TLAST  <= q_tlast(3);
    M_AXIS_TID    <= q_tid(3);
    M_AXIS_TVALID <= q_tvalid(3);

    -- S_AXIS_TREADY <= w_slave_tready;
    S_AXIS_TREADY <= w_scaled_tready;

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    ----------------------------------------------------------------------------
    -- w_slave_tready <= '0' when M_AXIS_TREADY = '0' and q_tvalid(3) = '1' else
                    --   '1';

    w_saturated_tready <= '0' when M_AXIS_TREADY = '0' and q_tvalid(3) = '1' else
                          '1';

    w_zeroed_tready    <= '0' when w_saturated_tready = '0' and q_tvalid(2) = '1' else
                          '1';

    w_relued_tready    <= '0' when w_zeroed_tready = '0' and q_tvalid(1) = '1' else
                          '1';

    w_scaled_tready    <= '0' when w_relued_tready = '0' and q_tvalid(0) = '1' else
                          '1';

    w_tready_arr(0)    <= w_scaled_tready;
    w_tready_arr(1)    <= w_relued_tready;
    w_tready_arr(2)    <= w_zeroed_tready;
    w_tready_arr(3)    <= w_saturated_tready;

    w_mult_result  <= signed(S_AXIS_TDATA) * signed(q_scale);

    n_scaled <= w_mult_result((2*C_DATA_WIDTH)-1 downto C_DATA_WIDTH) when w_scaled_tready = '1' and S_AXIS_TVALID = '1' else
                q_scaled;

    n_relued <= (others => '0') when w_relued_tready = '1' and relu = '1' and q_scaled(C_DATA_WIDTH-1) = '1' else
                q_scaled        when w_relued_tready = '1' else
                q_relued;

    n_zeroed <= q_relued + resize(signed(q_zero), C_DATA_WIDTH) when w_zeroed_tready = '1' else
                q_zeroed;

    n_saturated <= q_zeroed(C_OUT_WIDTH-1 downto 0) when w_saturated_tready = '1' and (q_zeroed(C_DATA_WIDTH-1 downto C_OUT_WIDTH-1) = C_UPPER_BITS_ZERO or q_zeroed(C_DATA_WIDTH-1 downto C_OUT_WIDTH-1) = C_UPPER_BITS_ONE) else
                   (C_OUT_WIDTH-1 => '0', others => '1') when w_saturated_tready = '1' and q_zeroed(C_DATA_WIDTH-1) = '0' else -- saturate positive
                   (C_OUT_WIDTH-1 => '1', others => '0') when w_saturated_tready = '1' and q_zeroed(C_DATA_WIDTH-1) = '1' else -- saturate negative
                   q_saturated;

    n_tvalid(0) <= S_AXIS_TVALID when w_tready_arr(0) = '1' else
                   q_tvalid(0);
    n_tlast(0)  <= S_AXIS_TLAST when w_tready_arr(0) = '1' else
                   q_tlast(0);
    n_tid(0)    <= S_AXIS_TID when w_tready_arr(0) = '1' else
                   q_tid(0);

    GEN_AXIS_CTRL_REGS : for I in 1 to 3 generate
        n_tvalid(I) <= q_tvalid(I-1) when w_tready_arr(I) = '1' else
                       q_tvalid(I);

        n_tlast(I)  <= q_tlast(I-1) when w_tready_arr(I) = '1' else
                       q_tlast(I);

        n_tid(I)    <= q_tid(I-1) when w_tready_arr(I) = '1' else
                       q_tid(I);
    end generate;

    ----------------------------------------------------------------------------
    -- Synchrononous Processes
    ----------------------------------------------------------------------------
    SYNC_PROC : process(clk, rst)
    begin

        if rst = '1' then
            q_scaled    <= (others => '0');
            q_relued    <= (others => '0');
            q_zeroed    <= (others => '0');
            q_saturated <= (others => '0');
            q_tvalid    <= (others => '0');
            q_tlast     <= (others => '0');
            q_tid       <= (others => (others => '0'));
        elsif rising_edge(clk) then
            q_scaled    <= n_scaled;
            q_relued    <= n_relued;
            q_zeroed    <= n_zeroed;
            q_saturated <= n_saturated;
            q_tvalid    <= n_tvalid;
            q_tlast     <= n_tlast;
            q_tid       <= n_tid;
        end if;

    end process SYNC_PROC;

end Behavioral;
