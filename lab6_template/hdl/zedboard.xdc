# ----------------------------------------------------------------------------
#     _____
#    / #   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/
# ----------------------------------------------------------------------------
#
#  Created With Avnet UCF Generator V0.4.0
#     Date: Saturday, June 30, 2012
#     Time: 12:18:55 AM
#
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#
#  Please direct any questions to:
#     ZedBoard.org Community Forums
#     http://www.zedboard.org
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2012 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Notes:
#
#  10 August 2012
#     IO standards based upon Bank 34 and Bank 35 Vcco supply options of 1.8V,
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.
#     By default, Vadj is expected to be set to 1.8V but if a different
#     voltage is used for a particular design, then the corresponding IO
#     standard within this UCF should also be updated to reflect the actual
#     Vadj jumper selection.
#
#  09 September 2012
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.
#     HDL net names are adjusted to contain no hyphen characters '-' but
#     rather use underscore '_' characters.  Comment net name with the hyphen
#     characters will remain in place since these are intended to match the
#     schematic net names in order to better enable schematic search.
#
#  17 April 2014
#     Pin constraint for toggle switch SW7 was corrected to M15 location.
#
#  16 April 2015
#     Corrected the way that entire banks are assigned to a particular IO
#     standard so that it works with more recent versions of Vivado Design
#     Suite and moved the IO standard constraints to the end of the file
#     along with some better organization and notes like we do with our SOMs.
#
#   6 June 2016
#     Corrected error in signal name for package pin N19 (FMC Expansion Connector)
#
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Audio Codec - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB1 [get_ports {AC_ADR0}];  # "AC-ADR0"
#set_property PACKAGE_PIN Y5  [get_ports {AC_ADR1}];  # "AC-ADR1"
#set_property PACKAGE_PIN Y8  [get_ports {SDATA_O}];  # "AC-GPIO0"
#set_property PACKAGE_PIN AA7 [get_ports {SDATA_I}];  # "AC-GPIO1"
#set_property PACKAGE_PIN AA6 [get_ports {BCLK_O}];  # "AC-GPIO2"
#set_property PACKAGE_PIN Y6  [get_ports {LRCLK_O}];  # "AC-GPIO3"
#set_property PACKAGE_PIN AB2 [get_ports {MCLK_O}];  # "AC-MCLK"
#set_property PACKAGE_PIN AB4 [get_ports {iic_rtl_scl_io}];  # "AC-SCK"
#set_property PACKAGE_PIN AB5 [get_ports {iic_rtl_sda_io}];  # "AC-SDA"

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y9 [get_ports {GCLK}];  # "GCLK"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y11  [get_ports {JA1}];  # "JA1"
#set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
#set_property PACKAGE_PIN AA11 [get_ports {JA2}];  # "JA2"
#set_property PACKAGE_PIN Y10  [get_ports {JA3}];  # "JA3"
#set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
#set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W12 [get_ports {JB1}];  # "JB1"
#set_property PACKAGE_PIN W11 [get_ports {JB2}];  # "JB2"
#set_property PACKAGE_PIN V10 [get_ports {JB3}];  # "JB3"
#set_property PACKAGE_PIN W8 [get_ports {JB4}];  # "JB4"
#set_property PACKAGE_PIN V12 [get_ports {JB7}];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports {JB8}];  # "JB8"
#set_property PACKAGE_PIN V9 [get_ports {JB9}];  # "JB9"
#set_property PACKAGE_PIN V8 [get_ports {JB10}];  # "JB10"

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB6 [get_ports {JC1_N}];  # "JC1_N"
#set_property PACKAGE_PIN AB7 [get_ports {JC1_P}];  # "JC1_P"
#set_property PACKAGE_PIN AA4 [get_ports {JC2_N}];  # "JC2_N"
#set_property PACKAGE_PIN Y4  [get_ports {JC2_P}];  # "JC2_P"
#set_property PACKAGE_PIN T6  [get_ports {JC3_N}];  # "JC3_N"
#set_property PACKAGE_PIN R6  [get_ports {JC3_P}];  # "JC3_P"
#set_property PACKAGE_PIN U4  [get_ports {JC4_N}];  # "JC4_N"
#set_property PACKAGE_PIN T4  [get_ports {JC4_P}];  # "JC4_P"

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W7 [get_ports {JD1_N}];  # "JD1_N"
#set_property PACKAGE_PIN V7 [get_ports {JD1_P}];  # "JD1_P"
#set_property PACKAGE_PIN V4 [get_ports {JD2_N}];  # "JD2_N"
#set_property PACKAGE_PIN V5 [get_ports {JD2_P}];  # "JD2_P"
#set_property PACKAGE_PIN W5 [get_ports {JD3_N}];  # "JD3_N"
#set_property PACKAGE_PIN W6 [get_ports {JD3_P}];  # "JD3_P"
#set_property PACKAGE_PIN U5 [get_ports {JD4_N}];  # "JD4_N"
#set_property PACKAGE_PIN U6 [get_ports {JD4_P}];  # "JD4_P"

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN U10  [get_ports {OLED_DC}];  # "OLED-DC"
#set_property PACKAGE_PIN U9   [get_ports {OLED_RES}];  # "OLED-RES"
#set_property PACKAGE_PIN AB12 [get_ports {OLED_SCLK}];  # "OLED-SCLK"
#set_property PACKAGE_PIN AA12 [get_ports {OLED_SDIN}];  # "OLED-SDIN"
#set_property PACKAGE_PIN U11  [get_ports {OLED_VBAT}];  # "OLED-VBAT"
#set_property PACKAGE_PIN U12  [get_ports {OLED_VDD}];  # "OLED-VDD"

# ----------------------------------------------------------------------------
# HDMI Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN W18  [get_ports {HD_CLK}];  # "HD-CLK"
#set_property PACKAGE_PIN Y13  [get_ports {HD_D0}];  # "HD-D0"
#set_property PACKAGE_PIN AA13 [get_ports {HD_D1}];  # "HD-D1"
#set_property PACKAGE_PIN W13  [get_ports {HD_D10}];  # "HD-D10"
#set_property PACKAGE_PIN W15  [get_ports {HD_D11}];  # "HD-D11"
#set_property PACKAGE_PIN V15  [get_ports {HD_D12}];  # "HD-D12"
#set_property PACKAGE_PIN U17  [get_ports {HD_D13}];  # "HD-D13"
#set_property PACKAGE_PIN V14  [get_ports {HD_D14}];  # "HD-D14"
#set_property PACKAGE_PIN V13  [get_ports {HS_D15}];  # "HD-D15"
#set_property PACKAGE_PIN AA14 [get_ports {HD_D2}];  # "HD-D2"
#set_property PACKAGE_PIN Y14  [get_ports {HD_D3}];  # "HD-D3"
#set_property PACKAGE_PIN AB15 [get_ports {HD_D4}];  # "HD-D4"
#set_property PACKAGE_PIN AB16 [get_ports {HD_D5}];  # "HD-D5"
#set_property PACKAGE_PIN AA16 [get_ports {HD_D6}];  # "HD-D6"
#set_property PACKAGE_PIN AB17 [get_ports {HD_D7}];  # "HD-D7"
#set_property PACKAGE_PIN AA17 [get_ports {HD_D8}];  # "HD-D8"
#set_property PACKAGE_PIN Y15  [get_ports {HD_D9}];  # "HD-D9"
#set_property PACKAGE_PIN U16  [get_ports {HD_DE}];  # "HD-DE"
#set_property PACKAGE_PIN V17  [get_ports {HD_HSYNC}];  # "HD-HSYNC"
#set_property PACKAGE_PIN W16  [get_ports {HD_INT}];  # "HD-INT"
#set_property PACKAGE_PIN AA18 [get_ports {HD_SCL}];  # "HD-SCL"
#set_property PACKAGE_PIN Y16  [get_ports {HD_SDA}];  # "HD-SDA"
#set_property PACKAGE_PIN U15  [get_ports {HD_SPDIF}];  # "HD-SPDIF"
#set_property PACKAGE_PIN Y18  [get_ports {HD_SPDIFO}];  # "HD-SPDIFO"
#set_property PACKAGE_PIN W17  [get_ports {HD_VSYNC}];  # "HD-VSYNC"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
#set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
#set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
#set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN Y21  [get_ports {VGA_B1}];  # "VGA-B1"
#set_property PACKAGE_PIN Y20  [get_ports {VGA_B2}];  # "VGA-B2"
#set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}];  # "VGA-B3"
#set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}];  # "VGA-B4"
#set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}];  # "VGA-G1"
#set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}];  # "VGA-G2"
#set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}];  # "VGA-G3"
#set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}];  # "VGA-G4"
#set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}];  # "VGA-HS"
#set_property PACKAGE_PIN V20  [get_ports {VGA_R1}];  # "VGA-R1"
#set_property PACKAGE_PIN U20  [get_ports {VGA_R2}];  # "VGA-R2"
#set_property PACKAGE_PIN V19  [get_ports {VGA_R3}];  # "VGA-R3"
#set_property PACKAGE_PIN V18  [get_ports {VGA_R4}];  # "VGA-R4"
#set_property PACKAGE_PIN Y19  [get_ports {VGA_VS}];  # "VGA-VS"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN P16 [get_ports {BTNC}];  # "BTNC"
#set_property PACKAGE_PIN R16 [get_ports {BTND}];  # "BTND"
#set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"
#set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"
#set_property PACKAGE_PIN T18 [get_ports {BTNU}];  # "BTNU"

# ----------------------------------------------------------------------------
# USB OTG Reset - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L16 [get_ports {OTG_VBUSOC}];  # "OTG-VBUSOC"

# ----------------------------------------------------------------------------
# XADC GIO - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN H15 [get_ports {XADC_GIO0}];  # "XADC-GIO0"
#set_property PACKAGE_PIN R15 [get_ports {XADC_GIO1}];  # "XADC-GIO1"
#set_property PACKAGE_PIN K15 [get_ports {XADC_GIO2}];  # "XADC-GIO2"
#set_property PACKAGE_PIN J15 [get_ports {XADC_GIO3}];  # "XADC-GIO3"

# ----------------------------------------------------------------------------
# Miscellaneous - Bank 34
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN K16 [get_ports {PUDC_B}];  # "PUDC_B"

## ----------------------------------------------------------------------------
## USB OTG Reset - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN G17 [get_ports {OTG_RESETN}];  # "OTG-RESETN"

## ----------------------------------------------------------------------------
## User DIP Switches - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN F22 [get_ports {SW0}];  # "SW0"
#set_property PACKAGE_PIN G22 [get_ports {SW1}];  # "SW1"
#set_property PACKAGE_PIN H22 [get_ports {SW2}];  # "SW2"
#set_property PACKAGE_PIN F21 [get_ports {SW3}];  # "SW3"
#set_property PACKAGE_PIN H19 [get_ports {SW4}];  # "SW4"
#set_property PACKAGE_PIN H18 [get_ports {SW5}];  # "SW5"
#set_property PACKAGE_PIN H17 [get_ports {SW6}];  # "SW6"
#set_property PACKAGE_PIN M15 [get_ports {SW7}];  # "SW7"

## ----------------------------------------------------------------------------
## XADC AD Channels - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN E16 [get_ports {AD0N_R}];  # "XADC-AD0N-R"
#set_property PACKAGE_PIN F16 [get_ports {AD0P_R}];  # "XADC-AD0P-R"
#set_property PACKAGE_PIN D17 [get_ports {AD8N_N}];  # "XADC-AD8N-R"
#set_property PACKAGE_PIN D16 [get_ports {AD8P_R}];  # "XADC-AD8P-R"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 13
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN R7 [get_ports {FMC_SCL}];  # "FMC-SCL"
#set_property PACKAGE_PIN U7 [get_ports {FMC_SDA}];  # "FMC-SDA"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 33
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN AB14 [get_ports {FMC_PRSNT}];  # "FMC-PRSNT"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 34
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN L19 [get_ports {FMC_CLK0_N}];  # "FMC-CLK0_N"
#set_property PACKAGE_PIN L18 [get_ports {FMC_CLK0_P}];  # "FMC-CLK0_P"
#set_property PACKAGE_PIN M20 [get_ports {FMC_LA00_CC_N}];  # "FMC-LA00_CC_N"
#set_property PACKAGE_PIN M19 [get_ports {FMC_LA00_CC_P}];  # "FMC-LA00_CC_P"
#set_property PACKAGE_PIN N20 [get_ports {FMC_LA01_CC_N}];  # "FMC-LA01_CC_N"
#set_property PACKAGE_PIN N19 [get_ports {FMC_LA01_CC_P}];  # "FMC-LA01_CC_P" - corrected 6/6/16 GE
#set_property PACKAGE_PIN P18 [get_ports {FMC_LA02_N}];  # "FMC-LA02_N"
#set_property PACKAGE_PIN P17 [get_ports {FMC_LA02_P}];  # "FMC-LA02_P"
#set_property PACKAGE_PIN P22 [get_ports {FMC_LA03_N}];  # "FMC-LA03_N"
#set_property PACKAGE_PIN N22 [get_ports {FMC_LA03_P}];  # "FMC-LA03_P"
#set_property PACKAGE_PIN M22 [get_ports {FMC_LA04_N}];  # "FMC-LA04_N"
#set_property PACKAGE_PIN M21 [get_ports {FMC_LA04_P}];  # "FMC-LA04_P"
#set_property PACKAGE_PIN K18 [get_ports {FMC_LA05_N}];  # "FMC-LA05_N"
#set_property PACKAGE_PIN J18 [get_ports {FMC_LA05_P}];  # "FMC-LA05_P"
#set_property PACKAGE_PIN L22 [get_ports {FMC_LA06_N}];  # "FMC-LA06_N"
#set_property PACKAGE_PIN L21 [get_ports {FMC_LA06_P}];  # "FMC-LA06_P"
#set_property PACKAGE_PIN T17 [get_ports {FMC_LA07_N}];  # "FMC-LA07_N"
#set_property PACKAGE_PIN T16 [get_ports {FMC_LA07_P}];  # "FMC-LA07_P"
#set_property PACKAGE_PIN J22 [get_ports {FMC_LA08_N}];  # "FMC-LA08_N"
#set_property PACKAGE_PIN J21 [get_ports {FMC_LA08_P}];  # "FMC-LA08_P"
#set_property PACKAGE_PIN R21 [get_ports {FMC_LA09_N}];  # "FMC-LA09_N"
#set_property PACKAGE_PIN R20 [get_ports {FMC_LA09_P}];  # "FMC-LA09_P"
#set_property PACKAGE_PIN T19 [get_ports {FMC_LA10_N}];  # "FMC-LA10_N"
#set_property PACKAGE_PIN R19 [get_ports {FMC_LA10_P}];  # "FMC-LA10_P"
#set_property PACKAGE_PIN N18 [get_ports {FMC_LA11_N}];  # "FMC-LA11_N"
#set_property PACKAGE_PIN N17 [get_ports {FMC_LA11_P}];  # "FMC-LA11_P"
#set_property PACKAGE_PIN P21 [get_ports {FMC_LA12_N}];  # "FMC-LA12_N"
#set_property PACKAGE_PIN P20 [get_ports {FMC_LA12_P}];  # "FMC-LA12_P"
#set_property PACKAGE_PIN M17 [get_ports {FMC_LA13_N}];  # "FMC-LA13_N"
#set_property PACKAGE_PIN L17 [get_ports {FMC_LA13_P}];  # "FMC-LA13_P"
#set_property PACKAGE_PIN K20 [get_ports {FMC_LA14_N}];  # "FMC-LA14_N"
#set_property PACKAGE_PIN K19 [get_ports {FMC_LA14_P}];  # "FMC-LA14_P"
#set_property PACKAGE_PIN J17 [get_ports {FMC_LA15_N}];  # "FMC-LA15_N"
#set_property PACKAGE_PIN J16 [get_ports {FMC_LA15_P}];  # "FMC-LA15_P"
#set_property PACKAGE_PIN K21 [get_ports {FMC_LA16_N}];  # "FMC-LA16_N"
#set_property PACKAGE_PIN J20 [get_ports {FMC_LA16_P}];  # "FMC-LA16_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 35
## ----------------------------------------------------------------------------
#set_property PACKAGE_PIN C19 [get_ports {FMC_CLK1_N}];  # "FMC-CLK1_N"
#set_property PACKAGE_PIN D18 [get_ports {FMC_CLK1_P}];  # "FMC-CLK1_P"
#set_property PACKAGE_PIN B20 [get_ports {FMC_LA17_CC_N}];  # "FMC-LA17_CC_N"
#set_property PACKAGE_PIN B19 [get_ports {FMC_LA17_CC_P}];  # "FMC-LA17_CC_P"
#set_property PACKAGE_PIN C20 [get_ports {FMC_LA18_CC_N}];  # "FMC-LA18_CC_N"
#set_property PACKAGE_PIN D20 [get_ports {FMC_LA18_CC_P}];  # "FMC-LA18_CC_P"
#set_property PACKAGE_PIN G16 [get_ports {FMC_LA19_N}];  # "FMC-LA19_N"
#set_property PACKAGE_PIN G15 [get_ports {FMC_LA19_P}];  # "FMC-LA19_P"
#set_property PACKAGE_PIN G21 [get_ports {FMC_LA20_N}];  # "FMC-LA20_N"
#set_property PACKAGE_PIN G20 [get_ports {FMC_LA20_P}];  # "FMC-LA20_P"
#set_property PACKAGE_PIN E20 [get_ports {FMC_LA21_N}];  # "FMC-LA21_N"
#set_property PACKAGE_PIN E19 [get_ports {FMC_LA21_P}];  # "FMC-LA21_P"
#set_property PACKAGE_PIN F19 [get_ports {FMC_LA22_N}];  # "FMC-LA22_N"
#set_property PACKAGE_PIN G19 [get_ports {FMC_LA22_P}];  # "FMC-LA22_P"
#set_property PACKAGE_PIN D15 [get_ports {FMC_LA23_N}];  # "FMC-LA23_N"
#set_property PACKAGE_PIN E15 [get_ports {FMC_LA23_P}];  # "FMC-LA23_P"
#set_property PACKAGE_PIN A19 [get_ports {FMC_LA24_N}];  # "FMC-LA24_N"
#set_property PACKAGE_PIN A18 [get_ports {FMC_LA24_P}];  # "FMC-LA24_P"
#set_property PACKAGE_PIN C22 [get_ports {FMC_LA25_N}];  # "FMC-LA25_N"
#set_property PACKAGE_PIN D22 [get_ports {FMC_LA25_P}];  # "FMC-LA25_P"
#set_property PACKAGE_PIN E18 [get_ports {FMC_LA26_N}];  # "FMC-LA26_N"
#set_property PACKAGE_PIN F18 [get_ports {FMC_LA26_P}];  # "FMC-LA26_P"
#set_property PACKAGE_PIN D21 [get_ports {FMC_LA27_N}];  # "FMC-LA27_N"
#set_property PACKAGE_PIN E21 [get_ports {FMC_LA27_P}];  # "FMC-LA27_P"
#set_property PACKAGE_PIN A17 [get_ports {FMC_LA28_N}];  # "FMC-LA28_N"
#set_property PACKAGE_PIN A16 [get_ports {FMC_LA28_P}];  # "FMC-LA28_P"
#set_property PACKAGE_PIN C18 [get_ports {FMC_LA29_N}];  # "FMC-LA29_N"
#set_property PACKAGE_PIN C17 [get_ports {FMC_LA29_P}];  # "FMC-LA29_P"
#set_property PACKAGE_PIN B15 [get_ports {FMC_LA30_N}];  # "FMC-LA30_N"
#set_property PACKAGE_PIN C15 [get_ports {FMC_LA30_P}];  # "FMC-LA30_P"
#set_property PACKAGE_PIN B17 [get_ports {FMC_LA31_N}];  # "FMC-LA31_N"
#set_property PACKAGE_PIN B16 [get_ports {FMC_LA31_P}];  # "FMC-LA31_P"
#set_property PACKAGE_PIN A22 [get_ports {FMC_LA32_N}];  # "FMC-LA32_N"
#set_property PACKAGE_PIN A21 [get_ports {FMC_LA32_P}];  # "FMC-LA32_P"
#set_property PACKAGE_PIN B22 [get_ports {FMC_LA33_N}];  # "FMC-LA33_N"
#set_property PACKAGE_PIN B21 [get_ports {FMC_LA33_P}];  # "FMC-LA33_P"


# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are
# evaluated prior to other PACKAGE_PIN constraints being applied, then
# the IOSTANDARD specified will likely not be applied properly to those
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed
# within the XDC file in a location that is evaluated AFTER all
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ----------------------------------------------------------------------------

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];

#create_clock -period 5.00 -name main -waveform {0.000 0.050} [get_ports ACLK]
create_clock -period 5.00 -name main -waveform {0.000 2.500} [get_ports ACLK]









create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list conv_accelerator_bd_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/q_bram_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_w[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/output_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 17 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/initial_offset[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 17 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/elements_per_channel[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 17 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_input_addr[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 11 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/q_filter_addr[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zeroed[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_zero[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_tvalid[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_tvalid[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_tvalid[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_tvalid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scale[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_saturated[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_scaled[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/q_relued[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/q_accumulator[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 16 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TDATA[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/q_accumulator[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 16 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TDATA[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 16 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TDATA[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/q_accumulator[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 16 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TDATA[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 32 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[0]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[1]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[2]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[3]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[4]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[5]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[6]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[7]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[8]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[9]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[10]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[11]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[12]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[13]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[14]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[15]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[16]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[17]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[18]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[19]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[20]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[21]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[22]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[23]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[24]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[25]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[26]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[27]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[28]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[29]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[30]} {conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/q_accumulator[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/conv_complete]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/conv_idle]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_output_storage/max_pooling]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_dequantization/relu]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/S_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/S_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/S_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/S_AXIS_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/w_add_bias]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/w_add_bias]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/w_add_bias]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/w_add_bias]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/w_filter_channel_ovf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/w_filter_height_ovf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/w_filter_width_ovf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/w_output_height_ovf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_index_gen/w_output_width_ovf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/w_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/w_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/w_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/w_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac2/w_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac0/w_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac1/w_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list conv_accelerator_bd_i/conv_accelerator_wra_0/U0/g_conv_accel/g_mac3/w_tvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
