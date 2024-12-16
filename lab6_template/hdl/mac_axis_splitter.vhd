library ieee;
    use ieee.std_logic_1164.all;

entity MAC_AXIS_SPLITTER is
    generic (
        G_DATA_WIDTH : integer := 32
    );
    port (
        CLK : in std_logic;
        RESET : in std_logic;

        S_AXIS_TREADY : out std_logic;
        S_AXIS_TDATA  : in  std_logic_vector(G_DATA_WIDTH-1 downto 0);
        S_AXIS_TLAST  : in  std_logic;
        S_AXIS_TVALID : in  std_logic;

        M0_AXIS_TREADY : in std_logic;
        M0_AXIS_TDATA : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
        M0_AXIS_TLAST : out std_logic;
        M0_AXIS_TVALID : out std_logic;

        M1_AXIS_TREADY : in std_logic;
        M1_AXIS_TDATA : out std_logic_vector(G_DATA_WIDTH-1 downto 0);
        M1_AXIS_TLAST : out std_logic;
        M1_AXIS_TVALID : out std_logic
    );
end entity MAC_AXIS_SPLITTER;

architecture RTL of MAC_AXIS_SPLITTER is

    ----------------------------------------------------------------------------
    -- Type Declarations
    ----------------------------------------------------------------------------
    type t_state is (S_MASTER_0, S_MASTER_1, S_TLAST);

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal q_state, n_state : t_state;
    signal q_master_0_tlast, n_master_0_tlast : std_logic;
    signal q_master_1_tlast, n_master_1_tlast : std_logic;

    signal w_master_select : std_logic;
    signal w_slave_tready : std_logic;
    signal w_master_0_tlast : std_logic;
    signal w_master_1_tlast : std_logic;
    signal w_doing_tlast : std_logic;

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
    M0_AXIS_TDATA <= (others => '0') when w_doing_tlast = '1' else
                     S_AXIS_TDATA;
    M1_AXIS_TDATA <= (others => '0') when w_doing_tlast = '1' else
                     S_AXIS_TDATA;

    M0_AXIS_TLAST <= w_master_0_tlast;
    M1_AXIS_TLAST <= w_master_1_tlast;

    M0_AXIS_TVALID <= not q_master_0_tlast when w_doing_tlast = '1' else
                      S_AXIS_TVALID when w_master_select = '0' else
                      '0';
    M1_AXIS_TVALID <= not q_master_1_tlast when w_doing_tlast = '1' else
                      S_AXIS_TVALID when w_master_select = '1' else
                      '0';

    S_AXIS_TREADY <= '0' when w_doing_tlast = '1' else
                     M0_AXIS_TREADY when w_master_select = '0' else
                     M1_AXIS_TREADY;

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assignments
    ----------------------------------------------------------------------------
    w_slave_tready <= '0' when w_doing_tlast = '1' else
                      M0_AXIS_TREADY when w_master_select = '0' else
                      M1_AXIS_TREADY;

    ----------------------------------------------------------------------------
    -- Asynchronous Processes
    ----------------------------------------------------------------------------
    SM_PROC : process(q_state, q_master_0_tlast, q_master_1_tlast, M0_AXIS_TREADY, M1_AXIS_TREADY, S_AXIS_TVALID, S_AXIS_TLAST)
    begin

        w_master_select <= '0';
        w_master_0_tlast <= '0';
        w_master_1_tlast <= '0';
        w_doing_tlast <= '0';

        n_state <= q_state;
        n_master_0_tlast <= q_master_0_tlast;
        n_master_1_tlast <= q_master_1_tlast;

        case (q_state) is
            -- send data to master 0
            when S_MASTER_0 =>
                w_master_select <= '0'; -- select master 0

                if S_AXIS_TVALID = '1' and S_AXIS_TLAST = '1' and M0_AXIS_TREADY = '1' then
                    n_state <= S_TLAST;
                elsif S_AXIS_TVALID = '1' and M0_AXIS_TREADY = '1' then
                    n_state <= S_MASTER_1;
                end if;
            
            -- send data to master 1
            when S_MASTER_1 =>
                w_master_select <= '1'; -- select master 1

                if S_AXIS_TVALID = '1' and S_AXIS_TLAST = '1' and M1_AXIS_TREADY = '1' then
                    n_state <= S_TLAST;
                elsif S_AXIS_TVALID = '1' and M1_AXIS_TREADY = '1' then
                    n_state <= S_MASTER_0;
                end if;

            -- send a nop (0 * 0) to both with TLAST asserted, to cleanly terminate stream
            when S_TLAST =>
                w_doing_tlast <= '1';
                w_master_0_tlast <= '1';
                w_master_1_tlast <= '1';

                if q_master_0_tlast = '1' and q_master_1_tlast = '1' then
                    n_state <= S_MASTER_0;
                    n_master_0_tlast <= '0';
                    n_master_1_tlast <= '0';
                else
                    n_master_0_tlast <= M0_AXIS_TREADY;
                    n_master_1_tlast <= M1_AXIS_TREADY;
                end if;

            when others =>
                n_state <= S_MASTER_0;

        end case;

    end process SM_PROC;

    ----------------------------------------------------------------------------
    -- Synchronous Processes
    ----------------------------------------------------------------------------
    SYNC_PROC : process(CLK, RESET)
    begin

        if RESET = '1' then
            q_state <= S_MASTER_0;
            q_master_0_tlast <= '0';
            q_master_1_tlast <= '0';
        elsif rising_edge(CLK) then
            q_state <= n_state;
            q_master_0_tlast <= n_master_0_tlast;
            q_master_1_tlast <= n_master_1_tlast;
        end if;

    end process SYNC_PROC;

end architecture RTL;