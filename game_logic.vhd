library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_logic is
	port(
	--Inputs from Board
	PB									: in std_logic_vector(3 downto 0);
	SW 								: in std_logic_vector(9 downto 0);
	PS2_DAT, PS2_CLK 				: inout std_logic;
	
	--Outputs to Board
	HEX0, HEX1, HEX2 				: out std_logic_vector(6 downto 0) := "0000000";
	LEDR								: out std_logic_vector(9 downto 0) := "0000000000";
	
	--Outputs to System
	state								: out std_logic_vector(1 downto 0) := "00";
	char_on, bird_on, pipe_on	: out std_logic := '0';
	
	Clk								: in std_logic
	);
end entity game_logic;

architecture behaviour of game_logic is

begin

end behaviour;