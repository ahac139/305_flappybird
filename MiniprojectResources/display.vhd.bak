library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
	port(Clk, pb1, pb2 : in std_logic;
	VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0) := "0000";
	VGA_HS, vert_sync : out std_logic;
	GPIO_0 : out std_logic_vector(35 downto 0)
	);
end entity display;


architecture behaviour of display is 

component VGA_SYNC IS
	PORT(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END component VGA_SYNC;

component clock_divider is
	port(Clk : in std_logic;
	Clk_out : out std_logic);
end component clock_divider;

component bouncy_ball IS
	PORT
		( pb1, pb2, clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END component bouncy_ball;




signal pixel_row : std_logic_vector(9 downto 0);
signal pixel_column : std_logic_vector(9 downto 0);
signal clk_div : std_logic;

signal v_sync_i : std_logic;

signal red : std_logic;

signal green : std_logic;

signal blue : std_logic;


begin

	BBALL : bouncy_ball port map(
		pb1 => pb1,
		pb2 => pb2,
		clk => clk_div,
		pixel_row => pixel_row,
		pixel_column => pixel_column,
		vert_sync => v_sync_i,
		red => red,
		green => green,
		blue => blue
	);
	
	CDIV : clock_divider port map(
		clk => Clk,
		clk_out => clk_div
	);
	GPIO_0(0) <=  clk_div;
	VGA : VGA_SYNC port map(
		clock_25Mhz => clk_div,
		red => red,
		green => green,
		blue => blue,
		red_out => VGA_R(3),
		green_out => VGA_G(3),
		blue_out => VGA_B(3),
		horiz_sync_out => VGA_HS,
		vert_sync_out => v_sync_i,
		pixel_row => pixel_row,
		pixel_column => pixel_column
	);
	
	vert_sync <= v_sync_i;


end behaviour;