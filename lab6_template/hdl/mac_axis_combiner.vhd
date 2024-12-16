library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity MAC_AXIS_COMBINER is
    generic (
        G_DATA_WIDTH : integer := 32
    );
    port( 
        CLK : in std_logic;
        RESET : in std_logic;

        BIAS : in std_logic_vector(G_DATA_WIDTH-1 downto 0);

        S0_AXIS_TVALID : in std_logic;
        S0_AXIS_TREADY : out std_logic;
        S0_AXIS_TDATA : in std_logic_vector(G_DATA_WIDTH-1 downto 0);
        S0_AXIS_TLAST : in std_logic;

        S1_AXIS_TVALID : in std_logic;
        S1_AXIS_TREADY : out std_logic;
        S1_AXIS_TDATA : in std_logic_vector(G_DATA_WIDTH-1 downto 0);
        S1_AXIS_TLAST : in std_logic;

        M_AXIS_TVALID : out std_logic;
        M_AXIS_TREADY : in std_logic;
        M_AXIS_TDATA : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
        M_AXIS_TLAST : out std_logic
    );
end entity MAC_AXIS_COMBINER;

architecture RTL of MAC_AXIS_COMBINER is

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal q_slave_0_data, n_slave_0_data : std_logic_vector(G_DATA_WIDTH-1 downto 0);
    signal q_slave_1_data, n_slave_1_data : std_logic_vector(G_DATA_WIDTH-1 downto 0);
    signal q_after_bias, n_after_bias : std_logic_vector(G_DATA_WIDTH-1 downto 0);

    signal q_slave_0_tvalid, n_slave_0_tvalid : std_logic;
    signal q_slave_1_tvalid, n_slave_1_tvalid : std_logic;
    signal q_after_bias_tvalid, n_after_bias_tvalid : std_logic;

    signal w_slave_0_tready : std_logic;
    signal w_slave_1_tready : std_logic;
    signal w_after_bias_tready : std_logic;

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
    S0_AXIS_TREADY <= w_slave_0_tready;
    S1_AXIS_TREADY <= w_slave_1_tready;

    M_AXIS_TDATA <= q_after_bias;
    M_AXIS_TVALID <= q_after_bias_tvalid;
    M_AXIS_TLAST <= '1';

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    ----------------------------------------------------------------------------
    w_slave_0_tready <= '1' when w_after_bias_tready = '1' or q_slave_0_tvalid = '0' else
                        '0';

    w_slave_1_tready <= '1' when w_after_bias_tready = '1' or q_slave_1_tvalid = '0' else
                        '0';

    w_after_bias_tready <= '1' when M_AXIS_TREADY = '1' or q_after_bias_tvalid = '0' else
                           '0';

    n_slave_0_data <= S0_AXIS_TDATA when w_slave_0_tready = '1' and S0_AXIS_TVALID = '1' and S0_AXIS_TLAST = '1' else
                      q_slave_0_data;

    n_slave_1_data <= S1_AXIS_TDATA when w_slave_1_tready = '1' and S1_AXIS_TVALID = '1' and S1_AXIS_TLAST = '1' else
                      q_slave_1_data;

    n_after_bias <= std_logic_vector(signed(q_slave_0_data) + signed(q_slave_1_data) + signed(BIAS)) when w_after_bias_tready = '1' and q_slave_0_tvalid = '1' and q_slave_1_tvalid = '1' else
                    q_after_bias;

    n_slave_0_tvalid <= '0' when w_after_bias_tready = '1' and q_slave_0_tvalid = '1' and q_slave_1_tvalid = '1' and S0_AXIS_TVALID = '0' else -- not valid if transferring data and not getting new
                        '1' when w_slave_0_tready = '1' and S0_AXIS_TVALID = '1' and S0_AXIS_TLAST = '1' else -- valid if we are getting new data
                        q_slave_0_tvalid;
                        
    n_slave_1_tvalid <= '0' when w_after_bias_tready = '1' and q_slave_0_tvalid = '1' and q_slave_1_tvalid = '1' and S1_AXIS_TVALID = '0' else -- not valid if transferring data and not getting new
                        '1' when w_slave_1_tready = '1' and S1_AXIS_TVALID = '1' and S1_AXIS_TLAST = '1' else -- valid if we are getting new data
                        q_slave_1_tvalid;

    n_after_bias_tvalid <= '0' when M_AXIS_TREADY = '1' and q_after_bias_tvalid = '1' and q_slave_0_tvalid = '1' and q_slave_1_tvalid = '1' else
                           '1' when w_after_bias_tready = '1' and q_slave_0_tvalid = '1' and q_slave_1_tvalid = '1' else
                           q_after_bias_tvalid;

    ----------------------------------------------------------------------------
    -- Synchronous Processes
    ----------------------------------------------------------------------------
    SYNC_PROC : process(CLK, RESET)
    begin

        if RESET = '1' then
            q_slave_0_data <= (others => '0');
            q_slave_1_data <= (others => '0');
            q_after_bias   <= (others => '0');
            q_slave_0_tvalid <= '0';
            q_slave_1_tvalid <= '0';
            q_after_bias_tvalid <= '0';
        elsif rising_edge(CLK) then
            q_slave_0_data <= n_slave_0_data;
            q_slave_1_data <= n_slave_1_data;
            q_after_bias <= n_after_bias;
            q_slave_0_tvalid <= n_slave_0_tvalid;
            q_slave_1_tvalid <= n_slave_1_tvalid;
            q_after_bias_tvalid <= n_after_bias_tvalid;
        end if;

    end process SYNC_PROC;

end architecture RTL;