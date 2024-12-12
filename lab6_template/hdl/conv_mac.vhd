----------------------------------------------------------------------------------
-- Convolutional MAC Unit
--
-- Gregory Ling, 2024
----------------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity conv_mac is
  generic(
      C_DATA_WIDTH : integer := 32;
      C_OUTPUT_DATA_WIDTH : integer := 32
    );
    port (  
        S_AXIS_TREADY : out std_logic;
        S_AXIS_TDATA  : in  std_logic_vector(C_DATA_WIDTH*2-1 downto 0);
        S_AXIS_TLAST  : in  std_logic;
        S_AXIS_TVALID : in  std_logic;

        bias : in std_logic_vector(C_OUTPUT_DATA_WIDTH-1 downto 0);

        M_AXIS_TREADY : in  std_logic;
        M_AXIS_TDATA  : out std_logic_vector(C_OUTPUT_DATA_WIDTH-1 downto 0);
        M_AXIS_TLAST  : out std_logic;
        M_AXIS_TVALID : out std_logic;

        rst : in std_logic;
        clk : in std_logic
    );

end conv_mac;


architecture behavioral of conv_mac is

    -- Constants
    constant C_ACCUMULATOR_WIDTH      : natural := C_OUTPUT_DATA_WIDTH;
	
	-- Mac state
    type STATE_TYPE is (WAIT_FOR_DATA, MAC, ADD_BIAS, RESPONSE);

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    -- Registers
    signal q_state, n_state : STATE_TYPE;
    signal q_accumulator, n_accumulator : signed(C_ACCUMULATOR_WIDTH - 1 downto 0); -- extra 15 bits ensures that no overflow occurs during biggest layer (layer 2)
    signal q_tlast_dly, n_tlast_dly : std_logic;

    -- Wires
    signal w_tready   : std_logic;
    signal w_tvalid   : std_logic;
    signal w_tlast    : std_logic;
    signal w_input_0  : signed(C_DATA_WIDTH - 1 downto 0);
    signal w_input_1  : signed(C_DATA_WIDTH - 1 downto 0);
    signal w_acc_clr  : std_logic;
    signal w_add_bias : std_logic;

    attribute MARK_DEBUG : string;

    attribute MARK_DEBUG of q_accumulator : signal is "true";
    attribute MARK_DEBUG of w_tvalid : signal is "true";
    attribute MARK_DEBUG of w_tlast : signal is "true";
    attribute MARK_DEBUG of w_add_bias : signal is "true";
    attribute MARK_DEBUG of S_AXIS_TDATA : signal is "true";
    attribute MARK_DEBUG of S_AXIS_TVALID : signal is "true";
    attribute MARK_DEBUG of S_AXIS_TREADY : signal is "true";

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
    w_input_0     <= signed(S_AXIS_TDATA((2 * C_DATA_WIDTH) - 1 downto C_DATA_WIDTH));
    w_input_1     <= signed(S_AXIS_TDATA(C_DATA_WIDTH - 1 downto 0));

    n_accumulator <= (others => '0')                                                       when w_acc_clr = '1'                        else
                     resize(q_accumulator + (w_input_0 * w_input_1), q_accumulator'length) when w_tready = '1' and S_AXIS_TVALID = '1' else
                     resize(q_accumulator + signed(bias), q_accumulator'length)            when w_add_bias = '1'                       else
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
        w_add_bias <= '0';
    
        case q_state is

            when MAC =>
                w_tready <= '1';

                -- go to response state when last input data is encountered
                if S_AXIS_TLAST = '1' and S_AXIS_TVALID = '1' then
                    n_state <= ADD_BIAS;
                end if;

            when ADD_BIAS =>
                w_add_bias <= '1';

                n_state <= RESPONSE;

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
    SYNC_PROC : process(clk, rst)
    begin

        if rst = '1' then
            q_state       <= MAC;
            q_accumulator <= (others => '0');
        elsif rising_edge(clk) then
            q_state       <= n_state;
            q_accumulator <= n_accumulator;
        end if;

    end process SYNC_PROC;

end architecture behavioral;
