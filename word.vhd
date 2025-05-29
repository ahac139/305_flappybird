LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity word is
	port(Clk						: in std_logic;
	
	--Inputs from Sytem
	pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
	
	--Outputs to System
	char_on						: out std_logic
	);
end entity word;



architecture behavior of word is

--Signals for character 1
SIGNAL size_2 					: std_logic_vector(9 DOWNTO 0) := "0000001111";  
SIGNAL y_pos_1					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_1					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SIGNAL char_H					: std_logic_vector(5 downto 0) := "001000";
SIGNAL char_H_on				: std_logic;

component char_rom IS
	PORT
	(
		character_address		:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock						: 	IN STD_LOGIC ;
		rom_mux_output			:	OUT STD_LOGIC
	);
END component;

BEGIN

--Component for character 1
H : char_rom port map(
		character_address => char_H,
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => char_H_on);
		
		
char_on <= 	'1'	when ( ('0' & x_pos_1 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_1 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_1 <= pixel_row ) and ('0' & pixel_row <= y_pos_1 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_H_on = '1')) else
				'0';


END behavior;

