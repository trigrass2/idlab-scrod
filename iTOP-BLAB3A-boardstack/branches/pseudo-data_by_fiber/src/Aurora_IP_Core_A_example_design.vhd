---- 2011-06 Xilinx coregen
-- 2011-06 kurtis
-- 2011-07 modified by mza
-- 2011-08 modified by mza
---------------------------------------------------------------------------------------------
--  Aurora Generator
--  Description: Sample Instantiation of a 1 4-byte lane module.
--               Only tests initialization in hardware.
---------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_MISC.all;
--use IEEE.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use WORK.AURORA_PKG.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- synthesis translate_on

entity Aurora_IP_Core_A_example_design is
	generic(
		CURRENT_PROTOCOL_FREEZE_DATE : std_logic_vector(31 downto 0) := x"20110902";
		WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS           : integer := 16;
		WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS        : integer := 15;
		WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS    : integer := 32;
		WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_ADDRESS_BUS : integer := 17;
		USE_CHIPSCOPE        : integer := 1;
		SIM_GTPRESET_SPEEDUP : integer := 1  --Set to 1 to speed up sim reset
	);
	port (
		-- User I/O
--		RESET             : in    std_logic;
		HARD_ERR          :   out std_logic;
		SOFT_ERR          :   out std_logic;
		ERR_COUNT         :   out std_logic_vector(0 to 7); -- is 0 to 7 a bug?
		LANE_UP           :   out std_logic;
		CHANNEL_UP        :   out std_logic;
--		INIT_CLK          : in    std_logic;
--		GT_RESET_IN       : in    std_logic;
		-- Clocks
		GTPD2_P    : in  std_logic;
		GTPD2_N    : in  std_logic;
		-- V5 I/O
		RXP               : in    std_logic;
		RXN               : in    std_logic;
		TXP               :   out std_logic;
		TXN               :   out std_logic;
		-- fiber optic transceiver 0 I/O
		FIBER_TRANSCEIVER_0_LASER_FAULT_DETECTED_IN_TRANSMITTER : in    std_logic;
		FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER : in    std_logic;
 		FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT  : in    std_logic;
		FIBER_TRANSCEIVER_0_DISABLE_MODULE                      :   out std_logic;
		-- fiber optic transceiver 1 I/O
		FIBER_TRANSCEIVER_1_DISABLE_MODULE                      :   out std_logic;
		-- remote trigger, revolution pulse and distributed clock
		REMOTE_SIMPLE_TRIGGER_P    : in    std_logic;
		REMOTE_SIMPLE_TRIGGER_N    : in    std_logic;
		REMOTE_ENCODED_TRIGGER_P   : in    std_logic;
		REMOTE_ENCODED_TRIGGER_N   : in    std_logic;
		REMOTE_CLOCK_P             : in    std_logic;
		REMOTE_CLOCK_N             : in    std_logic;
		-- other I/O
		board_clock_250MHz_P	: in    std_logic;
		board_clock_250MHz_N	: in    std_logic;
		LEDS                 :   out std_logic_vector(15 downto 0);
		MONITOR_HEADER_OUTPUT :   out std_logic_vector(14 downto 0);
		MONITOR_HEADER_INPUT  : in    std_logic_vector(15 downto 15)
	);
end Aurora_IP_Core_A_example_design;

architecture MAPPED of Aurora_IP_Core_A_example_design is
-- Component Declarations --
	component IBUFDS
	port (
		O : out std_ulogic;
		I : in std_ulogic;
		IB : in std_ulogic
	);
	end component;

	component IBUFGDS
	port (
		O  :  out STD_ULOGIC;
		I  : in STD_ULOGIC;
		IB : in STD_ULOGIC
	);
	end component;

	component BUFIO2 
	generic(
		DIVIDE_BYPASS : boolean := TRUE;  -- TRUE, FALSE
		DIVIDE        : integer := 1;     -- {1..8}
		I_INVERT      : boolean := FALSE; -- TRUE, FALSE
		USE_DOUBLER   : boolean := FALSE  -- TRUE, FALSE
	);
	port(
		DIVCLK       : out std_ulogic;
		IOCLK        : out std_ulogic;
		SERDESSTROBE : out std_ulogic;
		I            : in  std_ulogic
	);
	end component;

	component IBUFG
	port (
		O : out std_ulogic;
		I : in  std_ulogic
	);
	end component;

	component Aurora_IP_Core_A_CLOCK_MODULE
	port (
		GT_CLK                  : in std_logic;
		GT_CLK_LOCKED           : in std_logic;
		USER_CLK                : out std_logic;
		SYNC_CLK                : out std_logic;
		PLL_NOT_LOCKED          : out std_logic
	);
	end component;

	component Aurora_IP_Core_A_RESET_LOGIC
	port (
		RESET                  : in std_logic;
		USER_CLK               : in std_logic;
		INIT_CLK               : in std_logic;
		GT_RESET_IN            : in std_logic;
		TX_LOCK_IN             : in std_logic;
		PLL_NOT_LOCKED         : in std_logic;
		SYSTEM_RESET           : out std_logic;
		GT_RESET_OUT           : out std_logic
	);
	end component;

	component Aurora_IP_Core_A
	generic (
		SIM_GTPRESET_SPEEDUP : integer := 1
	);
	port (
		-- LocalLink TX Interface
		TX_D             : in std_logic_vector(0 to 31);
		TX_SRC_RDY_N     : in std_logic;
		TX_DST_RDY_N     : out std_logic;
		-- LocalLink RX Interface
		RX_D             : out std_logic_vector(0 to 31);
		RX_SRC_RDY_N     : out std_logic;
		-- V5 Serial I/O
		RXP              : in std_logic;
		RXN              : in std_logic;
		TXP              : out std_logic;
		TXN              : out std_logic;
		-- V5 Reference Clock Interface
		GTPD2    : in std_logic;
		-- Error Detection Interface
		HARD_ERR       : out std_logic;
		SOFT_ERR       : out std_logic;
		-- Status
		CHANNEL_UP       : out std_logic;
		LANE_UP          : out std_logic;
		-- Clock Compensation Control Interface
		WARN_CC          : in std_logic;
		DO_CC            : in std_logic;
		-- System Interface
		USER_CLK         : in std_logic;
		SYNC_CLK         : in std_logic;
		GT_RESET         : in std_logic;
		RESET            : in std_logic;
		POWER_DOWN       : in std_logic;
		LOOPBACK         : in std_logic_vector(2 downto 0);
		GTPCLKOUT        : out std_logic;
		TX_LOCK          : out std_logic;
		--Kurtis added
		RX_CHAR_IS_COMMA : out std_logic_vector(3 downto 0);
		LANE_INIT_STATE  : out std_logic_vector(6 downto 0);
		RESET_LANES      : out std_logic;
		TX_PE_DATA			: out std_logic_vector(31 downto 0)
	);
	end component;

	component Aurora_IP_Core_A_STANDARD_CC_MODULE
	port (
		-- Clock Compensation Control Interface
		WARN_CC        : out std_logic;
		DO_CC          : out std_logic;
		-- System Interface
		PLL_NOT_LOCKED : in std_logic;
		USER_CLK       : in std_logic;
		RESET          : in std_logic
	);
	end component;

	component Packet_Receiver
	generic (
		CURRENT_PROTOCOL_FREEZE_DATE : unsigned(31 downto 0) := unsigned(CURRENT_PROTOCOL_FREEZE_DATE)
	);
	port (
		-- User Interface
		RX_D            : in    std_logic_vector(0 to 31); 
		RX_SRC_RDY_N    : in    std_logic; 
		-- System Interface
		USER_CLK        : in    std_logic;   
		RESET           : in    std_logic;
		CHANNEL_UP      : in    std_logic;
		WRONG_PACKET_SIZE_COUNTER          :   out std_logic_vector(31 downto 0);
		WRONG_PACKET_TYPE_COUNTER          :   out std_logic_vector(31 downto 0);
		WRONG_PROTOCOL_FREEZE_DATE_COUNTER :   out std_logic_vector(31 downto 0);
		WRONG_SCROD_ADDRESSED_COUNTER      :   out std_logic_vector(31 downto 0);
		WRONG_CHECKSUM_COUNTER             :   out std_logic_vector(31 downto 0);
		WRONG_FOOTER_COUNTER               :   out std_logic_vector(31 downto 0);
		UNKNOWN_ERROR_COUNTER              :   out std_logic_vector(31 downto 0);
		MISSING_ACKNOWLEDGEMENT_COUNTER    :   out std_logic_vector(31 downto 0);
		number_of_sent_events              :   out std_logic_vector(31 downto 0);
		NUMBER_OF_WORDS_IN_THIS_PACKET_RECEIVED_SO_FAR :   out std_logic_vector(31 downto 0);
		resynchronizing_with_header        :   out std_logic;
		start_event_transfer               :   out std_logic;
		acknowledge_start_event_transfer   : in    std_logic;
		ERR_COUNT       :   out std_logic_vector(0 to 7)
	);
	end component;

	-------------------------------------------------------------------
	component s6_icon
	port (
		control0    : inout std_logic_vector(35 downto 0);
		control1    : inout std_logic_vector(35 downto 0)
	);
	end component;

	component s6_vio
	port (
		control     : inout std_logic_vector(35 downto 0);
		clk         : in    std_logic;
		sync_in     : in    std_logic_vector(63 downto 0);
		sync_out    :   out std_logic_vector(63 downto 0)
	);
	end component;

	component s6_ila
	port (
		control  : inout std_logic_vector(35 downto 0);
		clk      : in    std_logic;
		data     : in    std_logic_vector(255 downto 0);
		trig0    : in    std_logic_vector(255 downto 0);
		trig_out :   out std_logic
	);
	end component;
	-------------------------------------------------------------------

	component quarter_event_builder
	generic (
		CURRENT_PROTOCOL_FREEZE_DATE : std_logic_vector(31 downto 0) := CURRENT_PROTOCOL_FREEZE_DATE
	);
	port (
		RESET                              : in    std_logic;
		CLOCK                              : in    std_logic;
		INPUT_DATA_BUS                     : in    std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS-1           downto 0);
		INPUT_ADDRESS_BUS                  :   out std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS-1        downto 0);
		ADDRESS_OF_STARTING_WINDOW_IN_ASIC : in    std_logic_vector(8 downto 0);
		OUTPUT_DATA_BUS                    :   out std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS-1    downto 0);
		OUTPUT_ADDRESS_BUS                 :   out std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_ADDRESS_BUS-1 downto 0);
		OUTPUT_FIFO_WRITE_ENABLE           :   out std_logic;
		START_BUILDING_A_QUARTER_EVENT     : in    std_logic;
		DONE_BUILDING_A_QUARTER_EVENT      :   out std_logic
	);
	end component;

	component pseudo_data_block_ram
	port (
		CLOCK      : in    std_logic;
		ADDRESS_IN : in    std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS-1 downto 0);
		DATA_OUT   :   out std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS-1 downto 0)
	);
	end component;

-----------------------------------
	attribute core_generation_info           : string;
	attribute core_generation_info of MAPPED : architecture is "Aurora_IP_Core_A,aurora_8b10b_v5_2,{backchannel_mode=Sidebands, c_aurora_lanes=1, c_column_used=None, c_gt_clock_1=GTPD2, c_gt_clock_2=None, c_gt_loc_1=X, c_gt_loc_10=X, c_gt_loc_11=X, c_gt_loc_12=X, c_gt_loc_13=X, c_gt_loc_14=X, c_gt_loc_15=X, c_gt_loc_16=X, c_gt_loc_17=X, c_gt_loc_18=X, c_gt_loc_19=X, c_gt_loc_2=X, c_gt_loc_20=X, c_gt_loc_21=X, c_gt_loc_22=X, c_gt_loc_23=X, c_gt_loc_24=X, c_gt_loc_25=X, c_gt_loc_26=X, c_gt_loc_27=X, c_gt_loc_28=X, c_gt_loc_29=X, c_gt_loc_3=X, c_gt_loc_30=X, c_gt_loc_31=X, c_gt_loc_32=X, c_gt_loc_33=X, c_gt_loc_34=X, c_gt_loc_35=X, c_gt_loc_36=X, c_gt_loc_37=X, c_gt_loc_38=X, c_gt_loc_39=X, c_gt_loc_4=X, c_gt_loc_40=X, c_gt_loc_41=X, c_gt_loc_42=X, c_gt_loc_43=X, c_gt_loc_44=X, c_gt_loc_45=X, c_gt_loc_46=X, c_gt_loc_47=X, c_gt_loc_48=X, c_gt_loc_5=1, c_gt_loc_6=X, c_gt_loc_7=X, c_gt_loc_8=X, c_gt_loc_9=X, c_lane_width=4, c_line_rate=3.125, c_nfc=false, c_nfc_mode=IMM, c_refclk_frequency=156.25, c_simplex=false, c_simplex_mode=TX, c_stream=true, c_ufc=false, flow_mode=None, interface_mode=Streaming, dataflow_config=Duplex}";
-- Parameter Declarations --
	constant DLY : time := 1 ns;
-- External Register Declarations --
	signal HARD_ERR_Buffer    : std_logic;
	signal SOFT_ERR_Buffer    : std_logic;
	signal LANE_UP_Buffer     : std_logic;
	signal CHANNEL_UP_Buffer  : std_logic;
	signal TXP_Buffer         : std_logic;
	signal TXN_Buffer         : std_logic;
-- Internal Register Declarations --
	signal gt_reset_i         : std_logic; 
	signal system_reset_i     : std_logic;
-- Wire Declarations --
-- Stream TX Interface
	signal tx_d_i             : std_logic_vector(0 to 31);
	signal tx_src_rdy_n_i     : std_logic;
	signal tx_dst_rdy_n_i     : std_logic;
-- Stream RX Interface
	signal rx_d_i             : std_logic_vector(0 to 31);
	signal rx_src_rdy_n_i     : std_logic;
-- V5 Reference Clock Interface
	signal GTPD2_left_i      : std_logic;
-- Error Detection Interface
	signal hard_err_i       : std_logic;
	signal soft_err_i       : std_logic;
-- Status
	signal channel_up_i       : std_logic;
	signal lane_up_i          : std_logic;
-- Clock Compensation Control Interface
	signal warn_cc_i          : std_logic;
	signal do_cc_i            : std_logic;
-- System Interface ---------------------------------------------------------
	signal pll_not_locked_i   : std_logic;
	signal user_clk_i         : std_logic;
	signal sync_clk_i         : std_logic;
	signal reset_i            : std_logic;
	signal power_down_i       : std_logic;
	signal loopback_i         : std_logic_vector(2 downto 0);
	signal tx_lock_i          : std_logic;
	signal gtpclkout_i        : std_logic;
	signal buf_gtpclkout_i    : std_logic;
--Frame check signals -------------------------------------------------------
	signal err_count_i      : std_logic_vector(0 to 7);
	signal ERR_COUNT_Buffer : std_logic_vector(0 to 7);
-- chipscope signals --------------------------------------------------------
	signal icon_to_vio_i         : std_logic_vector(35 downto 0);
	signal icon_to_ila_i         : std_logic_vector(35 downto 0);
	signal sync_in_i             : std_logic_vector(63 downto 0);
	signal sync_out_i            : std_logic_vector(63 downto 0);
	signal chipscope_ila_data    : std_logic_vector(255 downto 0) := (others => '0');
	signal chipscope_ila_trigger : std_logic_vector(255 downto 0) := (others => '0');
-----------------------------------------------------------------------------
	signal lane_up_i_i  	      : std_logic;
	signal tx_lock_i_i  	      : std_logic;
	signal lane_up_reduce_i    : std_logic;
	attribute ASYNC_REG        : string;
	attribute ASYNC_REG of tx_lock_i  : signal is "TRUE";
-------Kurtis additions------------
	signal internal_clock_from_remote_source : std_logic;
	signal internal_clock_250MHz             : std_logic;
	signal internal_COUNTER : std_logic_vector(31 downto 0);
	signal INIT_CLK : std_logic;
	signal AURORA_RESET_IN : std_logic := '1';
	signal GT_RESET_IN     : std_logic := '1';
	signal rx_char_is_comma_i : std_logic_vector(3 downto 0);
	signal lane_init_state_i  : std_logic_vector(6 downto 0);
	signal reset_lanes_i : std_logic;
	signal tx_pe_data_i : std_logic_vector(31 downto 0);
	signal internal_PACKET_GENERATOR_ENABLE : std_logic_vector(1 downto 0);
	signal internal_DATA_GENERATOR_STATE : std_logic_vector(2 downto 0);
	signal internal_VARIABLE_DELAY_BETWEEN_EVENTS : std_logic_vector(31 downto 0);
-----------------------------------------------------------------------------
	signal clock_1MHz : std_logic;
	signal clock_1kHz : std_logic;
	signal internal_WRONG_PACKET_SIZE_COUNTER          : std_logic_vector(31 downto 0);
	signal internal_WRONG_PACKET_TYPE_COUNTER          : std_logic_vector(31 downto 0);
	signal internal_WRONG_PROTOCOL_FREEZE_DATE_COUNTER : std_logic_vector(31 downto 0);
	signal internal_WRONG_SCROD_ADDRESSED_COUNTER      : std_logic_vector(31 downto 0);
	signal internal_WRONG_CHECKSUM_COUNTER             : std_logic_vector(31 downto 0);
	signal internal_WRONG_FOOTER_COUNTER               : std_logic_vector(31 downto 0);
	signal internal_UNKNOWN_ERROR_COUNTER              : std_logic_vector(31 downto 0);
	signal internal_MISSING_ACKNOWLEDGEMENT_COUNTER    : std_logic_vector(31 downto 0);
	signal internal_number_of_sent_events              : std_logic_vector(31 downto 0);
	signal internal_NUMBER_OF_WORDS_IN_THIS_PACKET_RECEIVED_SO_FAR : std_logic_vector(31 downto 0);
	signal internal_resynchronizing_with_header        : std_logic;
	signal internal_start_event_transfer               : std_logic;
	signal internal_acknowledge_start_event_transfer   : std_logic;
--	signal stupid_counter : std_logic_vector(31 downto 0);
-----------------------------------------------------------------------------
-- trigger signals:
	signal external_trigger_1_from_monitor_header : std_logic;
	signal external_trigger_2_from_LVDS           : std_logic;
	signal external_encoded_trigger_from_LVDS     : std_logic;
	signal raw_500Hz_fake_trigger : std_logic := '0';
	signal raw_100Hz_fake_trigger : std_logic := '0';
--	signal raw_25Hz_fake_trigger : std_logic := '0';
	signal external_triggers_ORed_together : std_logic;
	signal gated_trigger : std_logic;
	signal external_trigger_disable : std_logic := '0';
	signal internal_trigger : std_logic;
	signal spill_active : std_logic;
	signal fill_active  : std_logic;
	signal fake_spill_structure_enable : std_logic;
	signal gated_fill_inactive : std_logic;
	signal transmit_disable : std_logic := '0';
	signal transmit_always : std_logic;
	signal trigger_a_digitization_and_readout_event : std_logic;
	signal pulsed_trigger : std_logic := '0';
	signal trigger_acknowledge : std_logic;
	signal internal_clock_for_state_machine : std_logic;
	signal clock_select : std_logic := '0'; -- '0' = local; '1' = remote
	signal global_reset : std_logic := '1';
	signal request_a_global_reset : std_logic := '0';
-----------------------------------------------------------------------------
	signal chipscope_aurora_reset                             : std_logic;
	signal request_a_fiber_link_reset                         : std_logic := '0';
	signal internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE        : std_logic := '1';
	signal fiber_link_is_up                                   : std_logic;
	signal fiber_link_should_be_up                            : std_logic;
	signal should_not_automatically_try_to_keep_fiber_link_up : std_logic := '0';
-----------------------------------------------------------------------------
	signal internal_ASIC_DATA_BLOCKRAM_DATA_BUS        : std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS-1        downto 0);
	signal internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS     : std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS-1     downto 0);
	signal internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS  : std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS-1 downto 0);
	signal internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS : std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS-1 downto 0);
	signal internal_QUARTER_EVENT_FIFO_WRITE_ENABLE    : std_logic;
	signal internal_START_BUILDING_A_QUARTER_EVENT     : std_logic;
	signal internal_DONE_BUILDING_A_QUARTER_EVENT      : std_logic;
	signal quarter_event_builder_enable : std_logic := '0';
-----------------------------------------------------------------------------
--	signal inverted_clock_1MHz            : std_logic;
	signal quarter_event_fifo_read_enable : std_logic := '0';
	signal quarter_event_fifo_is_empty    : std_logic;
-----------------------------------------------------------------------------
	signal internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC : std_logic_vector(8 downto 0) := "1" & x"f0";
begin
-----------------------------------------------------------------------------
	process(internal_clock_for_state_machine, request_a_global_reset)
		variable internal_COUNTER  : integer range 0 to 250000000 := 0;
	begin
		if (rising_edge(internal_clock_for_state_machine)) then
			if (request_a_global_reset = '1') then
				internal_COUNTER := 0;
				global_reset <= '1';
			elsif (internal_COUNTER < 2500000) then
				internal_COUNTER := internal_COUNTER + 1;
			else
				global_reset <= '0';
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------
	process(internal_clock_for_state_machine, global_reset)
		variable counter_250_MHz  : integer range 0 to 250 := 0;
	begin
		if (global_reset = '1') then
			counter_250_MHz := 0;
		elsif rising_edge(internal_clock_for_state_machine) then
			counter_250_MHz := counter_250_MHz + 1;
			clock_1MHz <= '0';
			if (counter_250_MHz > 124) then
				clock_1MHz <= '1';
			end if;
			if (counter_250_MHz > 249) then -- is 1 to 250 at this part of the loop
				counter_250_MHz := 0;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------
	process(clock_1MHz, global_reset)
		variable counter_1_MHz    : integer range 0 to 10 := 0;
		variable counter_100_kHz  : integer range 0 to 10 := 0;
		variable counter_10_kHz   : integer range 0 to 10 := 0;
--		variable counter_2_kHz    : integer range 0 to 10 := 0;
	begin
		if (global_reset = '1') then
			counter_1_MHz   := 0;
			counter_100_kHz := 0;
			counter_10_kHz  := 0;
--			counter_2_kHz   := 0;
		elsif rising_edge(clock_1MHz) then
			-- evaluated once per microsecond
			counter_1_MHz := counter_1_MHz + 1;
			if (counter_1_MHz > 9) then
				-- evaluated 100,000 times per second
				counter_1_MHz := 0;
				counter_100_kHz := counter_100_kHz + 1;
			end if;
			if (counter_100_kHz > 9) then
				-- evaluated 10,000 times per second
				counter_100_kHz := 0;
				counter_10_kHz := counter_10_kHz + 1;
			end if;
			if (counter_10_kHz > 4) then
				-- evaluated 2,000 times per second
				counter_10_kHz := 0;
--				counter_2_kHz := counter_2_kHz + 1;
				clock_1kHz <= not clock_1kHz;
			end if;
--			if (counter_2_kHz > 2) then
				-- evaluated 1,000 times per second
--				counter_2_kHz := 0;
--				
--			end if;
		end if;
	end process;
	process(clock_1kHz, global_reset)
		variable counter_1_kHz    : integer range 0 to 10 := 0;
		variable counter_200_Hz   : integer range 0 to 10 := 0;
		variable counter_100_Hz   : integer range 0 to 10 := 0;
		variable counter_10_Hz    : integer range 0 to 10 := 0;
		variable counter_1_Hz     : integer range 0 to 3600 := 0;
		variable spill_counter         : integer range 0 to 60 := 1;
		constant spill_counter_maximum : integer range 0 to 60 := 2;
		variable fill_counter          : integer range 0 to 60 := 1;
		constant fill_counter_maximum  : integer range 0 to 60 := 4;
	begin
		if (global_reset = '1') then
			spill_active <= '1';
			fill_active  <= '0';
			counter_1_kHz   := 0;
			counter_200_Hz  := 0;
			counter_100_Hz  := 0;
			counter_10_Hz   := 0;
			counter_1_Hz    := 0;
			spill_counter   := 1;
			fill_counter    := 1;
			raw_100Hz_fake_trigger <= '0';
			raw_500Hz_fake_trigger <= '0';
		elsif rising_edge(clock_1kHz) then
			-- evaluated once per millisecond
			counter_1_kHz := counter_1_kHz + 1;
			if (counter_1_kHz > 4) then
				-- evaluated 200 times per second
				counter_1_kHz := 0;
				counter_200_Hz := counter_200_Hz + 1;
				raw_100Hz_fake_trigger <= not raw_100Hz_fake_trigger;
			end if;
			if (counter_200_Hz > 1) then
				-- evaluated 100 times per second
				counter_200_Hz := 0;
				counter_100_Hz := counter_100_Hz + 1;
			end if;
			if (counter_100_Hz > 9) then
				-- evaluated 10 times per second
				counter_100_Hz := 0;
				counter_10_Hz := counter_10_Hz + 1;
			end if;
--				raw_25Hz_fake_trigger <= not raw_25Hz_fake_trigger;
			if (counter_10_Hz > 9) then
				-- evaluated once per second
--				if (fiber_link_is_up = '0') then
--					pulsed_fiber_link_is_down = '1';
--					request_an_aurora_reset = '1';
--				end if;
				counter_10_Hz := 0;
				counter_1_Hz := counter_1_Hz + 1;
--				stupid_counter <= std_logic_vector(unsigned(stupid_counter) + 1);
				if (spill_counter < spill_counter_maximum) then
					spill_counter := spill_counter + 1;
				else
					spill_active <= '0';
					fill_active  <= '1';
					if (fill_counter < fill_counter_maximum) then
						fill_counter := fill_counter + 1;
					else
						spill_active <= '1';
						fill_active  <= '0';
						spill_counter := 1;
						fill_counter  := 1;
					end if;
				end if;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------
	process(clock_1kHz, global_reset, FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT)
		variable internal_COUNTER  : integer range 0 to 1000 := 0;
	begin
		if (	global_reset = '1' or
				FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT = '1' or
				request_a_fiber_link_reset = '1' or
				(should_not_automatically_try_to_keep_fiber_link_up = '0' and fiber_link_should_be_up = '1' and fiber_link_is_up = '0')
				) then
			fiber_link_should_be_up <= '0';
--			fiber_link_is_up <= '0';
			internal_COUNTER := 0;
			AURORA_RESET_IN <= '1';
			GT_RESET_IN     <= '1';
			internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE <= '1';
		elsif (rising_edge(clock_1kHz)) then
			-- an avago afbr-57r5aez requires the following (pdf, page 12):
			-- a rising edge on tx_disable (from page 12 note 1)
			-- a maximum power-up time of 300ms from power up or falling edge of
			--     tx_disable to when it can be used for data (from page 12 note 3)
			if (internal_COUNTER < 1) then
				internal_COUNTER := internal_COUNTER + 1;
				AURORA_RESET_IN <= '1';
				GT_RESET_IN     <= '1';
				fiber_link_is_up <= '0';
				internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE <= '1';
			elsif (internal_COUNTER < 2) then
				internal_COUNTER := internal_COUNTER + 1;
				internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE <= '0';
			elsif (internal_COUNTER < 302) then
				internal_COUNTER := internal_COUNTER + 1;
				AURORA_RESET_IN <= '0';
				GT_RESET_IN     <= '0';
			elsif (internal_COUNTER < 310) then
				internal_COUNTER := internal_COUNTER + 1;
			else
				fiber_link_is_up <= CHANNEL_UP_Buffer and LANE_UP_Buffer;
				if (FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER = '0') then
					fiber_link_should_be_up <= '1';
				else
					fiber_link_should_be_up <= '0';
				end if;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------
	process(external_trigger_disable)
	begin
		if (external_trigger_disable = '0') then
			gated_trigger <= external_triggers_ORed_together;
		else
			gated_trigger <= internal_trigger;
		end if;
	end process;
-----------------------------------------------------------------------------
	process (trigger_a_digitization_and_readout_event, transmit_always, trigger_acknowledge)
	begin
		if (trigger_acknowledge = '1') then
			pulsed_trigger <= '0';
		elsif (transmit_always = '1') then
			pulsed_trigger <= '1';
		elsif rising_edge(trigger_a_digitization_and_readout_event) then
			pulsed_trigger <= '1';
		end if;
	end process;
-----------------------------------------------------------------------------
	process (clock_1MHz, global_reset)
		variable trigger_acknowledge_counter : integer range 0 to 100 := 0;
	begin
		if (global_reset = '1') then
			trigger_acknowledge <= '0';
			trigger_acknowledge_counter := 0;
		elsif rising_edge(clock_1MHz) then
			if (internal_DONE_BUILDING_A_QUARTER_EVENT = '1') then
				if (trigger_acknowledge_counter < 30) then
					trigger_acknowledge <= '1';
					trigger_acknowledge_counter := trigger_acknowledge_counter + 1;
				else
					trigger_acknowledge <= '0';
				end if;
			else
				trigger_acknowledge <= '0';
				trigger_acknowledge_counter := 0;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------
--	process(internal_COUNTER(27)) begin
--		if rising_edge(internal_COUNTER(27)) then
--			RESET <= '0';
--			GT_RESET_IN <= '0';
--		end if;
--	end process;
--	internal_acknowledge_start_event_transfer <= '0';
-----------------------------------------------------------------------------
    -- Register User I/O --
    -- Register User Outputs from core.
	process (user_clk_i)
	begin
		if (user_clk_i 'event and user_clk_i = '1') then
			HARD_ERR_Buffer    <= hard_err_i;
			SOFT_ERR_Buffer    <= soft_err_i;
			ERR_COUNT_Buffer   <= err_count_i;
			LANE_UP_Buffer     <= lane_up_i;
			CHANNEL_UP_Buffer  <= channel_up_i;
		end if;
	end process;
-----------------------------------------------------------------------------
	lane_up_reduce_i    <=  lane_up_i;
	
	HARD_ERR    <= HARD_ERR_Buffer;
	SOFT_ERR    <= SOFT_ERR_Buffer;
	ERR_COUNT   <= ERR_COUNT_Buffer;
	LANE_UP     <= LANE_UP_Buffer;
	CHANNEL_UP  <= CHANNEL_UP_Buffer;
	TXP         <= TXP_Buffer;
	TXN         <= TXN_Buffer;

	INIT_CLK <= internal_COUNTER(2);
-----------------------------------------------------------------------------
	LVDS_SIMPLE_TRIGGER  : IBUFDS port map (I => REMOTE_SIMPLE_TRIGGER_P,  IB => REMOTE_SIMPLE_TRIGGER_N,  O => external_trigger_2_from_LVDS);
	LVDS_ENCODED_TRIGGER : IBUFDS port map (I => REMOTE_ENCODED_TRIGGER_P, IB => REMOTE_ENCODED_TRIGGER_N, O => external_encoded_trigger_from_LVDS);

	internal_trigger <= raw_100Hz_fake_trigger;
--	external_triggers_ORed_together <= external_trigger_1_from_monitor_header or external_trigger_2_from_LVDS;
	external_triggers_ORed_together <= external_trigger_2_from_LVDS;
--	external_triggers_ORed_together <= external_trigger_1_from_monitor_header;
	gated_fill_inactive <= fake_spill_structure_enable nand fill_active;
	trigger_a_digitization_and_readout_event <= gated_fill_inactive and gated_trigger;
	internal_PACKET_GENERATOR_ENABLE(1) <= '1';--trigger_a_digitization_and_readout_event or transmit_always;
	internal_PACKET_GENERATOR_ENABLE(0) <= not transmit_disable;
--	trigger_a_digitization_and_readout_event
--	pulsed_trigger <= trigger_a_digitization_and_readout_event or transmit_always;
-----------------------------------------------------------------------------
	LEDS(0) <= fiber_link_is_up;
	LEDS(1) <= fiber_link_should_be_up;
	LEDS(2) <= AURORA_RESET_IN or GT_RESET_IN;
	LEDS(3) <= global_reset;

	LEDS(4) <= internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE;
	LEDS(5) <= FIBER_TRANSCEIVER_0_LASER_FAULT_DETECTED_IN_TRANSMITTER;
	LEDS(6) <= FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER;
	LEDS(7) <= FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT;

	LEDS(8)  <= raw_500Hz_fake_trigger;
	LEDS(9)  <= external_trigger_1_from_monitor_header;
--	LEDS(10) <= external_triggers_ORed_together;
	LEDS(10) <= pulsed_trigger;
	LEDS(11) <= gated_trigger;
	
	LEDS(15 downto 12) <= internal_number_of_sent_events(3 downto 0);

--	LEDS(6) <= tx_lock_i;
--	LEDS(7) <= pll_not_locked_i;
--	LEDS(7) <= internal_COUNTER(26);
--	LEDS(15 downto 12) <= ERR_COUNT_Buffer(0 downto 3);
--	LEDS(11 downto 9) <= internal_DATA_GENERATOR_STATE;
--	LEDS(2) <= HARD_ERR_Buffer;
--	LEDS() <= SOFT_ERR_Buffer;
-----------------------------------------------------------------------------
	MONITOR_HEADER_OUTPUT(0) <= tx_src_rdy_n_i;
	MONITOR_HEADER_OUTPUT(1) <= clock_1MHz;
	MONITOR_HEADER_OUTPUT(2) <= clock_1kHz;
	MONITOR_HEADER_OUTPUT(10 downto 3) <= (others => '0');
	
	MONITOR_HEADER_OUTPUT(11) <= external_trigger_2_from_LVDS;

	MONITOR_HEADER_OUTPUT(12) <= pulsed_trigger;
	MONITOR_HEADER_OUTPUT(13) <= raw_100Hz_fake_trigger;
	MONITOR_HEADER_OUTPUT(14) <= raw_500Hz_fake_trigger;
	external_trigger_1_from_monitor_header <= MONITOR_HEADER_INPUT(15);
-----------------------------------------------------------------------------
	FIBER_TRANSCEIVER_0_DISABLE_MODULE <= internal_FIBER_TRANSCEIVER_0_DISABLE_MODULE;
	FIBER_TRANSCEIVER_1_DISABLE_MODULE <= '1';
-----------------------------------------------------------------------------
	IBUFDS_i  :  IBUFDS  port map (I  => GTPD2_P, IB => GTPD2_N, O  => GTPD2_left_i);

	IBUFGDS_i_local  : IBUFGDS port map (I => board_clock_250MHz_P, IB => board_clock_250MHz_N, O => internal_clock_250MHz);
	IBUFGDS_i_remote : IBUFGDS port map (I => REMOTE_CLOCK_P, IB => REMOTE_CLOCK_N, O => internal_clock_from_remote_source);
	internal_clock_for_state_machine <= internal_clock_250MHz;

	BUFIO2_i : BUFIO2 generic map (
		DIVIDE         =>      1,
		DIVIDE_BYPASS  =>      TRUE
	) port map (
		I              =>      gtpclkout_i,
		DIVCLK         =>      buf_gtpclkout_i,
		IOCLK          =>      open,
		SERDESSTROBE   =>      open
	);

	-- Instantiate a clock module for clock division
	clock_module_i : Aurora_IP_Core_A_CLOCK_MODULE
	port map (
		GT_CLK          => buf_gtpclkout_i,
		GT_CLK_LOCKED   => tx_lock_i,
		USER_CLK        => user_clk_i,
		SYNC_CLK        => sync_clk_i,
		PLL_NOT_LOCKED  => pll_not_locked_i
	);

    -- System Interface
	power_down_i     <= '0';
	loopback_i       <= "000";

	-- Connect a frame checker to the user interface
--	frame_check_i : Aurora_IP_Core_A_FRAME_CHECK

	frame_check_i : Packet_Receiver
	port map (
		-- User Interface
		RX_D            =>  rx_d_i, 
		RX_SRC_RDY_N    =>  rx_src_rdy_n_i,  
		-- System Interface
		USER_CLK        =>  user_clk_i,   
		RESET           =>  reset_i,
		CHANNEL_UP      =>  channel_up_i,
		WRONG_PACKET_SIZE_COUNTER => internal_WRONG_PACKET_SIZE_COUNTER,
		WRONG_PACKET_TYPE_COUNTER => internal_WRONG_PACKET_TYPE_COUNTER,
		WRONG_PROTOCOL_FREEZE_DATE_COUNTER => internal_WRONG_PROTOCOL_FREEZE_DATE_COUNTER,
		WRONG_SCROD_ADDRESSED_COUNTER => internal_WRONG_SCROD_ADDRESSED_COUNTER,
		WRONG_CHECKSUM_COUNTER => internal_WRONG_CHECKSUM_COUNTER,
		WRONG_FOOTER_COUNTER => internal_WRONG_FOOTER_COUNTER,
		UNKNOWN_ERROR_COUNTER => internal_UNKNOWN_ERROR_COUNTER,
		MISSING_ACKNOWLEDGEMENT_COUNTER => internal_MISSING_ACKNOWLEDGEMENT_COUNTER,
		number_of_sent_events => internal_number_of_sent_events,
		NUMBER_OF_WORDS_IN_THIS_PACKET_RECEIVED_SO_FAR => internal_NUMBER_OF_WORDS_IN_THIS_PACKET_RECEIVED_SO_FAR,
		resynchronizing_with_header => internal_resynchronizing_with_header,
		start_event_transfer => internal_start_event_transfer,
		acknowledge_start_event_transfer => internal_acknowledge_start_event_transfer,
		ERR_COUNT       =>  err_count_i
	);

--    --Connect a frame generator to the user interface
--    frame_gen_i : Aurora_IP_Core_A_FRAME_GEN
--    port map
--    (
--        -- User Interface
--        TX_D            =>  tx_d_i,
--        TX_SRC_RDY_N    =>  tx_src_rdy_n_i,
--        TX_DST_RDY_N    =>  tx_dst_rdy_n_i,    
--
--
--        -- System Interface
--        USER_CLK        =>  user_clk_i,
--        RESET           =>  reset_i,
--        CHANNEL_UP      =>  channel_up_i
--    ); 

	QEB : quarter_event_builder port map (
		RESET                              => reset_i,
		CLOCK                              => user_clk_i,
		INPUT_DATA_BUS                     => internal_ASIC_DATA_BLOCKRAM_DATA_BUS,
		INPUT_ADDRESS_BUS                  => internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS,
		ADDRESS_OF_STARTING_WINDOW_IN_ASIC => internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC,
		OUTPUT_DATA_BUS                    => internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS,
		OUTPUT_ADDRESS_BUS                 => open,
		OUTPUT_FIFO_WRITE_ENABLE           => internal_QUARTER_EVENT_FIFO_WRITE_ENABLE,
		START_BUILDING_A_QUARTER_EVENT     => internal_START_BUILDING_A_QUARTER_EVENT,
		DONE_BUILDING_A_QUARTER_EVENT      => internal_DONE_BUILDING_A_QUARTER_EVENT
	);
--	internal_ASIC_DATA_BLOCKRAM_DATA_BUS <= x"1812"; -- upper four bits should be masked off elsewhere, so should see 0x0812
	internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC <= "0" & x"64";
	internal_START_BUILDING_A_QUARTER_EVENT <= quarter_event_builder_enable and pulsed_trigger;
	quarter_event_builder_enable <= not transmit_disable;

	PDBR : pseudo_data_block_ram port map (
		CLOCK      => user_clk_i,
		ADDRESS_IN => internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS,
		DATA_OUT   => internal_ASIC_DATA_BLOCKRAM_DATA_BUS
	);

	chipscope_ila_data(31 downto 0)  <= internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS;
	chipscope_ila_data(63 downto 32) <= internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS;
	chipscope_ila_data(232 downto 64) <= (others => '0');
	chipscope_ila_data(233) <= quarter_event_fifo_is_empty; -- warning:  this happens much faster than 1MHz, so it'll look like it rarely changes
	chipscope_ila_data(234) <= tx_dst_rdy_n_i; -- warning:  this happens much faster than 1MHz, so it'll look like it rarely changes
	chipscope_ila_data(249 downto 235) <= internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS;
	chipscope_ila_data(250) <= quarter_event_fifo_read_enable; -- warning:  this happens much faster than 1MHz, so it'll look like it rarely changes
	chipscope_ila_data(251) <= tx_src_rdy_n_i; -- warning:  this happens much faster than 1MHz, so it'll look like it rarely changes
	chipscope_ila_data(252) <= quarter_event_builder_enable;
	chipscope_ila_data(253) <= internal_QUARTER_EVENT_FIFO_WRITE_ENABLE;
	chipscope_ila_data(254) <= internal_START_BUILDING_A_QUARTER_EVENT;
	chipscope_ila_data(255) <= internal_DONE_BUILDING_A_QUARTER_EVENT;

	chipscope_ila_trigger(0) <= internal_START_BUILDING_A_QUARTER_EVENT;
	chipscope_ila_trigger(1) <= quarter_event_fifo_read_enable;
	chipscope_ila_trigger(255 downto 2) <= (others => '0');

	QUARTER_EVENT_FIFO : entity work.quarter_event_fifo port map (
		rst    => reset_i,
		wr_clk => user_clk_i,
		rd_clk => user_clk_i,
		din    => internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS,
		wr_en  => internal_QUARTER_EVENT_FIFO_WRITE_ENABLE,
		rd_en  => quarter_event_fifo_read_enable,
		dout   => internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS,
		full   => open,
		empty  => quarter_event_fifo_is_empty,
		valid  => open
	);
--	inverted_clock_1MHz <= not clock_1MHz;
	-- might want to have an additional signal anded with these that is a
	-- set-reset flip flop that is set when the quarter event is finished
	--	building and cleared when another one is started:
	quarter_event_fifo_read_enable <= (not quarter_event_fifo_is_empty) and (not tx_dst_rdy_n_i);
	tx_src_rdy_n_i <= not quarter_event_fifo_read_enable;
	tx_d_i <= internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS;

--	Packet_Generator_A : Packet_Generator
--	port map
--	( 
--		TX_DST_RDY_N 	=> tx_dst_rdy_n_i,
--		USER_CLK 		=> user_clk_i,
--		RESET 			=> reset_i,
--		CHANNEL_UP 		=> channel_up_i,
--		ENABLE 			=> internal_PACKET_GENERATOR_ENABLE,
--		TRIGGER        => pulsed_trigger,
--		TRIGGER_ACK    => trigger_acknowledge,
--		TX_SRC_RDY_N 	=> tx_src_rdy_n_i,
--		TX_D 				=> tx_d_i,
--		DATA_GENERATOR_STATE => internal_DATA_GENERATOR_STATE,
--		VARIABLE_DELAY_BETWEEN_EVENTS => internal_VARIABLE_DELAY_BETWEEN_EVENTS
--	);
	internal_DATA_GENERATOR_STATE <= (others => '0');

	aurora_module_i : Aurora_IP_Core_A
	generic map(
		SIM_GTPRESET_SPEEDUP => SIM_GTPRESET_SPEEDUP
	)
	port map (
		-- LocalLink TX Interface
		TX_D             => tx_d_i,
		TX_SRC_RDY_N     => tx_src_rdy_n_i,
		TX_DST_RDY_N     => tx_dst_rdy_n_i,
		-- LocalLink RX Interface
		RX_D             => rx_d_i,
		RX_SRC_RDY_N     => rx_src_rdy_n_i,
		-- V5 Serial I/O
		RXP              => RXP,
		RXN              => RXN,
		TXP              => TXP_Buffer,
		TXN              => TXN_Buffer,
		-- V5 Reference Clock Interface
		GTPD2    => GTPD2_left_i,
		-- Error Detection Interface
		HARD_ERR       => hard_err_i,
		SOFT_ERR       => soft_err_i,
		-- Status
		CHANNEL_UP       => channel_up_i,
		LANE_UP          => lane_up_i,
		-- Clock Compensation Control Interface
		WARN_CC          => warn_cc_i,
		DO_CC            => do_cc_i,
		-- System Interface
		USER_CLK         => user_clk_i,
		SYNC_CLK         => sync_clk_i,
		RESET            => reset_i,
		POWER_DOWN       => power_down_i,
		LOOPBACK         => loopback_i,
		GT_RESET         => gt_reset_i,
		GTPCLKOUT        => gtpclkout_i,
		TX_LOCK          => tx_lock_i,
		-- Kurtis added
		RX_CHAR_IS_COMMA => rx_char_is_comma_i,
		LANE_INIT_STATE  => lane_init_state_i,
		RESET_LANES      => reset_lanes_i,
		TX_PE_DATA       => tx_pe_data_i
		);

	standard_cc_module_i : Aurora_IP_Core_A_STANDARD_CC_MODULE
		port map (
		-- Clock Compensation Control Interface
		WARN_CC        => warn_cc_i,
		DO_CC          => do_cc_i,
		-- System Interface
		PLL_NOT_LOCKED => pll_not_locked_i,
		USER_CLK       => user_clk_i,
		RESET          => not(lane_up_reduce_i)
	);

	reset_logic_i : Aurora_IP_Core_A_RESET_LOGIC
	port map (
		RESET            => AURORA_RESET_IN,
		USER_CLK         => user_clk_i,
		INIT_CLK         => INIT_CLK,
		GT_RESET_IN      => GT_RESET_IN,
		TX_LOCK_IN       => tx_lock_i,
		PLL_NOT_LOCKED   => pll_not_locked_i,
		SYSTEM_RESET     => system_reset_i,
		GT_RESET_OUT     => gt_reset_i
	);

	chipscope1 : if USE_CHIPSCOPE = 1 generate
--		sync_in_i <= (others => '0');
		lane_up_i_i    <= lane_up_i;
		tx_lock_i_i    <= tx_lock_i;
		-- aurora status:
--		sync_in_i(6 downto 0) <= lane_init_state_i;
		sync_in_i(0)          <= lane_up_i_i and channel_up_i;
		sync_in_i(1)          <= quarter_event_builder_enable;
		sync_in_i(2)          <= pulsed_trigger;
		sync_in_i(3)          <= internal_START_BUILDING_A_QUARTER_EVENT;
		sync_in_i(4)          <= internal_DONE_BUILDING_A_QUARTER_EVENT;
		sync_in_i(5)          <= trigger_acknowledge;
		sync_in_i(6)          <= internal_QUARTER_EVENT_FIFO_WRITE_ENABLE;
		sync_in_i(7)          <= quarter_event_fifo_is_empty;
		sync_in_i(8)          <= tx_dst_rdy_n_i;
		sync_in_i(9)          <= quarter_event_fifo_read_enable;
--		sync_in_i(8 downto 5) <= (others => '0');
--		sync_in_i(9)          <= pll_not_locked_i;
		-- data generator status:
--		sync_in_i(11 downto 9) <= internal_DATA_GENERATOR_STATE;
		-- data receiver status:
--		sync_in_i(19 downto 12) <= internal_NUMBER_OF_WORDS_IN_THIS_PACKET_RECEIVED_SO_FAR(7 downto 0);
--		sync_in_i(20)           <= internal_resynchronizing_with_header;
--		sync_in_i(22)           <= tx_src_rdy_n_i;
--		sync_in_i(9)            <= internal_start_event_transfer;
--		sync_in_i(10)           <= reset_i;
		sync_in_i(10)           <= spill_active;
--		sync_in_i(61)           <= fill_active;
		sync_in_i(13 downto 11) <= internal_WRONG_PACKET_SIZE_COUNTER(2 downto 0);
		sync_in_i(16 downto 14) <= internal_WRONG_PACKET_TYPE_COUNTER(2 downto 0);
		sync_in_i(19 downto 17) <= internal_WRONG_PROTOCOL_FREEZE_DATE_COUNTER(2 downto 0);
		sync_in_i(22 downto 20) <= internal_WRONG_SCROD_ADDRESSED_COUNTER(2 downto 0);
		sync_in_i(25 downto 23) <= internal_WRONG_CHECKSUM_COUNTER(2 downto 0);
		sync_in_i(28 downto 26) <= internal_WRONG_FOOTER_COUNTER(2 downto 0);
		sync_in_i(31 downto 29) <= internal_UNKNOWN_ERROR_COUNTER(2 downto 0);
		sync_in_i(63 downto 32) <= internal_number_of_sent_events(31 downto 0);
--		sync_in_i(59 downto 56) <= internal_MISSING_ACKNOWLEDGEMENT_COUNTER(3 downto 0);
--		sync_in_i(63 downto 62) <= stupid_counter(1 downto 0);
--		sync_in_i(63 downto 62) <= (others => '0');
		
		transmit_always                                    <= sync_out_i(1);
		transmit_disable                                   <= sync_out_i(2);
		internal_acknowledge_start_event_transfer          <= sync_out_i(35);
		external_trigger_disable                           <= sync_out_i(36);
		fake_spill_structure_enable                        <= sync_out_i(37);
		request_a_global_reset                             <= sync_out_i(38);
		request_a_fiber_link_reset                         <= sync_out_i(39);
		should_not_automatically_try_to_keep_fiber_link_up <= sync_out_i(40);

		i_icon : s6_icon
		port map (
			control0    => icon_to_vio_i,
			control1    => icon_to_ila_i
		);

		i_vio : s6_vio
		port map (
			control   => icon_to_vio_i,
			clk       => user_clk_i,
			sync_in   => sync_in_i,
			sync_out  => sync_out_i
		);

		i_ila : s6_ila
		port map (
			control  => icon_to_ila_i,
			clk      => user_clk_i, -- clock_1MHz,
			data     => chipscope_ila_data,
			trig0    => chipscope_ila_trigger,
			trig_out => open
		);
	end generate chipscope1;

	no_chipscope1 : if USE_CHIPSCOPE = 0 generate
		sync_in_i  <= (others=>'0');
	end generate no_chipscope1;

	chipscope2 : if USE_CHIPSCOPE = 1 generate
		-- Shared VIO Outputs
		reset_i <= system_reset_i or chipscope_aurora_reset or global_reset;
		chipscope_aurora_reset                 <= sync_out_i(0);
		internal_VARIABLE_DELAY_BETWEEN_EVENTS <= sync_out_i(34 downto 3);
	end generate chipscope2;

	no_chipscope2 : if USE_CHIPSCOPE = 0 generate
		-- Shared VIO Outputs
		reset_i <= system_reset_i or global_reset;
	end generate no_chipscope2;

end MAPPED;
