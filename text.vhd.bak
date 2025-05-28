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

--Signals for character 1
SIGNAL size_2 					: std_logic_vector(9 DOWNTO 0) := "0000001111";  
SIGNAL y_pos_1					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_1					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SIGNAL char_H					: std_logic_vector(5 downto 0) := "001000";
SIGNAL char_H_on				: std_logic;

--Signals for character 2
SIGNAL y_pos_2					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_2					: std_logic_vector(9 DOWNTO 0) := "0010010000";
SIGNAL char_E					: std_logic_vector(5 downto 0) := "000101";
SIGNAL char_E_on				: std_logic;

--Signals for character 3
SIGNAL y_pos_3					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_3					: std_logic_vector(9 DOWNTO 0) := "0010100000";
SIGNAL char_L					: std_logic_vector(5 downto 0) := "001100";
SIGNAL char_L_on				: std_logic;

--Signals for character 4
SIGNAL y_pos_4					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_4					: std_logic_vector(9 DOWNTO 0) := "0010110000";
SIGNAL char_L_on_2			: std_logic;

--Signals for character 5
SIGNAL y_pos_5					: std_logic_vector(9 DOWNTO 0) := "0010000000";
SiGNAL x_pos_5					: std_logic_vector(9 DOWNTO 0) := "0011000000";
SIGNAL char_O					: std_logic_vector(5 downto 0) := "001111";
SIGNAL char_O_on				: std_logic;

--Signals for character 6
SIGNAL size_4 					: std_logic_vector(9 DOWNTO 0) := "0000111111";  
SIGNAL y_pos_6					: std_logic_vector(9 DOWNTO 0) := "0100000000";
SiGNAL x_pos_6					: std_logic_vector(9 DOWNTO 0) := "0100000000";
SIGNAL char_EX					: std_logic_vector(5 downto 0) := "100001";
SIGNAL char_EX_on				: std_logic;

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
		
--Component for char 2
E : char_rom port map(
		character_address => char_E,
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => char_E_on);
		
L1 : char_rom port map(
		character_address => char_L,
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => char_L_on);
		
L2 : char_rom port map(
		character_address => char_L,
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => char_L_on_2);
		
O : char_rom port map(
		character_address => char_O,
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => char_O_on);
		
EX : char_rom port map(
		character_address => char_EX,
		font_row => pixel_row(5 downto 3),
		font_col => pixel_column(5 downto 3),
		clock => clk,
		rom_mux_output => char_EX_on);
		
		
		
char_on <= 	'1'	when ( ('0' & x_pos_1 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_1 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_1 <= pixel_row ) and ('0' & pixel_row <= y_pos_1 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_H_on = '1')) else
						
				'1'	when ( ('0' & x_pos_2 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_2 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_2 <= pixel_row ) and ('0' & pixel_row <= y_pos_2 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_E_on = '1')) else
						
				'1'	when ( ('0' & x_pos_3 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_3 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_3 <= pixel_row ) and ('0' & pixel_row <= y_pos_3 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_L_on = '1')) else
						
				'1'	when ( ('0' & x_pos_4 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_4 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_4 <= pixel_row ) and ('0' & pixel_row <= y_pos_4 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_L_on_2 = '1')) else
						
				'1'	when ( ('0' & x_pos_5 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_5 + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_5 <= pixel_row ) and ('0' & pixel_row <= y_pos_5 + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_O_on = '1')) else
						
				'1'	when ( ('0' & x_pos_6 <= '0' & pixel_column) and ('0' & pixel_column <= '0' & x_pos_6 + size_4) 	-- x_pos - size <= pixel_column <= x_pos + size
						and ('0' & y_pos_6 <= pixel_row ) and ('0' & pixel_row <= y_pos_6 + size_4)	-- y_pos - size <= pixel_row <= y_pos + size
						and (char_EX_on = '1')) else
				'0';


END behavior;

