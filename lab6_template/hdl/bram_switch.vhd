----------------------------------------------------------------------------------
-- BRAM Switch
-- Switch between two controllers of a BRAM module port
-- Configure the BRAM module to Stand Alone mode.
--
-- Gregory Ling, 2024
----------------------------------------------------------------------------------

library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bram_switch is
    generic(
        ADDR_WIDTH : integer := 32;
        DATA_WIDTH : integer := 32
    );
    port(
        BRAM_PORT0_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        BRAM_PORT0_clk : in std_logic;
        BRAM_PORT0_din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        BRAM_PORT0_dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
        BRAM_PORT0_en : in std_logic;
        BRAM_PORT0_we : in std_logic_vector((DATA_WIDTH/8)-1 downto 0);
        BRAM_PORT0_rst : in std_logic;

        BRAM_PORT1_addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        BRAM_PORT1_clk : in std_logic;
        BRAM_PORT1_din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        BRAM_PORT1_dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
        BRAM_PORT1_en : in std_logic;
        BRAM_PORT1_we : in std_logic_vector((DATA_WIDTH/8)-1 downto 0);
        BRAM_PORT1_rst : in std_logic;

        BLK_MEM_PORT0_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        BLK_MEM_PORT0_clk : out std_logic;
        BLK_MEM_PORT0_din : out std_logic_vector(DATA_WIDTH-1 downto 0);
        BLK_MEM_PORT0_dout : in std_logic_vector(DATA_WIDTH-1 downto 0);
        BLK_MEM_PORT0_en : out std_logic;
        BLK_MEM_PORT0_we : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
        BLK_MEM_PORT0_rst : out std_logic;

        BLK_MEM_PORT1_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        BLK_MEM_PORT1_clk : out std_logic;
        BLK_MEM_PORT1_din : out std_logic_vector(DATA_WIDTH-1 downto 0);
        BLK_MEM_PORT1_dout : in std_logic_vector(DATA_WIDTH-1 downto 0);
        BLK_MEM_PORT1_en : out std_logic;
        BLK_MEM_PORT1_we : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
        BLK_MEM_PORT1_rst : out std_logic;

        invert_banks : in std_logic
    );
end bram_switch;

architecture Behavioral of bram_switch is

    attribute X_INTERFACE_INFO : STRING;
    attribute X_INTERFACE_MODE : STRING;

    attribute X_INTERFACE_INFO of BRAM_PORT0_addr:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 ADDR";
    attribute X_INTERFACE_INFO of BRAM_PORT0_clk:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 CLK";
    attribute X_INTERFACE_INFO of BRAM_PORT0_din:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 DIN";
    attribute X_INTERFACE_INFO of BRAM_PORT0_dout:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 DOUT";
    attribute X_INTERFACE_INFO of BRAM_PORT0_en:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 EN";
    attribute X_INTERFACE_INFO of BRAM_PORT0_we:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 WE";
    attribute X_INTERFACE_INFO of BRAM_PORT0_rst:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT0 RST";

    attribute X_INTERFACE_INFO of BRAM_PORT1_addr:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 ADDR";
    attribute X_INTERFACE_INFO of BRAM_PORT1_clk:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 CLK";
    attribute X_INTERFACE_INFO of BRAM_PORT1_din:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 DIN";
    attribute X_INTERFACE_INFO of BRAM_PORT1_dout:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 DOUT";
    attribute X_INTERFACE_INFO of BRAM_PORT1_en:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 EN";
    attribute X_INTERFACE_INFO of BRAM_PORT1_we:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 WE";
    attribute X_INTERFACE_INFO of BRAM_PORT1_rst:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_PORT1 RST";

    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_addr:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 ADDR";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_clk:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 CLK";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_din:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 DIN";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_dout:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 DOUT";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_en:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 EN";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_we:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 WE";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT0_rst:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT0 RST";

    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_addr:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 ADDR";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_clk:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 CLK";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_din:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 DIN";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_dout:  SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 DOUT";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_en:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 EN";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_we:    SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 WE";
    attribute X_INTERFACE_INFO of BLK_MEM_PORT1_rst:   SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BLK_MEM_PORT1 RST";

    attribute X_INTERFACE_MODE of BLK_MEM_PORT0_addr:  SIGNAL is "Master"; 
    attribute X_INTERFACE_MODE of BLK_MEM_PORT1_addr:  SIGNAL is "Master"; 
begin

    BRAM_PORT0_dout <= BLK_MEM_PORT0_dout when (invert_banks = '0') else BLK_MEM_PORT1_dout;
    BRAM_PORT1_dout     <= BLK_MEM_PORT1_dout when (invert_banks = '0') else BLK_MEM_PORT0_dout;
    BLK_MEM_PORT0_addr  <= BRAM_PORT0_addr when (invert_banks = '0') else BRAM_PORT1_addr;
    BLK_MEM_PORT0_din   <= BRAM_PORT0_din when (invert_banks = '0') else BRAM_PORT1_din;
    BLK_MEM_PORT0_en    <= BRAM_PORT0_en when (invert_banks = '0') else BRAM_PORT1_en;
    BLK_MEM_PORT0_we    <= BRAM_PORT0_we when (invert_banks = '0') else BRAM_PORT1_we;
    BLK_MEM_PORT0_rst   <= BRAM_PORT0_rst when (invert_banks = '0') else BRAM_PORT1_rst;
    BLK_MEM_PORT1_addr  <= BRAM_PORT1_addr when (invert_banks = '0') else BRAM_PORT0_addr;
    BLK_MEM_PORT1_din   <= BRAM_PORT1_din when (invert_banks = '0') else BRAM_PORT0_din;
    BLK_MEM_PORT1_en    <= BRAM_PORT1_en when (invert_banks = '0') else BRAM_PORT0_en;
    BLK_MEM_PORT1_we    <= BRAM_PORT1_we when (invert_banks = '0') else BRAM_PORT0_we;
    BLK_MEM_PORT1_rst   <= BRAM_PORT1_rst when (invert_banks = '0') else BRAM_PORT0_rst;
    
    -- Clocks must be the same and connected together externally, the clocks are not muxed!
    BLK_MEM_PORT0_clk   <= BRAM_PORT0_clk;
    BLK_MEM_PORT1_clk   <= BRAM_PORT1_clk;

end Behavioral;
