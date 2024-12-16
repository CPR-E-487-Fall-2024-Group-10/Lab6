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
        clk_fast : in std_logic;
        clk_slow : in std_logic;
        rst_slow : in std_logic;

        reset_busy : out std_logic
    );

end conv_mac;


architecture behavioral of conv_mac is

    ----------------------------------------------------------------------------
    -- Component Declarations
    ----------------------------------------------------------------------------
    component MAC_AXIS_SPLITTER is
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
    end component MAC_AXIS_SPLITTER;

    component SPLIT_MAC is
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
    end component SPLIT_MAC;

    component MAC_AXIS_COMBINER is
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
    end component MAC_AXIS_COMBINER;

    COMPONENT fifo_generator_0
      PORT (
        wr_rst_busy : OUT STD_LOGIC;
        rd_rst_busy : OUT STD_LOGIC;
        m_aclk : IN STD_LOGIC;
        s_aclk : IN STD_LOGIC;
        s_aresetn : IN STD_LOGIC;
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        s_axis_tlast : IN STD_LOGIC;
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_tlast : OUT STD_LOGIC
      );
    END COMPONENT;

    COMPONENT fifo_generator_1
      PORT (
        wr_rst_busy : OUT STD_LOGIC;
        rd_rst_busy : OUT STD_LOGIC;
        m_aclk : IN STD_LOGIC;
        s_aclk : IN STD_LOGIC;
        s_aresetn : IN STD_LOGIC;
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_tlast : IN STD_LOGIC;
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_tlast : OUT STD_LOGIC
      );
    END COMPONENT;

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal w_resetn : std_logic;
    signal w_resetn_slow : std_logic;
    signal w_rd_reset_busy_0 : std_logic;
    signal w_wr_reset_busy_0 : std_logic;
    signal w_rd_reset_busy_1 : std_logic;
    signal w_wr_reset_busy_1 : std_logic;
    signal w_rd_reset_busy_2 : std_logic;
    signal w_wr_reset_busy_2 : std_logic;

    signal w_splitter_data_0 : std_logic_vector(15 downto 0);
    signal w_splitter_valid_0 : std_logic;
    signal w_splitter_ready_0 : std_logic;
    signal w_splitter_last_0 : std_logic;

    signal w_splitter_data_1 : std_logic_vector(15 downto 0);
    signal w_splitter_valid_1 : std_logic;
    signal w_splitter_ready_1 : std_logic;
    signal w_splitter_last_1 : std_logic;

    signal w_fifo_0_wr_en : std_logic;
    signal w_fifo_0_rd_en : std_logic;
    signal w_fifo_0_full  : std_logic;
    signal w_fifo_0_empty : std_logic;

    signal w_fifo_data_0 : std_logic_vector(15 downto 0);
    signal w_fifo_valid_0 : std_logic;
    signal w_fifo_ready_0 : std_logic;
    signal w_fifo_last_0 : std_logic;

    signal w_fifo_1_wr_en : std_logic;
    signal w_fifo_1_rd_en : std_logic;
    signal w_fifo_1_full  : std_logic;
    signal w_fifo_1_empty : std_logic;
    
    signal w_fifo_data_1 : std_logic_vector(15 downto 0);
    signal w_fifo_valid_1 : std_logic;
    signal w_fifo_ready_1 : std_logic;
    signal w_fifo_last_1 : std_logic;

    signal w_mac_data_0 : std_logic_vector(31 downto 0);
    signal w_mac_valid_0 : std_logic;
    signal w_mac_ready_0 : std_logic;
    signal w_mac_last_0 : std_logic;

    signal w_mac_data_1 : std_logic_vector(31 downto 0);
    signal w_mac_valid_1 : std_logic;
    signal w_mac_ready_1 : std_logic;
    signal w_mac_last_1 : std_logic;

    signal w_combiner_data : std_logic_vector(31 downto 0);
    signal w_combiner_valid : std_logic;
    signal w_combiner_ready : std_logic;
    signal w_combiner_last : std_logic;

    signal w_fifo_2_wr_en : std_logic;
    signal w_fifo_2_rd_en : std_logic;
    signal w_fifo_2_full  : std_logic;
    signal w_fifo_2_empty : std_logic;
    
    signal w_fifo_data_2 : std_logic_vector(31 downto 0);
    signal w_fifo_valid_2 : std_logic;
    signal w_fifo_ready_2 : std_logic;
    signal w_fifo_last_2 : std_logic;

begin

    ----------------------------------------------------------------------------
    -- Output Signal Assignments
    ----------------------------------------------------------------------------
	M_AXIS_TDATA  <= w_fifo_data_2;
    M_AXIS_TLAST  <= '1';
    M_AXIS_TVALID <= w_fifo_valid_2;

    -- reset_busy <= w_wr_reset_busy_0 or w_wr_reset_busy_1 or w_wr_reset_busy_2 or w_rd_reset_busy_0 or w_rd_reset_busy_1 or w_rd_reset_busy_2;
    reset_busy <= '0' when w_splitter_ready_0 = '1' and w_splitter_ready_1 = '1' and w_combiner_ready = '1' else
                  '1';

    ----------------------------------------------------------------------------
    -- Concurrent Signal Assigments
    ----------------------------------------------------------------------------
    w_resetn <= not rst;
    w_resetn_slow <= not rst_slow;

    -- w_fifo_0_wr_en <= w_splitter_valid_0 and w_splitter_ready_0;
    -- w_fifo_0_rd_en <= w_fifo_valid_0 and w_mac_ready_0;
    -- w_splitter_ready_0 <= not w_fifo_0_full;
    -- w_fifo_valid_0 <= not w_fifo_0_empty;

    -- w_fifo_1_wr_en <= w_splitter_valid_1 and w_splitter_ready_1;
    -- w_fifo_1_rd_en <= w_fifo_valid_1 and w_mac_ready_1;
    -- w_splitter_ready_1 <= not w_fifo_1_full;
    -- w_fifo_valid_1 <= not w_fifo_1_empty;

    -- w_fifo_2_wr_en <= w_combiner_valid and w_combiner_ready;
    -- w_fifo_2_rd_en <= w_fifo_valid_2 and M_AXIS_TREADY;
    -- w_combiner_ready <= not w_fifo_2_full;
    -- w_fifo_valid_2 <= not w_fifo_2_empty;
    
    -----------------------------------------------------------------------------
    -- Component Instantiations
    -----------------------------------------------------------------------------
    U_MAX_AXIS_SPLITTER : MAC_AXIS_SPLITTER
        generic map (
            G_DATA_WIDTH => 16
        )
        port map (
            CLK           => clk_fast,
            RESET         => rst,
    
            S_AXIS_TREADY => S_AXIS_TREADY,
            S_AXIS_TDATA  => S_AXIS_TDATA,
            S_AXIS_TLAST  => S_AXIS_TLAST,
            S_AXIS_TVALID => S_AXIS_TVALID,
    
            M0_AXIS_TREADY => w_splitter_ready_0,
            M0_AXIS_TDATA  => w_splitter_data_0,
            M0_AXIS_TLAST  => w_splitter_last_0,
            M0_AXIS_TVALID => w_splitter_valid_0,
    
            M1_AXIS_TREADY => w_splitter_ready_1,
            M1_AXIS_TDATA  => w_splitter_data_1,
            M1_AXIS_TLAST  => w_splitter_last_1,
            M1_AXIS_TVALID => w_splitter_valid_1
        );

    U_FIFO_0 : fifo_generator_0
    PORT MAP (
        m_aclk => clk_slow,
        s_aclk => clk_fast,
        s_aresetn => w_resetn,
        s_axis_tvalid => w_splitter_valid_0,
        s_axis_tready => w_splitter_ready_0,
        s_axis_tdata => w_splitter_data_0,
        s_axis_tlast => w_splitter_last_0,
        m_axis_tvalid => w_fifo_valid_0,
        m_axis_tready => w_fifo_ready_0,
        m_axis_tdata => w_fifo_data_0,
        m_axis_tlast => w_fifo_last_0,
        wr_rst_busy => w_wr_reset_busy_0,
        rd_rst_busy => w_rd_reset_busy_0
    );

    U_FIFO_1 : fifo_generator_0
    PORT MAP (
        m_aclk => clk_slow,
        s_aclk => clk_fast,
        s_aresetn => w_resetn,
        s_axis_tvalid => w_splitter_valid_1,
        s_axis_tready => w_splitter_ready_1,
        s_axis_tdata => w_splitter_data_1,
        s_axis_tlast => w_splitter_last_1,
        m_axis_tvalid => w_fifo_valid_1,
        m_axis_tready => w_fifo_ready_1,
        m_axis_tdata => w_fifo_data_1,
        m_axis_tlast => w_fifo_last_1,
        wr_rst_busy => w_wr_reset_busy_1,
        rd_rst_busy => w_rd_reset_busy_1
    );

    U_MAC_0 : SPLIT_MAC
        generic map (
            G_DATA_WIDTH => 8,
            G_OUTPUT_DATA_WIDTH => 32
        )
        port map (
            S_AXIS_TREADY => w_fifo_ready_0,
            S_AXIS_TDATA  => w_fifo_data_0,
            S_AXIS_TLAST  => w_fifo_last_0,
            S_AXIS_TVALID => w_fifo_valid_0,
    
            M_AXIS_TREADY => w_mac_ready_0,
            M_AXIS_TDATA  => w_mac_data_0,
            M_AXIS_TLAST  => w_mac_last_0,
            M_AXIS_TVALID => w_mac_valid_0,
    
            RESET         => rst_slow,
            CLK           => clk_slow
        );

    U_MAC_1 : SPLIT_MAC
        generic map (
            G_DATA_WIDTH => 8,
            G_OUTPUT_DATA_WIDTH => 32
        )
        port map (
            S_AXIS_TREADY => w_fifo_ready_1,
            S_AXIS_TDATA  => w_fifo_data_1,
            S_AXIS_TLAST  => w_fifo_last_1,
            S_AXIS_TVALID => w_fifo_valid_1,
        
            M_AXIS_TREADY => w_mac_ready_1,
            M_AXIS_TDATA  => w_mac_data_1,
            M_AXIS_TLAST  => w_mac_last_1,
            M_AXIS_TVALID => w_mac_valid_1,
        
            RESET         => rst_slow,
            CLK           => clk_slow
        );

    U_MAC_AXIS_COMBINER : MAC_AXIS_COMBINER
        generic map (
            G_DATA_WIDTH => 32
        )
        port map ( 
            CLK            => clk_slow,
            RESET          => rst_slow,
    
            BIAS           => bias,
    
            S0_AXIS_TVALID => w_mac_valid_0,
            S0_AXIS_TREADY => w_mac_ready_0,
            S0_AXIS_TDATA  => w_mac_data_0,
            S0_AXIS_TLAST  => w_mac_last_0,
    
            S1_AXIS_TVALID => w_mac_valid_1,
            S1_AXIS_TREADY => w_mac_ready_1,
            S1_AXIS_TDATA  => w_mac_data_1,
            S1_AXIS_TLAST  => w_mac_last_1,
    
            M_AXIS_TVALID  => w_combiner_valid,
            M_AXIS_TREADY  => w_combiner_ready,
            M_AXIS_TDATA   => w_combiner_data,
            M_AXIS_TLAST   => w_combiner_last
        );

    U_FIFO_2 : fifo_generator_1
    PORT MAP (
        m_aclk => clk_fast,
        s_aclk => clk_slow,
        s_aresetn => w_resetn_slow,
        s_axis_tvalid => w_combiner_valid,
        s_axis_tready => w_combiner_ready,
        s_axis_tdata => w_combiner_data,
        s_axis_tlast => w_combiner_last,
        m_axis_tvalid => w_fifo_valid_2,
        m_axis_tready => w_fifo_ready_2,
        m_axis_tdata => w_fifo_data_2,
        m_axis_tlast => w_fifo_last_2,
        wr_rst_busy => w_wr_reset_busy_2,
        rd_rst_busy => w_rd_reset_busy_2
    );

end architecture behavioral;
