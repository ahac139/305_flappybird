library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video_render is
	port(Clk							: in std_logic;
	state								: in std_logic_vector(1 downto 0);
	char_on, bird_on, pipe_on, inv_on, power_up_on 	: in std_logic;
	Red, Green, Blue 				: out std_logic_vector(3 downto 0) := "0000"
	);
end entity video_render;


architecture behaviour of video_render is 


begin

	Red 	<= "1111" when (char_on = '1') else
				"1111" when (bird_on = '1') else
				"0000";
				
	Green <= "1111" when (char_on = '1') else
				"1111" when (bird_on = '1') and (inv_on = '1') else
				"1111" when (pipe_on = '1') else
				"0000";
				
	Blue 	<= "1111" when (char_on = '1') else
				"1111" when (bird_on = '1') and (inv_on = '1') else
				"1111" when (power_up_on = '1') else
				"0000";


end behaviour;