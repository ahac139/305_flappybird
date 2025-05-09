library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity text is 
	port(clk: in std_logic;
		  VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0) := "0000";
		  VGA_HS, VGA_VS: out std_logic
		  );
end entity text;

architecture behaviour of text is 

component VGA_SYNC IS
	PORT(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END component VGA_SYNC;

component clock_divider is
	port(Clk : in std_logic;
	Clk_out : out std_logic);
end component clock_divider;

component char_rom IS
	PORT
	(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
END component char_rom;

signal clk_div: std_logic;
signal char_rom_out: std_logic; 
signal ground: std_logic := '0';

signal pixel_row: std_logic_vector(9 downto 0);
signal pixel_column: std_logic_vector(9 downto 0);


begin
	
	Clk1: clock_divider
			port map(clk => clk,
					   clk_out => clk_div);
						
	VGA_SYNC1: VGA_SYNC
			port map(clock_25Mhz => clk_div,
					   red => char_rom_out,
						green => char_rom_out,
						blue => ground,
						red_out => VGA_R(3),
						green_out => VGA_G(3),
						blue_out => VGA_B(3),
						horiz_sync_out => VGA_HS,
						vert_sync_out => VGA_VS,
						pixel_row => pixel_row,
						pixel_column => pixel_column
						);
						
						
	char_rom1: char_rom
			port map(character_address => pixel_row(9 downto 4),
					   font_row => pixel_row(3 downto 1),
						font_col => pixel_column(3 downto 1),
						clock => clk_div,
						rom_mux_output => char_rom_out);
end architecture behaviour;