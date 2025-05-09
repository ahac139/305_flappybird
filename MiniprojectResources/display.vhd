library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
	port(Clk, pb1, pb2 : in std_logic;
	VGA_R, VGA_G, VGA_B : out std_logic_vector(3 downto 0) := "0000";
	hex0, hex1, hex2 : out std_logic_vector(6 downto 0);
	SW : in std_logic_vector(9 downto 0);
	VGA_HS, vert_sync: out std_logic;
	PS2_DAT, PS2_CLK : inout std_logic;
	LEDR: out std_logic_vector(9 downto 0) := "0000000000";
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
          pixel_row, pixel_column, mouse_x, mouse_y	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END component bouncy_ball;

component MOUSE IS
   PORT( clock_25Mhz, reset 		: IN std_logic;
         mouse_data					: INOUT std_logic;
         mouse_clk 					: INOUT std_logic;
         left_button, right_button	: OUT std_logic;
		 mouse_cursor_row 			: OUT std_logic_vector(9 DOWNTO 0); 
		 mouse_cursor_column 		: OUT std_logic_vector(9 DOWNTO 0));       	
END component MOUSE;

component seven_seg_display is
     port (binary_in : in std_logic_vector(7 downto 0);
			  hex0, hex1, hex2 : out std_logic_vector(6 downto 0));
end component;

signal pixel_row : std_logic_vector(9 downto 0);
signal pixel_column : std_logic_vector(9 downto 0);
signal clk_div : std_logic;

signal seven_seg_input : std_logic_vector(9 downto 0) := "0000000001";

signal v_sync_i : std_logic;

signal red : std_logic;

signal green : std_logic;

signal blue : std_logic;

signal ground : std_logic := '0';

signal R1: std_logic;

signal mouse_cursor_row: std_logic_vector(9 DOWNTO 0); 
signal mouse_cursor_column:std_logic_vector(9 DOWNTO 0);

signal mouse_x: std_logic_vector(9 DOWNTO 0) := "0000000000"; 
signal mouse_y:std_logic_vector(9 DOWNTO 0) := "0000000000";

signal mouse_right: std_logic;

signal switches: std_logic_vector(7 DOWNTO 0); 


begin
	
	seg_display: seven_seg_display port map(
		binary_in => switches,
		hex0 => hex0, 
		hex1 => hex1, 
		hex2 => hex2);
	
	Mouse1: Mouse port map(
				clock_25Mhz => clk_div,
				reset => ground,
				mouse_data => PS2_DAT,
				mouse_clk => PS2_CLK,
				left_button => blue, 
				right_button => mouse_right,
				mouse_cursor_row => mouse_cursor_row,
				mouse_cursor_column => mouse_cursor_column);
				
			
	mouse_x <= mouse_cursor_column;
	mouse_y <= mouse_cursor_row;
	
	
	LEDR <= SW;
	switches <= SW(7 downto 0);
	
	BBALL : bouncy_ball port map(
		pb1 => pb1,
		pb2 => pb2,
		clk => clk_div,
		pixel_row => pixel_row,
		pixel_column => pixel_column,
		mouse_x => mouse_x,
		mouse_y => mouse_y,
		vert_sync => v_sync_i,
		red => red,
		green => green,
		blue => R1
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