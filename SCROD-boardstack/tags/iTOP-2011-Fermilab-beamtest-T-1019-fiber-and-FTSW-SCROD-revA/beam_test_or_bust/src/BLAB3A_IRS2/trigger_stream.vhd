----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:44 10/03/2011 
-- Design Name: 
-- Module Name:    trigger_stream - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.Board_Stack_Definitions.ALL;

entity trigger_stream is
    Port ( TRIGGER_BIT                         : in  std_logic;
			  CLOCK_4xSST                         : in  std_logic;
			  CLOCK_SST                           : in  std_logic;
			  CONTINUE_WRITING                    : in  std_logic;
           STREAM_OUT                          : out ASIC_Trigger_Stream;
			  WINDOWS_TO_LOOK_BACK                : in  std_logic_vector(8 downto 0)
			);
end trigger_stream;

architecture Behavioral of trigger_stream is
	signal internal_TRIGGER_STREAM : std_logic_vector(1023 downto 0) := (others => '0');
	signal internal_WINDOWS_TO_LOOK_BACK : unsigned(8 downto 0);
	signal internal_STILL_STREAMING : std_logic := '1';
begin

	internal_WINDOWS_TO_LOOK_BACK <= unsigned(WINDOWS_TO_LOOK_BACK);

	process(CONTINUE_WRITING, CLOCK_4xSST)	
		variable stop_counter : integer range 0 to 15 := 0;
	begin
		if ( rising_edge(CLOCK_4xSST) ) then
			--Only shift in the trigger stream bit if we're still sampling		
			if (CONTINUE_WRITING = '0' and stop_counter >= 4) then
				internal_STILL_STREAMING <= '0';
			else 
				internal_STILL_STREAMING <= '1';
				if (CONTINUE_WRITING = '1') then
					stop_counter := 0;
				else
					stop_counter := stop_counter + 1;
				end if;

				--Shift all bits by one spot, except for lowest bit...
				for i in 1023 downto 1 loop
					internal_TRIGGER_STREAM(i) <= internal_TRIGGER_STREAM(i-1);
				end loop;
				--Lowest bit should be the current status of the trigger bit.
				internal_TRIGGER_STREAM(0) <= TRIGGER_BIT;

			end if;
		end if;
	end process;


	process(internal_STILL_STREAMING, CLOCK_4xSST) 
		variable counter : integer range 0 to 32 := 0;
		variable bit_counter : integer range 0 to 15 := 0;
		variable look_back_index_high : integer range 0 to 1023 := 15;
	begin
		if ( rising_edge(CLOCK_SST) ) then
			if ( internal_STILL_STREAMING = '1' ) then
				counter := 0;
			else
				if (counter = 0) then 
					look_back_index_high := to_integer(internal_WINDOWS_TO_LOOK_BACK) * 2 - 1 + 8;
					counter := counter + 1;
				elsif (counter <= 16) then
					STREAM_OUT(16 - counter) <= internal_TRIGGER_STREAM( look_back_index_high - counter - 1);
					counter := counter + 1;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

