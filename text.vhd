LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity text is
	port(Clk						: in std_logic;
	
	--Inputs from Sytem
	state, mode					: in std_logic_vector(1 downto 0);
	score							: in std_logic_vector(3 downto 0);
	pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
	
	--Outputs to System
	char_on						: out std_logic
	
	);
end entity text;


architecture behavior of text is

--State components and signals
signal menu_text_on : std_logic;
component menu_text is
port(Clk							:  std_logic;
	pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
	char_on						: out std_logic);
END component;

SIGNAL pause_text_on : std_logic;
component pause_text is
port(Clk							:  std_logic;
	pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
	char_on						: out std_logic);
END component;

BEGIN

--Component creation
menu : menu_text port map(
		clk	 		=> clk,
		pixel_row 	=> pixel_row,
		pixel_column => pixel_column,
		char_on 		=> menu_text_on);
		
pause	: menu_text port map(
		clk	 		=> clk,
		pixel_row 	=> pixel_row,
		pixel_column => pixel_column,
		char_on 		=> pause_text_on);

--
process(state, menu_text_on)
begin
	case state is
		when "00" => char_on <= menu_text_on;
		when "10" => char_on <= pause_text_on;
		when others => char_on <= '0';
			
	end case;
end process;
END behavior;

