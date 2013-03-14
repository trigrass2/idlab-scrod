----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.readout_definitions.all; --Definitions in readout_definitions.vhd
use work.asic_definitions_irs3b_carrier_revB.all;
use work.i2c_types.all; --Definitions in i2c_general_interfaces.vhd
use work.IRS3B_CarrierRevB_DAC_definitions.all; -- Definitions in irs3b_carrierRevB_DAC_definitions.vhd

entity scrod_top is
	Port(
		BOARD_CLOCKP                :  in STD_LOGIC;
		BOARD_CLOCKN                :  in STD_LOGIC;
		LEDS                        : out STD_LOGIC_VECTOR(15 downto 0);
		------------------FTSW/CLK_FIN pins------------------
		RJ45_ACK_P                  : out std_logic;
		RJ45_ACK_N                  : out std_logic;			  
		RJ45_TRG_P                  :  in std_logic;
		RJ45_TRG_N                  :  in std_logic;			  			  
		RJ45_RSV_P                  :  in std_logic;
		RJ45_RSV_N                  :  in std_logic;
		RJ45_CLK_P                  :  in std_logic;
		RJ45_CLK_N                  :  in std_logic;
		---------Jumper for choosing distributed clock------
		USE_LOCAL_CLOCK_JUMPER      :  in std_logic;
		------------------I2C pins-------------------
		I2C_SCL                     : inout STD_LOGIC_VECTOR(N_I2C_BUSES-1 downto 0);
		I2C_SDA                     : inout STD_LOGIC_VECTOR(N_I2C_BUSES-1 downto 0);
		I2C_DAC_SCL_R01             : inout STD_LOGIC;
		I2C_DAC_SDA_R01             : inout STD_LOGIC;
		I2C_DAC_SCL_R23             : inout STD_LOGIC;
		I2C_DAC_SDA_R23             : inout STD_LOGIC;
		
		----------------------------------------------
		------------ASIC Related Pins-----------------
		----------------------------------------------
		--ASIC sampling signals (SST in)
		AsicIn_SAMPLING_HOLD_MODE_C   : out std_logic_vector(3 downto 0);
--		--ASIC timing monitor (PHASE/PHAB/etc.)
--		AsicOut_SAMPLING_TIMING_MONITOR_C0_R : in std_logic_vector(3 downto 0); --New
--		AsicOut_SAMPLING_TIMING_MONITOR_C1_R : in std_logic_vector(3 downto 0); --New
--		AsicOut_SAMPLING_TIMING_MONITOR_C2_R : in std_logic_vector(3 downto 0); --New
--		AsicOut_SAMPLING_TIMING_MONITOR_C3_R : in std_logic_vector(3 downto 0); --New
--		--ASIC data buses (one per column) 
--		AsicOut_DATA_BUS_C0 : in std_logic_vector(11 downto 0); --New
--		AsicOut_DATA_BUS_C1 : in std_logic_vector(11 downto 0); --New
--		AsicOut_DATA_BUS_C2 : in std_logic_vector(11 downto 0); --New
--		AsicOut_DATA_BUS_C3 : in std_logic_vector(11 downto 0); --New
--		--ASIC data bus output enables (one per row)
--		AsicIn_DATA_OUTPUT_DISABLE_R : out std_logic_vector(3 downto 0); --New
--		--ASIC Wilkinson start/clear/ramp signals
--		AsicIn_WILK_COUNTER_START_C  : out std_logic_vector(3 downto 0); --New
--		AsicIn_WILK_COUNTER_RESET    : out std_logic; --New
--		AsicIn_WILK_RAMP_ACTIVE      : out std_logic; --New
--		--ASIC write address (LSB is now absorbed inside the ASIC) and enable
--		AsicIn_SAMPLING_TO_STORAGE_ADDRESS        : out std_logic_vector(8 downto 1); --New
--		AsicIn_SAMPLING_TO_STORAGE_ADDRESS_ENABLE : out std_logic; --New
--		--ASIC read address interface
--		AsicIn_STORAGE_TO_WILK_ENABLE                     : out std_logic; --New
--		AsicIn_STORAGE_TO_WILK_ADDRESS_SERIAL_SHIFT_CLOCK : out std_logic; --New
--		AsicIn_STORAGE_TO_WILK_ADDRESS_DIR                : out std_logic; --New
--		AsicIn_STORAGE_TO_WILK_ADDRESS_SERIAL_INPUT       : out std_logic; --New
--		--ASIC channel/sample address interface
--		AsicIn_CHANNEL_AND_SAMPLE_ADDRESS_SERIAL_SHIFT_CLOCK : out std_logic; --New
--		AsicIn_CHANNEL_AND_SAMPLE_ADDRESS_DIR                : out std_logic; --New
--		AsicIn_CHANNEL_AND_SAMPLE_ADDRESS_SERIAL_INPUT       : out std_logic; --New
		--ASIC trigger interface signals
		AsicOut_TRIG_OUTPUT_R0_C0_CH	:  in std_logic_vector(7 downto 0); 
		AsicOut_TRIG_OUTPUT_R0_C1_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R0_C2_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R0_C3_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R1_C0_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R1_C1_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R1_C2_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R1_C3_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R2_C0_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R2_C1_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R2_C2_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R2_C3_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R3_C0_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R3_C1_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R3_C2_CH	:  in std_logic_vector(7 downto 0);
		AsicOut_TRIG_OUTPUT_R3_C3_CH	:  in std_logic_vector(7 downto 0);
		--Serial-to-parallel interface
		AsicIn_PARALLEL_CLOCK_C0_R    : out std_logic_vector(3 downto 0);
		AsicIn_PARALLEL_CLOCK_C1_R    : out std_logic_vector(3 downto 0);
		AsicIn_PARALLEL_CLOCK_C2_R    : out std_logic_vector(3 downto 0);
		AsicIn_PARALLEL_CLOCK_C3_R    : out std_logic_vector(3 downto 0);
		AsicIn_CLEAR_ALL_REGISTERS    : out std_logic;
		AsicIn_SERIAL_SHIFT_CLOCK     : out std_logic;
		AsicIn_SERIAL_INPUT           : out std_logic;
		---------------------------------------------
		--------- ASIC monitoring/feedbacks ---------
		---------------------------------------------	
		--ASIC Wilkinson monitor signals
		AsicOut_MONITOR_WILK_COUNTER_C0_R : in std_logic_vector(3 downto 0);
		AsicOut_MONITOR_WILK_COUNTER_C1_R : in std_logic_vector(3 downto 0);
		AsicOut_MONITOR_WILK_COUNTER_C2_R : in std_logic_vector(3 downto 0);
		AsicOut_MONITOR_WILK_COUNTER_C3_R : in std_logic_vector(3 downto 0);
		--ASIC Sampling rate monitor signals
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C0_R : in std_logic_vector(3 downto 0);
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C1_R : in std_logic_vector(3 downto 0);
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C2_R : in std_logic_vector(3 downto 0);
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C3_R : in std_logic_vector(3 downto 0);
		

		----------------------------------------------
		------------Fiberoptic Pins ------------------
		----------------------------------------------
		FIBER_0_RXP                 : in  STD_LOGIC;
		FIBER_0_RXN                 : in  STD_LOGIC;
		FIBER_1_RXP                 : in  STD_LOGIC;
		FIBER_1_RXN                 : in  STD_LOGIC;
		FIBER_0_TXP                 : out STD_LOGIC;
		FIBER_0_TXN                 : out STD_LOGIC;
		FIBER_1_TXP                 : out STD_LOGIC;
		FIBER_1_TXN                 : out STD_LOGIC;
		FIBER_REFCLKP               : in  STD_LOGIC;
		FIBER_REFCLKN               : in  STD_LOGIC;
		FIBER_0_DISABLE_TRANSCEIVER : out STD_LOGIC;
		FIBER_1_DISABLE_TRANSCEIVER : out STD_LOGIC;
		FIBER_0_LINK_UP             : out STD_LOGIC;
		FIBER_1_LINK_UP             : out STD_LOGIC;
		FIBER_0_LINK_ERR            : out STD_LOGIC;
		FIBER_1_LINK_ERR            : out STD_LOGIC;
		---------------------------------------------
		------------------USB pins-------------------
		---------------------------------------------
		USB_IFCLK                   : in  STD_LOGIC;
		USB_CTL0                    : in  STD_LOGIC;
		USB_CTL1                    : in  STD_LOGIC;
		USB_CTL2                    : in  STD_LOGIC;
		USB_FDD                     : inout STD_LOGIC_VECTOR(15 downto 0);
		USB_PA0                     : out STD_LOGIC;
		USB_PA1                     : out STD_LOGIC;
		USB_PA2                     : out STD_LOGIC;
		USB_PA3                     : out STD_LOGIC;
		USB_PA4                     : out STD_LOGIC;
		USB_PA5                     : out STD_LOGIC;
		USB_PA6                     : out STD_LOGIC;
		USB_PA7                     : in  STD_LOGIC;
		USB_RDY0                    : out STD_LOGIC;
		USB_RDY1                    : out STD_LOGIC;
		USB_WAKEUP                  : in  STD_LOGIC;
		USB_CLKOUT		             : in  STD_LOGIC
				
	);
end scrod_top;

architecture Behavioral of scrod_top is
	--Conections to the clock generation block
	signal internal_HARDWARE_TRIGGER : std_logic;
	signal internal_CLOCK_50MHz_BUFG : std_logic;
	signal internal_CLOCK_4xSST_BUFG : std_logic;
	signal internal_CLOCK_2xSST_CE   : std_logic;
	signal internal_CLOCK_SST_BUFG   : std_logic;
	signal internal_CLOCK_ENABLE_I2C : std_logic;
	--Connections to the I2C interfaces
	signal internal_I2C_WRITE_REGISTERS : i2c_rw_registers;
	signal internal_I2C_READ_REGISTERS  : i2c_rw_registers;
	
	--Connections to the ASIC trigger bits
	signal internal_ASIC_TRIGGER_BITS_C_R_CH : COL_ROW_TRIGGER_BITS;
	--Connections to the ASIC trigger bit scaler monitors
	signal internal_TRIGGER_SCALER_ROW_SELECT : std_logic_vector(ROW_SELECT_BITS-1 downto 0);
	signal internal_TRIGGER_SCALER_COL_SELECT : std_logic_vector(COL_SELECT_BITS-1 downto 0);
	signal internal_ASIC_SCALERS_TO_READ      : ASIC_TRIGGER_SCALERS;

	--ASIC DAC writing
	signal PCLK_out	: std_logic_vector(15 downto 0);

	--ASIC DAC values
	--DAC_setting indicates a global for the whole boardstack
	--DAC_setting_C_R indicates a (4)(4) to set DACs separately by row/col
	--DAC_setting_C_R_CH indicates a (4)(4)(8) to set DACs separately by row/col/ch
	signal internal_ASIC_TRIG_THRESH         : DAC_setting_C_R_CH;
	signal internal_ASIC_DAC_BUF_BIASES      : DAC_setting;
	signal internal_ASIC_DAC_BUF_BIAS_ISEL   : DAC_setting;
	signal internal_ASIC_DAC_BUF_BIAS_VADJP  : DAC_setting;
	signal internal_ASIC_DAC_BUF_BIAS_VADJN  : DAC_setting;
	signal internal_ASIC_VBIAS               : DAC_setting_C_R;
	signal internal_ASIC_VBIAS2              : DAC_setting_C_R;
	signal internal_ASIC_REG_TRG             : Timing_setting; --Not a DAC but set with the DACs.  Global for all ASICs.
	signal internal_ASIC_WBIAS               : DAC_setting_C_R;
	signal internal_ASIC_VADJP               : DAC_setting_C_R;
	signal internal_ASIC_VADJN               : DAC_setting_C_R;
	signal internal_ASIC_VDLY                : DAC_setting_C_R;
	signal internal_ASIC_TRG_BIAS            : DAC_setting;
	signal internal_ASIC_TRG_BIAS2           : DAC_setting;
	signal internal_ASIC_TRGTHREF            : DAC_setting;
	signal internal_ASIC_CMPBIAS             : DAC_setting;
	signal internal_ASIC_PUBIAS              : DAC_setting;
	signal internal_ASIC_SBBIAS              : DAC_setting;
	signal internal_ASIC_ISEL                : DAC_setting;
	--Timing settings go here too, since they're set with the DACs
	signal internal_ASIC_TIMING_SSP_LEADING      : Timing_setting_C_R;
	signal internal_ASIC_TIMING_SSP_TRAILING     : Timing_setting_C_R;
	signal internal_ASIC_TIMING_WR_STRB_LEADING  : Timing_setting_C_R;
	signal internal_ASIC_TIMING_WR_STRB_TRAILING : Timing_setting_C_R;
	signal internal_ASIC_TIMING_S1_LEADING       : Timing_setting_C_R;
	signal internal_ASIC_TIMING_S1_TRAILING      : Timing_setting_C_R;
	signal internal_ASIC_TIMING_S2_LEADING       : Timing_setting_C_R;
	signal internal_ASIC_TIMING_S2_TRAILING      : Timing_setting_C_R;
	signal internal_ASIC_TIMING_PHASE_LEADING    : Timing_setting_C_R;
	signal internal_ASIC_TIMING_PHASE_TRAILING   : Timing_setting_C_R;
	signal internal_ASIC_TIMING_GENERATOR_REG    : Timing_setting;
	--DAC signals that come from the feedback sources
	signal internal_WBIAS_FB              : DAC_setting_C_R;
	signal internal_VDLY_FB               : DAC_setting_C_R;
	signal internal_VADJP_FB              : DAC_setting_C_R;
	signal internal_VADJN_FB              : DAC_setting_C_R;
	--Enables to switch between the feedback version and non-feedback versions
   signal internal_VDLY_FEEDBACK_ENABLES  : Column_Row_Enables;
	signal internal_VADJ_FEEDBACK_ENABLES  : Column_Row_Enables;
	signal internal_WBIAS_FEEDBACK_ENABLES : Column_Row_Enables;
	--Enable to switch between internal and external VadjP/N DAC control
	signal internal_USE_EXTERNAL_VADJ_DACS : std_logic;

	--Monitoring 
	signal internal_WILKINSON_TARGETS      : Column_Row_Counters;
	signal internal_WILKINSON_COUNTERS     : Column_Row_Counters;
	signal internal_SAMPLING_RATE_TARGETS  : Column_Row_Counters;
	signal internal_SAMPLING_RATE_COUNTERS : Column_Row_Counters;
	
	--Connections to the general purpose registers
	signal internal_OUTPUT_REGISTERS : GPR;
	signal internal_INPUT_REGISTERS  : RR;

	--Miscellaneous connections
	signal internal_SCROD_REV_AND_ID_WORD : std_logic_vector(31 downto 0);

begin 
	--Clock generation
	map_clock_generation : entity work.clock_generation
	port map ( 
		--Raw board clock input
		BOARD_CLOCKP         => BOARD_CLOCKP,
		BOARD_CLOCKN         => BOARD_CLOCKN,
		--FTSW inputs
		RJ45_ACK_P           => RJ45_ACK_P,
		RJ45_ACK_N           => RJ45_ACK_N,			  
		RJ45_TRG_P           => RJ45_TRG_P,
		RJ45_TRG_N           => RJ45_TRG_N,			  			  
		RJ45_RSV_P           => RJ45_RSV_P,
		RJ45_RSV_N           => RJ45_RSV_N,
		RJ45_CLK_P           => RJ45_CLK_P,
		RJ45_CLK_N           => RJ45_CLK_N,
		--Trigger outputs from FTSW
		EXT_TRIGGER          => internal_HARDWARE_TRIGGER,
		--Select signal between the two
		USE_LOCAL_CLOCK      => USE_LOCAL_CLOCK_JUMPER,
		--General output clocks
		CLOCK_50MHz_BUFG     => internal_CLOCK_50MHz_BUFG,
		--ASIC control clocks
		CLOCK_SSTx4_BUFG     => internal_CLOCK_4xSST_BUFG,
		CLOCK_SSTx2_CE       => internal_CLOCK_2xSST_CE,
		CLOCK_SST_BUFG       => internal_CLOCK_SST_BUFG,
		--ASIC output clocks
		ASIC_SST             => AsicIn_SAMPLING_HOLD_MODE_C,
		--Output clock enable for I2C things
		I2C_CLOCK_ENABLE     => internal_CLOCK_ENABLE_I2C
	);	
	
	--Interface to I2C devices
	map_i2c_buses : entity work.i2c_general_interfaces
	port map(
		CLOCK           => internal_CLOCK_50MHz_BUFG,
		CLOCK_ENABLE    => internal_CLOCK_ENABLE_I2C,
		I2C_SCL_LINES   => I2C_SCL,
		I2C_SDA_LINES   => I2C_SDA,
		WRITE_REGISTERS => internal_I2C_WRITE_REGISTERS,
		READ_REGISTERS  => internal_I2C_READ_REGISTERS
	);	

	--Interface to the ASIC serial-to-parallel interfaces
	map_dac_interfaces : entity work.irs3b_dac_interface
	port map( 
		--Clock and clock enable used to run the interface
		CLOCK                      => internal_CLOCK_50MHz_BUFG, 
		CLOCK_ENABLE               => internal_CLOCK_ENABLE_I2C,
		--Direct connections to the IRS3B register programming interface
		AsicIn_PARALLEL_CLOCK_C0_R => AsicIn_PARALLEL_CLOCK_C0_R,
		AsicIn_PARALLEL_CLOCK_C1_R => AsicIn_PARALLEL_CLOCK_C1_R,
		AsicIn_PARALLEL_CLOCK_C2_R => AsicIn_PARALLEL_CLOCK_C2_R,
		AsicIn_PARALLEL_CLOCK_C3_R => AsicIn_PARALLEL_CLOCK_C3_R,
		AsicIn_CLEAR_ALL_REGISTERS => AsicIn_CLEAR_ALL_REGISTERS,
		AsicIn_SERIAL_SHIFT_CLOCK  => AsicIn_SERIAL_SHIFT_CLOCK,
		AsicIn_SERIAL_INPUT        => AsicIn_SERIAL_INPUT,
		--Connections to the external DACs for VADJP/VADJN
		I2C_DAC_SCL_R01            => I2C_DAC_SCL_R01,
		I2C_DAC_SDA_R01            => I2C_DAC_SDA_R01,
		I2C_DAC_SCL_R23            => I2C_DAC_SCL_R23,
		I2C_DAC_SDA_R23            => I2C_DAC_SDA_R23,
		--A toggle to select the internal or external DACs
		USE_EXTERNAL_VADJ_DACS     => internal_USE_EXTERNAL_VADJ_DACS,
		--DAC values coming from general purpose registers
		ASIC_TRIG_THRESH           => internal_ASIC_TRIG_THRESH,
		ASIC_DAC_BUF_BIASES        => internal_ASIC_DAC_BUF_BIASES,    
		ASIC_DAC_BUF_BIAS_ISEL     => internal_ASIC_DAC_BUF_BIAS_ISEL, 
		ASIC_DAC_BUF_BIAS_VADJP    => internal_ASIC_DAC_BUF_BIAS_VADJP,
		ASIC_DAC_BUF_BIAS_VADJN    => internal_ASIC_DAC_BUF_BIAS_VADJN,
		ASIC_VBIAS                 => internal_ASIC_VBIAS,             
		ASIC_VBIAS2                => internal_ASIC_VBIAS2,            
		ASIC_WBIAS                 => internal_ASIC_WBIAS,             
		ASIC_VADJP                 => internal_ASIC_VADJP,             
		ASIC_VADJN                 => internal_ASIC_VADJN,             
		ASIC_VDLY                  => internal_ASIC_VDLY,              
		ASIC_TRG_BIAS              => internal_ASIC_TRG_BIAS,          
		ASIC_TRG_BIAS2             => internal_ASIC_TRG_BIAS2,         
		ASIC_TRGTHREF              => internal_ASIC_TRGTHREF,          
		ASIC_CMPBIAS               => internal_ASIC_CMPBIAS,           
		ASIC_PUBIAS                => internal_ASIC_PUBIAS,            
		ASIC_SBBIAS                => internal_ASIC_SBBIAS,            
		ASIC_ISEL                  => internal_ASIC_ISEL,              
		--DAC values coming from feedback loops
		WBIAS_FB                   => internal_WBIAS_FB,
		VDLY_FB                    => internal_VDLY_FB,
		VADJP_FB                   => internal_VADJP_FB,
		VADJN_FB                   => internal_VADJN_FB,
		--Multiplex enables to choose between the two above categories
		VDLY_FEEDBACK_ENABLES      => internal_VDLY_FEEDBACK_ENABLES,
		VADJ_FEEDBACK_ENABLES      => internal_VADJ_FEEDBACK_ENABLES,
		WBIAS_FEEDBACK_ENABLES     => internal_WBIAS_FEEDBACK_ENABLES,
		--Other registers and timing-related signals that live in the ASIC internal registers
		ASIC_TIMING_SSP_LEADING      => internal_ASIC_TIMING_SSP_LEADING,
		ASIC_TIMING_SSP_TRAILING     => internal_ASIC_TIMING_SSP_TRAILING,  
		ASIC_TIMING_WR_STRB_LEADING  => internal_ASIC_TIMING_WR_STRB_LEADING,
		ASIC_TIMING_WR_STRB_TRAILING => internal_ASIC_TIMING_WR_STRB_TRAILING,
		ASIC_TIMING_S1_LEADING       => internal_ASIC_TIMING_S1_LEADING, 
		ASIC_TIMING_S1_TRAILING      => internal_ASIC_TIMING_S1_TRAILING,   
		ASIC_TIMING_S2_LEADING       => internal_ASIC_TIMING_S2_LEADING,    
		ASIC_TIMING_S2_TRAILING      => internal_ASIC_TIMING_S2_TRAILING,   
		ASIC_TIMING_PHASE_LEADING    => internal_ASIC_TIMING_PHASE_LEADING, 
		ASIC_TIMING_PHASE_TRAILING   => internal_ASIC_TIMING_PHASE_TRAILING,
		ASIC_TIMING_GENERATOR_REG    => internal_ASIC_TIMING_GENERATOR_REG, 
		ASIC_REG_TRG                 => internal_ASIC_REG_TRG              
	);
	
	--Scaler monitors for the ASIC channels
	--First we need to map the scalers into rows/cols
	internal_ASIC_TRIGGER_BITS_C_R_CH(0)(0) <= AsicOut_TRIG_OUTPUT_R0_C0_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(0)(1) <= AsicOut_TRIG_OUTPUT_R1_C0_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(0)(2) <= AsicOut_TRIG_OUTPUT_R2_C0_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(0)(3) <= AsicOut_TRIG_OUTPUT_R3_C0_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(1)(0) <= AsicOut_TRIG_OUTPUT_R0_C1_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(1)(1) <= AsicOut_TRIG_OUTPUT_R1_C1_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(1)(2) <= AsicOut_TRIG_OUTPUT_R2_C1_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(1)(3) <= AsicOut_TRIG_OUTPUT_R3_C1_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(2)(0) <= AsicOut_TRIG_OUTPUT_R0_C2_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(2)(1) <= AsicOut_TRIG_OUTPUT_R1_C2_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(2)(2) <= AsicOut_TRIG_OUTPUT_R2_C2_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(2)(3) <= AsicOut_TRIG_OUTPUT_R3_C2_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(3)(0) <= AsicOut_TRIG_OUTPUT_R0_C3_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(3)(1) <= AsicOut_TRIG_OUTPUT_R1_C3_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(3)(2) <= AsicOut_TRIG_OUTPUT_R2_C3_CH;
	internal_ASIC_TRIGGER_BITS_C_R_CH(3)(3) <= AsicOut_TRIG_OUTPUT_R3_C3_CH;
	--Then we instantiate the trigger scaler block
	map_asic_trigger_scalers : entity work.trigger_scaler_top
	generic map (
		CLOCK_RATE            => 50000000.0,
		INTEGRATION_FREQUENCY => TRIGGER_INTEGRATION_FREQUENCY
	)
	port map (
		TRIGGER_BITS_IN => internal_ASIC_TRIGGER_BITS_C_R_CH,
		CLOCK           => internal_CLOCK_50MHz_BUFG,
		ROW_SELECT      => internal_TRIGGER_SCALER_ROW_SELECT,
		COL_SELECT      => internal_TRIGGER_SCALER_COL_SELECT,
		SCALERS         => internal_ASIC_SCALERS_TO_READ
	);

	--ASIC monitoring and control for potential feedback paths
	map_asic_feedback_and_monitoring : entity work.feedback_and_monitoring
	port map (
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C0_R => AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C0_R,
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C1_R => AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C1_R,
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C2_R => AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C2_R,
		AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C3_R => AsicOut_SAMPLING_TIMING_OUTPUT_SIGNAL_C3_R,
		FEEDBACK_SAMPLING_RATE_ENABLE              => internal_VADJ_FEEDBACK_ENABLES,
		FEEDBACK_SAMPLING_RATE_GOALS_C_R           => internal_SAMPLING_RATE_TARGETS,
		FEEDBACK_SAMPLING_RATE_COUNTER_C_R         => internal_SAMPLING_RATE_COUNTERS,
		FEEDBACK_SAMPLING_RATE_VADJP_C_R           => internal_VADJP_FB,
		FEEDBACK_SAMPLING_RATE_VADJN_C_R           => internal_VADJN_FB,
		STARTING_SAMPLING_RATE_VADJN_C_R           => internal_ASIC_VADJN,
		AsicOut_MONITOR_WILK_COUNTERS_C0_R         => AsicOut_MONITOR_WILK_COUNTER_C0_R,
		AsicOut_MONITOR_WILK_COUNTERS_C1_R         => AsicOut_MONITOR_WILK_COUNTER_C1_R,
		AsicOut_MONITOR_WILK_COUNTERS_C2_R         => AsicOut_MONITOR_WILK_COUNTER_C2_R,
		AsicOut_MONITOR_WILK_COUNTERS_C3_R         => AsicOut_MONITOR_WILK_COUNTER_C3_R,
		FEEDBACK_WILKINSON_ENABLES_C_R             => internal_VDLY_FEEDBACK_ENABLES,
		FEEDBACK_WILKINSON_GOALS_C_R               => internal_WILKINSON_TARGETS,
		FEEDBACK_WILKINSON_COUNTERS_C_R            => internal_WILKINSON_COUNTERS,
		FEEDBACK_WILKINSON_DAC_VALUES_C_R          => internal_VDLY_FB,
		STARTING_WILKINSON_DAC_VALUES_C_R          => internal_ASIC_VDLY,
		CLOCK                                      => internal_CLOCK_50MHz_BUFG
	);

	--Interface to the DAQ devices
	map_readout_interfaces : entity work.readout_interface
	port map ( 
		CLOCK                        => internal_CLOCK_50MHz_BUFG,

		OUTPUT_REGISTERS             => internal_OUTPUT_REGISTERS,
		INPUT_REGISTERS              => internal_INPUT_REGISTERS,
	
		--super temporary -- disable waveform interface to event builder
		--WAVEFORM_FIFO_DATA_IN        => internal_WAVEFORM_FIFO_DATA_OUT,
		--WAVEFORM_FIFO_EMPTY          => internal_WAVEFORM_FIFO_EMPTY,
		--WAVEFORM_FIFO_DATA_VALID     => internal_WAVEFORM_FIFO_DATA_VALID,
		--WAVEFORM_FIFO_READ_CLOCK     => internal_WAVEFORM_FIFO_READ_CLOCK,
		--WAVEFORM_FIFO_READ_ENABLE    => internal_WAVEFORM_FIFO_READ_ENABLE,
		--WAVEFORM_PACKET_BUILDER_BUSY => internal_WAVEFORM_PACKET_BUILDER_BUSY,
		--WAVEFORM_PACKET_BUILDER_VETO => internal_WAVEFORM_PACKET_BUILDER_VETO,
		--WAVEFORM ROI readout disable for now
		WAVEFORM_FIFO_DATA_IN        => (others=>'0'),
		WAVEFORM_FIFO_EMPTY          => '1',
		WAVEFORM_FIFO_DATA_VALID     => '0',
		WAVEFORM_FIFO_READ_CLOCK     => open,
		WAVEFORM_FIFO_READ_ENABLE    => open,
		WAVEFORM_PACKET_BUILDER_BUSY => '0',
		WAVEFORM_PACKET_BUILDER_VETO => open,

		FIBER_0_RXP                  => FIBER_0_RXP,
		FIBER_0_RXN                  => FIBER_0_RXN,
		FIBER_1_RXP                  => FIBER_1_RXP,
		FIBER_1_RXN                  => FIBER_1_RXN,
		FIBER_0_TXP                  => FIBER_0_TXP,
		FIBER_0_TXN                  => FIBER_0_TXN,
		FIBER_1_TXP                  => FIBER_1_TXP,
		FIBER_1_TXN                  => FIBER_1_TXN,
		FIBER_REFCLKP                => FIBER_REFCLKP,
		FIBER_REFCLKN                => FIBER_REFCLKN,
		FIBER_0_DISABLE_TRANSCEIVER  => FIBER_0_DISABLE_TRANSCEIVER,
		FIBER_1_DISABLE_TRANSCEIVER  => FIBER_1_DISABLE_TRANSCEIVER,
		FIBER_0_LINK_UP              => FIBER_0_LINK_UP,
		FIBER_1_LINK_UP              => FIBER_1_LINK_UP,
		FIBER_0_LINK_ERR             => FIBER_0_LINK_ERR,
		FIBER_1_LINK_ERR             => FIBER_1_LINK_ERR,

		USB_IFCLK                    => USB_IFCLK,
		USB_CTL0                     => USB_CTL0,
		USB_CTL1                     => USB_CTL1,
		USB_CTL2                     => USB_CTL2,
		USB_FDD                      => USB_FDD,
		USB_PA0                      => USB_PA0,
		USB_PA1                      => USB_PA1,
		USB_PA2                      => USB_PA2,
		USB_PA3                      => USB_PA3,
		USB_PA4                      => USB_PA4,
		USB_PA5                      => USB_PA5,
		USB_PA6                      => USB_PA6,
		USB_PA7                      => USB_PA7,
		USB_RDY0                     => USB_RDY0,
		USB_RDY1                     => USB_RDY1,
		USB_WAKEUP                   => USB_WAKEUP,
		USB_CLKOUT		              => USB_CLKOUT
	);
	
	--------------------------------------------------
	-------General registers interfaced to DAQ -------
	--------------------------------------------------

	--------Output register mapping-------------------
	LEDS                                   <= internal_OUTPUT_REGISTERS(  0); --Register   0: LEDs
	internal_I2C_WRITE_REGISTERS(0)        <= internal_OUTPUT_REGISTERS(  1); --Register   1: I2C interface for SCROD EEPROM and temperature sensor on SCROD
	internal_I2C_WRITE_REGISTERS(1)        <= internal_OUTPUT_REGISTERS(  2); --Register   2: I2C interface for SCROD fiberoptic transceiver 0
	internal_I2C_WRITE_REGISTERS(2)        <= internal_OUTPUT_REGISTERS(  3); --Register   3: I2C interface for SCROD fiberoptic transceiver 1
	                                                                          --Register   4: Select trigger polarity and which ASIC to read scalers from: PXXX XXXX XXXX CCRR, where P is 1/0 for rising/falling edge triggering, and C/R are column and row
	internal_ASIC_REG_TRG(0)               <= internal_OUTPUT_REGISTERS(  4)(15);
	internal_TRIGGER_SCALER_ROW_SELECT     <= internal_OUTPUT_REGISTERS(  4)(ROW_SELECT_BITS-1 downto 0); 
	internal_TRIGGER_SCALER_COL_SELECT     <= internal_OUTPUT_REGISTERS(  4)(ROW_SELECT_BITS+COL_SELECT_BITS-1 downto ROW_SELECT_BITS);
 	
	internal_ASIC_TRG_BIAS                 <= internal_OUTPUT_REGISTERS(  5)(11 downto 0); --Register  5: TRG_BIAS  - trigger comparator bias - shared for all ASICs
	internal_ASIC_TRG_BIAS2                <= internal_OUTPUT_REGISTERS(  6)(11 downto 0); --Register  6: TRG_BIAS2 - reference channel trigger comparator bias - shared for all ASICs
	internal_ASIC_TRGTHREF                 <= internal_OUTPUT_REGISTERS(  7)(11 downto 0); --Register  7: TRGTHREF  - trigger threshold for reference channel - shared for all ASICs
	internal_ASIC_ISEL                     <= internal_OUTPUT_REGISTERS(  8)(11 downto 0); --Register  8: ISEL - bias for current source for wilkinson ramp - shared for all ASICs
	internal_ASIC_SBBIAS                   <= internal_OUTPUT_REGISTERS(  9)(11 downto 0); --Register  9: SBBIAS - superbuffer bias for distribution of wilkinson ramp voltage - shared for all ASICs
	internal_ASIC_PUBIAS                   <= internal_OUTPUT_REGISTERS( 10)(11 downto 0); --Register 10: PUBIAS - pullup bias for wilkinson comparators - shared for all ASICs
	internal_ASIC_CMPBIAS                  <= internal_OUTPUT_REGISTERS( 11)(11 downto 0); --Register 11: CMPBIAS - comparator bias for wilkinson comparators - shared for all ASICs
	internal_ASIC_DAC_BUF_BIASES           <= internal_OUTPUT_REGISTERS( 12)(11 downto 0); --Register 12: DAC_BUF_BIAS - internal ASIC DAC buffer biases for things we always expect to drive internally - VBDbias, WBDbias, TCBbias, THDbias, Tbbias, TRGDbias, PDDbias, PUDbias, SBDbias, VDDbias, shared for all ASICs
	                                                                                       --Registers 13-140: ASIC channel trigger thresholds
	TRG_THRES_REGISTERS_COL : for col in 0 to 3 generate 
		TRG_THRES_REGISTERS_ROW : for row in 0 to 3 generate 
			TRG_THRES_REGISTERS_CH : for ch in 0 to 7 generate 
				internal_ASIC_TRIG_THRESH(col)(row)(ch) <= internal_OUTPUT_REGISTERS(13+ch+row*CHANNELS_PER_ASIC+col*CHANNELS_PER_ASIC*ROWS_PER_COL)(11 downto 0);
			end generate;	
		end generate;
	end generate;

	gen_feedback_enables_col : for col in 0 to 3 generate
		gen_feedback_enables_row : for row in 0 to 3 generate
			internal_VDLY_FEEDBACK_ENABLES(col)(row)  <= internal_OUTPUT_REGISTERS(141)(col*4+row); --Registers 141: Wilkinson count rate enable bits, increasing by row, then col
			internal_VADJ_FEEDBACK_ENABLES(col)(row)  <= internal_OUTPUT_REGISTERS(142)(col*4+row); --Registers 142: Sampling rate feedback enable bits, increasing by row, then col
			internal_WBIAS_FEEDBACK_ENABLES(col)(row) <= internal_OUTPUT_REGISTERS(143)(col*4+row); --Registers 143: Trigger width  feedback enable bits, increasing by row, then col
		end generate;
	end generate;

	internal_SCROD_REV_AND_ID_WORD(15 downto  0) <= internal_OUTPUT_REGISTERS(166); --Register 166: copy of the SCROD ID
	internal_SCROD_REV_AND_ID_WORD(31 downto 16) <= internal_OUTPUT_REGISTERS(167); --Register 167: copy of the SCORD revision

	internal_ASIC_DAC_BUF_BIAS_ISEL  <= internal_OUTPUT_REGISTERS(200)(11 downto 0); --Register 200: Internal ASIC DAC buffer bias for driving ISEL - shared for all ASICs
	internal_ASIC_DAC_BUF_BIAS_VADJP <= internal_OUTPUT_REGISTERS(201)(11 downto 0); --Register 201: Internal ASIC DAC buffer bias for driving VADJP - shared for all ASICs
	internal_ASIC_DAC_BUF_BIAS_VADJN <= internal_OUTPUT_REGISTERS(202)(11 downto 0); --Register 202: Internal ASIC DAC buffer bias for driving VADJN- shared for all ASICs
	                                                                                 --Registers 203-218: Internal ASIC Vbias - first stage transfer - unique by ASIC
	VBIAS_REGISTERS_COL : for col in 0 to 3 generate
		VBIAS_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_VBIAS(col)(row) <= internal_OUTPUT_REGISTERS(203+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 219-234: Internal ASIC Vbias2 - second stage transfer - unique by ASIC
	VBIAS2_REGISTERS_COL : for col in 0 to 3 generate
		VBIAS2_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_VBIAS2(col)(row) <= internal_OUTPUT_REGISTERS(219+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 235-250: Internal ASIC WBIAS - channel trigger one-shot output width - unique by ASIC
	WBIAS_REGISTERS_COL : for col in 0 to 3 generate
		WBIAS_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_WBIAS(col)(row) <= internal_OUTPUT_REGISTERS(235+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 251-266: Internal ASIC VADJP - PMOS bias for sampling rate - unique by ASIC
	VADJP_REGISTERS_COL : for col in 0 to 3 generate
		VADJP_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_VADJP(col)(row) <= internal_OUTPUT_REGISTERS(251+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 267-282: Internal ASIC VAJDN - NMOS bias for sampling rate - unique by ASIC
	VADJN_REGISTERS_COL : for col in 0 to 3 generate
		VADJN_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_VADJN(col)(row) <= internal_OUTPUT_REGISTERS(267+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 283-298: Internal ASIC VDLY - Wilkinson counter rate bias - unique by ASIC
	VDLY_REGISTERS_COL : for col in 0 to 3 generate
		VDLY_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_VDLY(col)(row) <= internal_OUTPUT_REGISTERS(283+row+ROWS_PER_COL*col)(11 downto 0);
		end generate;
	end generate;
	                                                                                 --Registers 299-314: Timing signals for SSP leading/trailing edges
	SSP_TIMING_REGISTERS_COL : for col in 0 to 3 generate
		SSP_TIMING_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_TIMING_SSP_LEADING(col)(row) <= internal_OUTPUT_REGISTERS(299+row+ROWS_PER_COL*col)(7 downto 0);
			internal_ASIC_TIMING_SSP_TRAILING(col)(row) <= internal_OUTPUT_REGISTERS(299+row+ROWS_PER_COL*col)(15 downto 8);
		end generate;
	end generate;
	                                                                                 --Registers 315-330: Timing signals for S1 leading/trailing edges
	S1_TIMING_REGISTERS_COL : for col in 0 to 3 generate
		S1_TIMING_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_TIMING_S1_LEADING(col)(row) <= internal_OUTPUT_REGISTERS(315+row+ROWS_PER_COL*col)(7 downto 0);
			internal_ASIC_TIMING_S1_TRAILING(col)(row) <= internal_OUTPUT_REGISTERS(315+row+ROWS_PER_COL*col)(15 downto 8);
		end generate;
	end generate;

	                                                                                 --Registers 331-346: Timing signals for S2 leading/trailing edges
	S2_TIMING_REGISTERS_COL : for col in 0 to 3 generate
		S2_TIMING_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_TIMING_S2_LEADING(col)(row) <= internal_OUTPUT_REGISTERS(331+row+ROWS_PER_COL*col)(7 downto 0);
			internal_ASIC_TIMING_S2_TRAILING(col)(row) <= internal_OUTPUT_REGISTERS(331+row+ROWS_PER_COL*col)(15 downto 8);
		end generate;
	end generate;
	                                                                                 --Registers 347-362: Timing signals for PHASE leading/trailing edges
	PHASE_TIMING_REGISTERS_COL : for col in 0 to 3 generate
		PHASE_TIMING_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_TIMING_PHASE_LEADING(col)(row) <= internal_OUTPUT_REGISTERS(347+row+ROWS_PER_COL*col)(7 downto 0);
			internal_ASIC_TIMING_PHASE_TRAILING(col)(row) <= internal_OUTPUT_REGISTERS(347+row+ROWS_PER_COL*col)(15 downto 8);
		end generate;
	end generate;
	                                                                                 --Registers 363-378: Timing signals for PHASE leading/trailing edges
	WR_STRB_TIMING_REGISTERS_COL : for col in 0 to 3 generate
		WR_STRB_TIMING_REGISTERS_ROW : for row in 0 to 3 generate
			internal_ASIC_TIMING_WR_STRB_LEADING(col)(row) <= internal_OUTPUT_REGISTERS(363+row+ROWS_PER_COL*col)(7 downto 0);
			internal_ASIC_TIMING_WR_STRB_TRAILING(col)(row) <= internal_OUTPUT_REGISTERS(363+row+ROWS_PER_COL*col)(15 downto 8);
		end generate;
	end generate;
	
	internal_ASIC_TIMING_GENERATOR_REG <= internal_OUTPUT_REGISTERS(379)(7 downto 0); --Register 379: Internal ASIC "timing" register

	                                                                                  --Registers 384-399: wilkinson counter target values for feedback
	gen_vdly_feedback_targets_col : for col in 0 to 3 generate
		gen_vdly_feedback_targets_row : for row in 0 to 3 generate
			internal_WILKINSON_TARGETS(col)(row) <= internal_OUTPUT_REGISTERS(384+row+ROWS_PER_COL*col); 
		end generate;
	end generate;
	                                                                                  --Registers 400-415: sampling rate counter target values for feedback
	gen_vadj_targets_col : for col in 0 to 3 generate
		gen_vadj_targets_row : for row in 0 to 3 generate
			internal_SAMPLING_RATE_TARGETS(col)(row) <= internal_OUTPUT_REGISTERS(400+row+ROWS_PER_COL*col); 
		end generate;
	end generate;

	internal_USE_EXTERNAL_VADJ_DACS <= internal_OUTPUT_REGISTERS(416)(0);            --Register 416: lsb for using external VadjP/N DACs


	internal_I2C_WRITE_REGISTERS(3)        <= internal_OUTPUT_REGISTERS(500); --Register 500: I2C interface for row 0,1 temp sensors (x8), eeproms (x2), and gpios (x2) for cal signals (and SMPL_SEL_ANY)
	internal_I2C_WRITE_REGISTERS(4)        <= internal_OUTPUT_REGISTERS(501); --Register 501: I2C interface for row 2,3 temp sensors (x8), eeproms (x2), and gpios (x2) for cal signals (and SMPL_SEL_ANY)
	internal_I2C_WRITE_REGISTERS(5)        <= internal_OUTPUT_REGISTERS(502); --Register 502: I2C interface for row 0,1 GPIO serial for ASIC shift out signals
	internal_I2C_WRITE_REGISTERS(6)        <= internal_OUTPUT_REGISTERS(503); --Register 503: I2C interface for row 2,3 GPIO serial for ASIC shift out signals
	internal_I2C_WRITE_REGISTERS(7)        <= internal_OUTPUT_REGISTERS(504); --Register 504: I2C interface for interconnect rev C GPIO to control calibration signals


--	internal_FIRST_ALLOWED_WINDOW     <= internal_OUTPUT_REGISTERS(161)(internal_FIRST_ALLOWED_WINDOW'length-1 downto 0);     --Register 161: Bits 8-0: First allowed analog storage window
--	internal_LAST_ALLOWED_WINDOW      <= internal_OUTPUT_REGISTERS(162)(internal_LAST_ALLOWED_WINDOW'length-1 downto 0);      --         162: Bits 8-0: Last allowed analog storage window
--	internal_MAX_WINDOWS_TO_LOOK_BACK <= internal_OUTPUT_REGISTERS(163)(internal_MAX_WINDOWS_TO_LOOK_BACK'length-1 downto 0); --Register 163: Bits 8-0: Maximum number of windows to look back
--	internal_MIN_WINDOWS_TO_LOOK_BACK <= internal_OUTPUT_REGISTERS(164)(internal_MIN_WINDOWS_TO_LOOK_BACK'length-1 downto 0); --         164: Bits 8-0: Minimum number of windows to look back
--	internal_PEDESTAL_WINDOW          <= internal_OUTPUT_REGISTERS(165)(internal_PEDESTAL_WINDOW'length-1 downto 0);          --Register 165: Bits 8-0:  Window to read out in pedestal mode
--	internal_PEDESTAL_MODE            <= internal_OUTPUT_REGISTERS(165)(15);                                                  --              Bit  15:   Operate in pedestal mode    
--	internal_SOFTWARE_TRIGGER         <= internal_OUTPUT_REGISTERS(165)(14);                                                  --              Bit  14:   Software trigger
--	internal_SOFTWARE_TRIGGER_VETO    <= internal_OUTPUT_REGISTERS(165)(13);                                                  --              Bit  13:   Software trigger veto
--	internal_HARDWARE_TRIGGER_VETO    <= internal_OUTPUT_REGISTERS(165)(12);                                                  --              Bit  12:   Hardware trigger veto
--	internal_EVENT_NUMBER_TO_SET(15 downto  0)   <= internal_OUTPUT_REGISTERS(168);    --Register 168: LSBs of event number to set
--	internal_EVENT_NUMBER_TO_SET(31 downto 16)   <= internal_OUTPUT_REGISTERS(169);    --Register 169: MSBs of event number to set
--	internal_SET_EVENT_NUMBER                    <= internal_OUTPUT_REGISTERS(170)(0); --Register 170: bit 0 - set the event number
--	internal_FORCE_CHANNEL_MASK( 15 downto   0)  <= internal_OUTPUT_REGISTERS(171);    --Registers 171-178: Force channel masks
--	internal_FORCE_CHANNEL_MASK( 31 downto  16)  <= internal_OUTPUT_REGISTERS(172);
--	internal_FORCE_CHANNEL_MASK( 47 downto  32)  <= internal_OUTPUT_REGISTERS(173);
--	internal_FORCE_CHANNEL_MASK( 63 downto  48)  <= internal_OUTPUT_REGISTERS(174);
--	internal_FORCE_CHANNEL_MASK( 79 downto  64)  <= internal_OUTPUT_REGISTERS(175);
--	internal_FORCE_CHANNEL_MASK( 95 downto  80)  <= internal_OUTPUT_REGISTERS(176);
--	internal_FORCE_CHANNEL_MASK(111 downto  96)  <= internal_OUTPUT_REGISTERS(177);
--	internal_FORCE_CHANNEL_MASK(127 downto 112)  <= internal_OUTPUT_REGISTERS(178);
--	internal_IGNORE_CHANNEL_MASK( 15 downto   0) <= internal_OUTPUT_REGISTERS(179);    ----Registers 179-186: Ignore channel masks
--	internal_IGNORE_CHANNEL_MASK( 31 downto  16) <= internal_OUTPUT_REGISTERS(180);
--	internal_IGNORE_CHANNEL_MASK( 47 downto  32) <= internal_OUTPUT_REGISTERS(181);
--	internal_IGNORE_CHANNEL_MASK( 63 downto  48) <= internal_OUTPUT_REGISTERS(182);
--	internal_IGNORE_CHANNEL_MASK( 79 downto  64) <= internal_OUTPUT_REGISTERS(183);
--	internal_IGNORE_CHANNEL_MASK( 95 downto  80) <= internal_OUTPUT_REGISTERS(184);
--	internal_IGNORE_CHANNEL_MASK(111 downto  96) <= internal_OUTPUT_REGISTERS(185);
--	internal_IGNORE_CHANNEL_MASK(127 downto 112) <= internal_OUTPUT_REGISTERS(186);
--	internal_ROI_ADDRESS_ADJUST                   <= internal_OUTPUT_REGISTERS(187)(TRIGGER_MEMORY_ADDRESS_BITS-1 downto 0);  --Register 187: 10-bit signed adjust window for the trigger memory
--	internal_WINDOW_PAIRS_TO_SAMPLE_AFTER_TRIGGER <= internal_OUTPUT_REGISTERS(188)(ANALOG_MEMORY_ADDRESS_BITS-2 downto 0);  --Register 188: 9 bit unsigned number of window pairs to sample after receiving a trigger

	--------Input register mapping--------------------
	--Map the first N_GPR output registers to the first set of read registers
	gen_OUTREG_to_INREG: for i in 0 to N_GPR-1 generate
		gen_BIT: for j in 0 to 15 generate
			map_BUF_RR : BUF 
			port map( 
				I => internal_OUTPUT_REGISTERS(i)(j), 
				O => internal_INPUT_REGISTERS(i)(j) 
			);
		end generate;
	end generate;
	--- The register numbers must be updated for the following if N_GPR is changed.
	internal_INPUT_REGISTERS(N_GPR +   0) <= internal_I2C_READ_REGISTERS(0); --Register 512: I2C interface for SCROD eeoprom and temp sensor
	internal_INPUT_REGISTERS(N_GPR +   1) <= internal_I2C_READ_REGISTERS(1); --Register 513: I2C interface for SCROD fiber 0 transceiver
	internal_INPUT_REGISTERS(N_GPR +   2) <= internal_I2C_READ_REGISTERS(2); --Register 514: I2C interface for SCROD fiber 1 transceiver
	internal_INPUT_REGISTERS(N_GPR +   3) <= internal_I2C_READ_REGISTERS(3); --Register 515: I2C interface for row 0,1 temp sensors (x8), eeproms (x2), and gpios (x2) for cal signals (and SMPL_SEL_ANY)
	internal_INPUT_REGISTERS(N_GPR +   4) <= internal_I2C_READ_REGISTERS(4); --Register 516: I2C interface for row 2,3 temp sensors (x8), eeproms (x2), and gpios (x2) for cal signals (and SMPL_SEL_ANY)
	internal_INPUT_REGISTERS(N_GPR +   5) <= internal_I2C_READ_REGISTERS(5); --Register 517: I2C interface for row 0,1 GPIO serial for ASIC shift out signals
	internal_INPUT_REGISTERS(N_GPR +   6) <= internal_I2C_READ_REGISTERS(6); --Register 518: I2C interface for row 2,3 GPIO serial for ASIC shift out signals
	internal_INPUT_REGISTERS(N_GPR +   7) <= internal_I2C_READ_REGISTERS(7); --Register 519: I2C interface for interconnect rev C GPIO to control cal signals
	                                                                         --Register 520-527: ASIC channel scalers, with ASIC chosen by write register 4
	gen_TRG_SCALER_CH : for ch in 0 to 7 generate
		internal_INPUT_REGISTERS(N_GPR + 8 + ch) <= internal_ASIC_SCALERS_TO_READ(ch);
	end generate;
	                                                                         --Registers 528-543: Wilkinson counters
	gen_WILK_COUNTER_COL : for col in 0 to 3 generate
		gen_WILK_COUNTER_ROW : for row in 0 to 3 generate
			internal_INPUT_REGISTERS(N_GPR + 16 + row + ROWS_PER_COL * col) <= internal_WILKINSON_COUNTERS(col)(row);
		end generate;
	end generate;
	                                                                         --Registers 544-559: Wilkinson FB DAC values
	gen_VDLY_FB_COL : for col in 0 to 3 generate
		gen_VDLY_FB_ROW : for row in 0 to 3 generate
			internal_INPUT_REGISTERS(N_GPR + 32 + row + ROWS_PER_COL * col) <= x"0" & internal_VDLY_FB(col)(row);
		end generate;
	end generate;																									
	                                                                         --Registers 560-575: RCO counters
	gen_RCO_COUNTER_COL : for col in 0 to 3 generate
		gen_RCO_COUNTER_ROW : for row in 0 to 3 generate
			internal_INPUT_REGISTERS(N_GPR + 48 + row + ROWS_PER_COL * col) <= internal_SAMPLING_RATE_COUNTERS(col)(row);
		end generate;
	end generate;																									
	                                                                         --Registers 576-591: VADJN feedback values
	gen_VADJN_FB_COL : for col in 0 to 3 generate
		gen_VADJN_FB_ROW : for row in 0 to 3 generate
			internal_INPUT_REGISTERS(N_GPR + 64 + row + ROWS_PER_COL * col) <= x"0" & internal_VADJN_FB(col)(row);
		end generate;
	end generate;																									
	                                                                         --Registers 592-607: VADJP feedback values
	gen_VADJP_FB_COL : for col in 0 to 3 generate
		gen_VADJP_FB_ROW : for row in 0 to 3 generate
			internal_INPUT_REGISTERS(N_GPR + 80 + row + ROWS_PER_COL * col) <= x"0" & internal_VADJP_FB(col)(row);
		end generate;
	end generate;																									


--	internal_INPUT_REGISTERS(N_GPR+107) <= internal_EVENT_NUMBER(15 downto  0);                                                                 --Register 363: LSBs of current event number
--	internal_INPUT_REGISTERS(N_GPR+108) <= internal_EVENT_NUMBER(31 downto 16);                                                                 --Register 364: MSBs of current event number

end Behavioral;