library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
	port(Clk, pb1, pb2	: in std_logic;
	VGA_R, VGA_G, VGA_B 	: out std_logic_vector(3 downto 0) := "0000";
	hex0, hex1, hex2 		: out std_logic_vector(6 downto 0);
	SW 						: in std_logic_vector(9 downto 0);
	VGA_HS, vert_sync		: out std_logic;
	PS2_DAT, PS2_CLK 		: inout std_logic;
	LEDR						: out std_logic_vector(9 downto 0) := "0000000000";
	GPIO_0 					: out std_logic_vector(35 downto 0)
	);
end entity display;


architecture behaviour of display is 

component VGA_SYNC IS
	PORT(	clock_25Mhz, red, green, blue											: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			pixel_row, pixel_column													: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END component VGA_SYNC;

component clock_divider is
	port(Clk : in std_logic;
	Clk_out 	: out std_logic);
end component clock_divider;

component MOUSE IS
   PORT( clock_25Mhz, reset	 		: IN std_logic;
         mouse_data						: INOUT std_logic;
         mouse_clk 						: INOUT std_logic;
         left_button, right_button	: OUT std_logic;
		 mouse_cursor_row 				: OUT std_logic_vector(9 DOWNTO 0); 
		 mouse_cursor_column 			: OUT std_logic_vector(9 DOWNTO 0));       	
END component MOUSE;

component seven_seg_display is
     port (binary_in			 : in std_logic_vector(7 downto 0);
			  hex0, hex1, hex2 : out std_logic_vector(6 downto 0));
end component;

component text IS
	PORT
		( clk								: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  char_on						: out std_logic);		
END component text;

component Pipe_Controller is
	port(Clk, vert_sync, pu_collected: in std_logic;
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		pipe_x_motion: in unsigned(9 downto 0);
		pipe_on, increase, power_up_on: out std_logic
	);
end component Pipe_Controller;

component bird_controller IS
	PORT
		( clk, vert_sync, mouse_click	: IN std_logic;
		  pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  -- state/mode after restructure
		  bird_on 							: OUT std_logic);		
END component bird_controller;

component score IS
	PORT
		( clk, increase_score		: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  score_on, carry				: out std_logic);		
END component score;

component score_digit_2 IS
	PORT
		( clk, increase_score	: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  score_on			: out std_logic);		
END component score_digit_2;

component life is 
	PORT
		( clk, decrease_life, increase_life : IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  life_on, zero_life		   : OUT std_logic);	
end component life;

component collision_controller IS
    PORT (
        clk, reset : IN std_logic;
        collision	    : IN std_logic; 
        collision_detected : OUT std_logic  
    );		
END component collision_controller;

component invincibity_timer is
    port (
        clk, vert_sync    : in  std_logic;  -- 25 Hz clock input
        start  : in  std_logic;  -- start counting pulse (one clock cycle)
        invincibity, inv_on : out std_logic   -- goes high after 3 seconds
    );
end component invincibity_timer;

signal pixel_row 		: std_logic_vector(9 downto 0);
signal pixel_column 	: std_logic_vector(9 downto 0);

signal clk_div			: std_logic;

signal seven_seg_input : std_logic_vector(9 downto 0) := "0000000001";

signal v_sync_i 		: std_logic;

signal red 				: std_logic;
signal green 			: std_logic;
signal blue 			: std_logic;

signal ground			: std_logic := '0';

signal R1				: std_logic;

signal mouse_cursor_row		: std_logic_vector(9 DOWNTO 0); 
signal mouse_cursor_column	: std_logic_vector(9 DOWNTO 0);

signal mouse_x			: std_logic_vector(9 DOWNTO 0) := "0000000000"; 
signal mouse_y			: std_logic_vector(9 DOWNTO 0) := "0000000000";

signal mouse_right	: std_logic;
signal mouse_left 	: std_logic;

signal switches		: std_logic_vector(7 DOWNTO 0); 

signal power_up_on	: std_logic;
signal char_on 		: std_logic;
signal bird_on 		: std_logic; 
signal pipe_on 		: std_logic; 
signal pipe_x_motion : unsigned(9 downto 0) := to_unsigned(1,10);

signal collision : std_logic;

signal score_on: std_logic;

signal increase1: std_logic;

signal score_on2: std_logic;

signal increase2: std_logic;

signal invincible: std_logic;

-- Life signals
signal collision_detected: std_logic;
signal life_on: std_logic;
signal zero_life: std_logic;
signal prev_collision: std_logic;
signal reset_collisions : std_logic;
signal inv_on :std_logic;

signal pu_collected : std_logic;
begin

	timer1: invincibity_timer port map(
		clk => clk_div,
		vert_sync => v_sync_i,
		start => collision_detected,
		invincibity => invincible,
		inv_on => inv_on
	);

	collision_detector: collision_controller port map(
		clk				=> clk_div,
		collision 		=> collision,
		collision_detected 	=> collision_detected,
		reset						=> reset_collisions
	);
	
	life_display: life port map(
		clk				=> clk_div,
		decrease_life	=> collision_detected,
		increase_life  => pu_collected,
		pixel_row 		=> pixel_row,
		pixel_column	=> pixel_column,
		life_on			=>	life_on,
		zero_life		=> zero_life
	);
	
	collision <= (bird_on and pipe_on);
	
	reset_collisions <= not invincible;
		
	pu_collected <= power_up_on and bird_on;
								
	score_display: score port map(
		clk				=> clk_div,
		increase_score => increase1,
		pixel_row 		=> pixel_row,
		pixel_column	=> pixel_column,
		score_on			=> score_on,
		carry => increase2
	);
	
	score_display2: score_digit_2 port map(
		clk				=> clk_div,
		increase_score => increase2,
		pixel_row 		=> pixel_row,
		pixel_column	=> pixel_column,
		score_on			=> score_on2
	);

	char_display: text port map(
		clk				=> clk_div,				
		pixel_row 		=> pixel_row,
		pixel_column	=> pixel_column,
		char_on			=> char_on
	);
	
	seg_display: seven_seg_display port map(
		binary_in => switches,
		hex0 => hex0, 
		hex1 => hex1, 
		hex2 => hex2
	);
	
	Pipes : Pipe_controller port map(
		Clk => clk_div,
		vert_sync => v_sync_i,
		pixel_col => pixel_column,
		pixel_row => pixel_row,
		pipe_x_motion => pipe_x_motion,
		pipe_on => pipe_on,
		increase => increase1,
		power_up_on => power_up_on,
		pu_collected => pu_collected
	);
	
	Bird : Bird_controller port map(
		Clk => clk_div,
		vert_sync => v_sync_i,
		pixel_column => pixel_column,
		pixel_row => pixel_row,
		
		mouse_click => mouse_left,
		bird_on => bird_on
	);
		
	
	Mouse1: Mouse port map(
		clock_25Mhz => clk_div,
		reset => ground,
		mouse_data => PS2_DAT,
		mouse_clk => PS2_CLK,
		left_button => mouse_left, 
		right_button => mouse_right,
		mouse_cursor_row => mouse_cursor_row,
		mouse_cursor_column => mouse_cursor_column
	);
				
			
	mouse_x <= mouse_cursor_column;
	mouse_y <= mouse_cursor_row;
	
	
	LEDR <= SW;
	switches <= SW(7 downto 0);
	

	Red 	<= '1' when (char_on = '1') else
				'1' when (bird_on = '1') else
				'1' when (score_on = '1') else
				'1' when (score_on2 = '1') else
				'1' when (life_on = '1') else
				'0';
	Green <= '1' when (char_on = '1') else
				'1' when (bird_on = '1') and (inv_on = '1') else
				'1' when (pipe_on = '1') else
				'1' when (score_on = '1') else
				'1' when (score_on2 = '1') else
				'0';
	Blue 	<= '1' when (char_on = '1') else
				'1' when (bird_on = '1') and (inv_on = '1') else
				'1' when (score_on = '1') else
				'1' when (score_on2 = '1') else
				'1' when (power_up_on = '1') else
				'0';
	
	
	
	
	
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