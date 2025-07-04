LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

entity pause_text is
	port(Clk						: in std_logic;
	
	--Inputs from Sytem
	pixel_row, pixel_column	: in std_logic_vector(9 downto 0);
	
	--Outputs to System
	char_on						: out std_logic
	);
end entity pause_text;


architecture behavior of pause_text is

--CONSTANTS (CHANGE INTEGER VALUES BY MULTIPLES OF 8 BY CHANGING INTEGER ON THE RIGHT)
SIGNAL x_pos 	: integer := 8*4; -- CURRENTLY 4 out of 80 (POSITION SHOULD BE A MUTIPLE OF SIZE E.G. 2, 4 ...)
SIGNAL y_pos	: integer := 8*4; -- CURRENTLY 4 out of 60
SIGNAL size		: integer := 8*2; -- each character is SIZE*8 by SIZE*8 (check font_row/font_col assignment matches)

--LOGIC SIGNALS
SIGNAL s_x_1, s_y, s_size			: std_logic_vector(9 DOWNTO 0); 
SIGNAL s_x_2, s_x_3, s_x_4, s_x_5, s_x_6, s_x_7 : std_logic_vector(9 DOWNTO 0); --MAKE SURE THERE ARE N+1 s_x_n
SIGNAL in_y_range 					: std_logic := '0';

--Char address signals
SIGNAL active_char 		: std_logic_vector(5 downto 0) := "100000";
SIGNAL char_space 		: std_logic_vector(5 downto 0) := "100000";

SIGNAL char_A				: std_logic_vector(5 downto 0) := "000001";
SIGNAL char_D				: std_logic_vector(5 downto 0) := "000100";
SIGNAL char_E				: std_logic_vector(5 downto 0) := "000101";
SIGNAL char_P				: std_logic_vector(5 downto 0) := "010000";
SIGNAL char_S				: std_logic_vector(5 downto 0) := "010011";
SIGNAL char_U				: std_logic_vector(5 downto 0) := "010101";


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
	
	--Signal assignments
	s_y	 	<= std_logic_vector(to_unsigned(y_pos, 10));
	s_size 	<= std_logic_vector(to_unsigned(size, 10));
	
	s_x_1		<= std_logic_vector(to_unsigned(x_pos, 10));
	s_x_2		<= s_x_1 + s_size;
	s_x_3		<= s_x_2 + s_size;
	s_x_4		<= s_x_3 + s_size;
	s_x_5		<= s_x_4 + s_size;
	s_x_6		<= s_x_5 + s_size;
	s_x_7		<= s_x_6 + s_size;
	
	--Assign active char depending on pixel_row and pixel_column (active char will go to space when out of range)
	in_y_range <= '1' when (s_y < pixel_row ) and (pixel_row < s_y + s_size) else '0';
	
	active_char <= char_P when ((s_x_1 < pixel_column ) and (pixel_column < s_x_2) and (in_y_range = '1')) else
						char_A when ((s_x_2 < pixel_column ) and (pixel_column < s_x_3) and (in_y_range = '1')) else
						char_U when ((s_x_3 < pixel_column ) and (pixel_column < s_x_4) and (in_y_range = '1')) else
						char_S when ((s_x_4 < pixel_column ) and (pixel_column < s_x_5) and (in_y_range = '1')) else
						char_E when ((s_x_5 < pixel_column ) and (pixel_column < s_x_6) and (in_y_range = '1')) else
						char_D when ((s_x_6 < pixel_column ) and (pixel_column < s_x_7) and (in_y_range = '1')) else
						char_space;

	PAUSE_CHAR_ROM : char_rom port map(
		character_address 	=> active_char,
		font_row 				=> pixel_row(3 downto 1),
		font_col 				=> pixel_column(3 downto 1),
		clock 					=> clk,
		rom_mux_output 		=> char_on);

END behavior;

