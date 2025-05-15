library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity game_state is
	port(Clk					: in std_logic;
	
	--Inputs from Board
	pb1, pb2, pb3, pb4	: in std_logic;
	SW 						: in std_logic_vector(9 downto 0);
	PS2_DAT, PS2_CLK 		: inout std_logic;
	
	--Inputs from Sytem
	obj_on					: in std_logic_vetor(9 downto 0);
	
	--Outputs to Board
	hex0, hex1, hex2 		: out std_logic_vector(6 downto 0);
	LEDR						: out std_logic_vector(9 downto 0) := "0000000000";
	
	--Outputs to System
	state, mode				: out std_logic_vector(1 downto 0);
	score						: out std_logic_vector(3 downto 0);
	);
end entity display;

architecture behaviour of game_state is



end behaviour;