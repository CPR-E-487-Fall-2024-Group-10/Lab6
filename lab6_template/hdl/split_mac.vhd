library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity SPLIT_MAC is
    generic(
        G_DATA_WIDTH : integer := 32;
        G_OUTPUT_DATA_WIDTH : integer := 32
      );
      port (  
          S_AXIS_TREADY : out std_logic;
          S_AXIS_TDATA  : in  std_logic_vector(G_DATA_WIDTH*2-1 downto 0);
          S_AXIS_TLAST  : in  std_logic;
          S_AXIS_TVALID : in  std_logic;
  
          M_AXIS_TREADY : in  std_logic;
          M_AXIS_TDATA  : out std_logic_vector(G_OUTPUT_DATA_WIDTH-1 downto 0);
          M_AXIS_TLAST  : out std_logic;
          M_AXIS_TVALID : out std_logic;
  
          RESET : in std_logic;
          CLK : in std_logic
      );
end entity SPLIT_MAC;

architecture RTL of SPLIT_MAC is

    -- Constants
    constant C_ACCUMULATOR_WIDTH      : natural := G_OUTPUT_DATA_WIDTH;
	
	-- Mac state
    type STATE_TYPE is (WAIT_FOR_DATA, MAC, ADD_BIAS, RESPONSE);

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    -- Registers
    signal q_state, n_state : STATE_TYPE;
    signal q_accumulator, n_accumulator : signed(C_ACCUMULATOR_WIDTH - 1 downto 0); -- extra 15 bits ensures that no overflow occurs during biggest layer (layer 2)

    -- Wires
    signal w_tready   : std_logic;
    signal w_tvalid   : std_logic;
    signal w_tlast    : std_logic;
    signal w_input_0  : signed(G_DATA_WIDTH - 1 downto 0);
    signal w_input_1  : signed(G_DATA_WIDTH - 1 downto 0);
    signal w_acc_clr  : std_logic;

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
	S_AXIS_TREADY <= w_tready;
    
    M_AXIS_TDATA  <= std_logic_vector(q_accumulator);
    M_AXIS_TVALID <= w_tvalid;
    M_AXIS_TLAST  <= w_tlast;

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assigments
    ----------------------------------------------------------------------------
    w_input_0     <= signed(S_AXIS_TDATA((2 * G_DATA_WIDTH) - 1 downto G_DATA_WIDTH));
    w_input_1     <= signed(S_AXIS_TDATA(G_DATA_WIDTH - 1 downto 0));

    n_accumulator <= (others => '0')                                                       when w_acc_clr = '1'                        else
                     resize(q_accumulator + (w_input_0 * w_input_1), q_accumulator'length) when w_tready = '1' and S_AXIS_TVALID = '1' else
                     q_accumulator;
   
    ----------------------------------------------------------------------------
    -- Asynchronous Processes
    ----------------------------------------------------------------------------
    SM_PROC : process(q_state, S_AXIS_TVALID, S_AXIS_TLAST, M_AXIS_TREADY) is
    begin

        n_state <= q_state;

        w_tready   <= '0';
        w_tvalid   <= '0';
        w_tlast    <= '0';
        w_acc_clr  <= '0';
    
        case q_state is

            when MAC =>
                w_tready <= '1';

                -- go to response state when last input data is encountered
                if S_AXIS_TLAST = '1' and S_AXIS_TVALID = '1' then
                    n_state <= RESPONSE;
                end if;

            when RESPONSE =>
                w_tvalid <= '1';
                w_tlast  <= '1';

                if M_AXIS_TREADY = '1' then
                    n_state <= MAC;

                    w_acc_clr <= '1';
                end if;

            when others =>
                n_state <= MAC;
            
        end case;

    end process;

    -----------------------------------------------------------------------------
    -- Synchronous Processes
    -----------------------------------------------------------------------------
    SYNC_PROC : process(CLK, RESET)
    begin

        if RESET = '1' then
            q_state       <= MAC;
            q_accumulator <= (others => '0');
        elsif rising_edge(CLK) then
            q_state       <= n_state;
            q_accumulator <= n_accumulator;
        end if;

    end process SYNC_PROC;

end architecture RTL;