-- 2011-09 mza
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity fiber_readout is
	generic (
		CURRENT_PROTOCOL_FREEZE_DATE                   : std_logic_vector(31 downto 0) := x"20110910";
		NUMBER_OF_SLOW_CLOCK_CYCLES_PER_MILLISECOND    : integer :=  1; -- set to 83 for an 83kHz clock input
		WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS    : integer := 32;
		WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_ADDRESS_BUS : integer := 17;
		WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS           : integer := 16;
		WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS        : integer := 13;
		NUMBER_OF_INPUT_BLOCK_RAMS                     : integer :=  2;
		SIM_GTPRESET_SPEEDUP                           : integer :=  1  --Set to 1 to speed up sim reset
	);
	port (
		RESET                                                   : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_RESET                       : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_initialization_clock        : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_reset_clock                 : in    std_logic;
		-- fiber optic dual clock input
		Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_P             : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_N             : in    std_logic;
		-- fiber optic transceiver #101 lane 0 I/O
		Aurora_RocketIO_GTP_MGT_101_lane0_Receive_P             : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_lane0_Receive_N             : in    std_logic;
		Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_P            :   out std_logic;
		Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_N            :   out std_logic;
		FIBER_TRANSCEIVER_0_LASER_FAULT_DETECTED_IN_TRANSMITTER : in    std_logic;
		FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER : in    std_logic;
 		FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT  : in    std_logic;
		FIBER_TRANSCEIVER_0_DISABLE_MODULE                      :   out std_logic;
		-- fiber optic transceiver #101 lane 1 I/O
		FIBER_TRANSCEIVER_1_DISABLE_MODULE                      :   out std_logic;
		Aurora_78MHz_clock                                      :   out std_logic;
		should_not_automatically_try_to_keep_fiber_link_up      : in    std_logic;
		fiber_link_is_up                                        :   out std_logic;
		-----------------------------------------------------------------------------
		Aurora_RocketIO_GTP_MGT_101_status_LEDs                 :   out std_logic_vector(3 downto 0);
		chipscope_ila                                           :   out std_logic_vector(255 downto 0);
		chipscope_vio_buttons                                   : in    std_logic_vector(255 downto 0);
		chipscope_vio_display                                   :   out std_logic_vector(255 downto 0);
		-----------------------------------------------------------------------------
		TRIGGER                                                 : in    std_logic;
		DONE_BUILDING_A_QUARTER_EVENT                           :   out std_logic;
		-----------------------------------------------------------------------------
		INPUT_DATA_BUS                                          : in    std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS-1     downto 0);
		INPUT_ADDRESS_BUS                                       :   out std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS-1  downto 0);
		INPUT_BLOCK_RAM_ADDRESS                                 :   out std_logic_vector(NUMBER_OF_INPUT_BLOCK_RAMS-1  downto 0);
		ADDRESS_OF_STARTING_WINDOW_IN_ASIC                      : in    std_logic_vector(8 downto 0)
	);
end fiber_readout;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

architecture behavioral of fiber_readout is
	signal trigger_acknowledge : std_logic;
-----------------------------------------------------------------------------
--	signal should_not_automatically_try_to_keep_fiber_link_up : std_logic;
--	signal fiber_link_is_up                                   : std_logic;
	signal Aurora_data_link_reset                             : std_logic;
	signal internal_Aurora_78MHz_clock                        : std_logic;
--	signal Aurora_RocketIO_GTP_MGT_101_status_LEDs            : std_logic_vector(3 downto 0);
-----------------------------------------------------------------------------
	signal internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC : std_logic_vector(8 downto 0) := "1" & x"f0";
	signal internal_INPUT_BLOCK_RAM_ADDRESS            : std_logic_vector(NUMBER_OF_INPUT_BLOCK_RAMS-1  downto 0);
	signal internal_ASIC_DATA_BLOCKRAM_DATA_BUS        : std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_DATA_BUS-1        downto 0);
	signal internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS     : std_logic_vector(WIDTH_OF_ASIC_DATA_BLOCKRAM_ADDRESS_BUS-1     downto 0);
	signal internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS  : std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS-1 downto 0);
	signal internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS : std_logic_vector(WIDTH_OF_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS-1 downto 0);
	signal internal_QUARTER_EVENT_FIFO_WRITE_ENABLE    : std_logic;
	signal internal_START_BUILDING_A_QUARTER_EVENT     : std_logic;
--	signal internal_DONE_BUILDING_A_QUARTER_EVENT      : std_logic;
	signal quarter_event_builder_enable : std_logic := '0';
	signal quarter_event_fifo_read_enable : std_logic := '0';
	signal quarter_event_fifo_is_empty    : std_logic;
	-- Stream TX Interface ------------------------------------------------------
	signal Aurora_lane0_transmit_data_bus                     : std_logic_vector(0 to 31);
	signal Aurora_lane0_transmit_source_ready_active_low      : std_logic;
	signal Aurora_lane0_transmit_destination_ready_active_low : std_logic;
	-- Stream RX Interface ------------------------------------------------------
	signal Aurora_lane0_receive_data_bus                      : std_logic_vector(0 to 31);
	signal Aurora_lane0_receive_source_ready_active_low       : std_logic;
-----------------------------------------------------------------------------
begin
	Aurora_data_link : entity work.Aurora_RocketIO_GTP_MGT_101
	generic map (
		CURRENT_PROTOCOL_FREEZE_DATE                => CURRENT_PROTOCOL_FREEZE_DATE,
		NUMBER_OF_SLOW_CLOCK_CYCLES_PER_MILLISECOND => NUMBER_OF_SLOW_CLOCK_CYCLES_PER_MILLISECOND
	)
	port map (
		RESET                                                   => Aurora_data_link_reset,
		Aurora_RocketIO_GTP_MGT_101_initialization_clock        => Aurora_RocketIO_GTP_MGT_101_initialization_clock,
		Aurora_RocketIO_GTP_MGT_101_reset_clock                 => Aurora_RocketIO_GTP_MGT_101_reset_clock,
		Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_P             => Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_P,
		Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_N             => Aurora_RocketIO_GTP_MGT_101_CLOCK_156_MHz_N,
		Aurora_RocketIO_GTP_MGT_101_lane0_Receive_P             => Aurora_RocketIO_GTP_MGT_101_lane0_Receive_P,
		Aurora_RocketIO_GTP_MGT_101_lane0_Receive_N             => Aurora_RocketIO_GTP_MGT_101_lane0_Receive_N,
		Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_P            => Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_P,
		Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_N            => Aurora_RocketIO_GTP_MGT_101_lane0_Transmit_N,
		FIBER_TRANSCEIVER_0_LASER_FAULT_DETECTED_IN_TRANSMITTER => FIBER_TRANSCEIVER_0_LASER_FAULT_DETECTED_IN_TRANSMITTER,
		FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER => FIBER_TRANSCEIVER_0_LOSS_OF_SIGNAL_DETECTED_BY_RECEIVER,
 		FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT  => FIBER_TRANSCEIVER_0_MODULE_DEFINITION_0_LOW_IF_PRESENT,
		FIBER_TRANSCEIVER_0_DISABLE_MODULE                      => FIBER_TRANSCEIVER_0_DISABLE_MODULE,
		FIBER_TRANSCEIVER_1_DISABLE_MODULE                      => FIBER_TRANSCEIVER_1_DISABLE_MODULE,
		Aurora_78MHz_clock                                      => internal_Aurora_78MHz_clock,
		Aurora_lane0_transmit_data_bus                          => Aurora_lane0_transmit_data_bus,
		Aurora_lane0_transmit_source_ready_active_low           => Aurora_lane0_transmit_source_ready_active_low,
		Aurora_lane0_transmit_destination_ready_active_low      => Aurora_lane0_transmit_destination_ready_active_low,
		Aurora_lane0_receive_source_ready_active_low            => Aurora_lane0_receive_source_ready_active_low,
		Aurora_lane0_receive_data_bus                           => Aurora_lane0_receive_data_bus,
		should_not_automatically_try_to_keep_fiber_link_up      => should_not_automatically_try_to_keep_fiber_link_up,
		fiber_link_is_up                                        => fiber_link_is_up,
		status_LEDs                                             => Aurora_RocketIO_GTP_MGT_101_status_LEDs,
		chipscope_ila                                           => open,
		chipscope_vio_buttons                                   => chipscope_vio_buttons,
		chipscope_vio_display                                   => chipscope_vio_display
	);

	QEB : entity work.quarter_event_builder
	generic map (
		CURRENT_PROTOCOL_FREEZE_DATE => CURRENT_PROTOCOL_FREEZE_DATE
	)
	port map (
		RESET                              => RESET,
		CLOCK                              => internal_Aurora_78MHz_clock,
		INPUT_DATA_BUS                     => internal_ASIC_DATA_BLOCKRAM_DATA_BUS,
		INPUT_ADDRESS_BUS                  => internal_ASIC_DATA_BLOCKRAM_ADDRESS_BUS,
		INPUT_BLOCK_RAM_ADDRESS            => internal_INPUT_BLOCK_RAM_ADDRESS,
		ADDRESS_OF_STARTING_WINDOW_IN_ASIC => internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC,
		OUTPUT_DATA_BUS                    => internal_QUARTER_EVENT_FIFO_INPUT_DATA_BUS,
		OUTPUT_ADDRESS_BUS                 => open,
		OUTPUT_FIFO_WRITE_ENABLE           => internal_QUARTER_EVENT_FIFO_WRITE_ENABLE,
		START_BUILDING_A_QUARTER_EVENT     => internal_START_BUILDING_A_QUARTER_EVENT,
		DONE_BUILDING_A_QUARTER_EVENT      => DONE_BUILDING_A_QUARTER_EVENT
	);
--	internal_ASIC_DATA_BLOCKRAM_DATA_BUS <= x"1812"; -- upper four bits should be masked off elsewhere, so should see 0x0812
	internal_ADDRESS_OF_STARTING_WINDOW_IN_ASIC <= "0" & x"59";
	internal_START_BUILDING_A_QUARTER_EVENT <= quarter_event_builder_enable and TRIGGER;
	quarter_event_builder_enable <= '1';
--	quarter_event_builder_enable <= not transmit_disable;

	QEF : entity work.quarter_event_fifo port map (
		rst    => RESET,
		wr_clk => internal_Aurora_78MHz_clock,
		rd_clk => internal_Aurora_78MHz_clock,
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
	quarter_event_fifo_read_enable <= (not quarter_event_fifo_is_empty) and (not Aurora_lane0_transmit_destination_ready_active_low);
	Aurora_lane0_transmit_source_ready_active_low <= not quarter_event_fifo_read_enable;
	Aurora_lane0_transmit_data_bus <= internal_QUARTER_EVENT_FIFO_OUTPUT_DATA_BUS;

end behavioral;