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
	
	--Inputs from System
	p_row, p_col					: in std_logic_vector(9 DOWNTO 0);
	v_sync							: in std_logic;
	
	--Outputs to System
	state								: out std_logic_vector(1 downto 0) := "00";
	char_on, bird_on, pipe_on, inv_on	: out std_logic := '0';
	
	Clk								: in std_logic
	);
end entity game_logic;

architecture behaviour of game_logic is

--Game state signals
signal s_state, s_mode				: std_logic_vector(1 downto 0) := "00";
--Input management signals=
signal start_prev, pause_prev	 	: std_logic := '0';
signal start_pulse, pause_pulse	: std_logic;

-- General component reset on game start
signal reset : std_logic := '0';

--Component Signals
signal ground							: std_logic := '0';
signal mouse_x, mouse_y				: std_logic_vector(9 DOWNTO 0) := "0000000000"; 
signal mouse_right, mouse_left	: std_logic;
signal s_bird_on, s_pipe_on 		: std_logic;

-- LIFE / COLLISIONS
signal life_on: std_logic;
signal zero_life: std_logic;

signal collision : std_logic;
signal collision_detected: std_logic;
signal reset_collisions : std_logic;

signal invincible: std_logic;

signal state_text_on : std_logic;

signal score_on: std_logic;
signal increase1: std_logic;
signal score_on2: std_logic;
signal increase2: std_logic;

signal pipe_enable: std_logic := '0';

signal score_ten_count: std_logic_vector(3 downto 0);

--Signal Components

component score IS
	PORT
		( clk, increase_score	: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  score_on, carry				: out std_logic);		
END component score;

component score_digit_2 IS
	PORT
		( clk, increase_score	: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  score_ten_count : out std_logic_vector(3 downto 0);
		  score_on			: out std_logic);		
END component score_digit_2;

component life is 
	PORT
		( clk, decrease_life, reset: IN std_logic;
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
        vert_sync    : in  std_logic;  
        start  : in  std_logic;
        invincibity, inv_on : out std_logic 
    );
end component invincibity_timer;

component text IS
	PORT
		( clk								: IN std_logic;
		  state							: in std_logic_vector(1 downto 0);
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  char_on						: out std_logic);		
END component text;

--object components

component Pipe_Controller is
	port(Clk, vert_sync, enable, reset		: in std_logic;
		state, mode				: in std_logic_vector(1 downto 0); 
		pixel_row, pixel_col	: in std_logic_vector(9 downto 0);
		pipe_on, increase		: out std_logic
		
	);
end component Pipe_Controller;

component bird_controller IS
	PORT
		( clk, vert_sync, mouse_click	: IN std_logic;
		  state								: IN std_logic_vector(1 DOWNTO 0);
		  pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  bird_on 							: OUT std_logic);		
END component bird_controller;

component MOUSE IS
   PORT( clock_25Mhz, reset	 		: IN std_logic;
         mouse_data						: INOUT std_logic;
         mouse_clk 						: INOUT std_logic;
         left_button, right_button	: OUT std_logic;
		 mouse_cursor_row 				: OUT std_logic_vector(9 DOWNTO 0); 
		 mouse_cursor_column 			: OUT std_logic_vector(9 DOWNTO 0));       	
END component MOUSE;

begin
	--Signal assignments
	state <= s_state;
	
	LEDR(1 DOWNTO 0) <= s_state;
	LEDR(3 DOWNTO 2) <= s_mode;

	--Edge detection and pulse generation
	process(clk)
	begin 
		if rising_edge(clk) then
			start_prev <= PB(0);
			pause_prev <= PB(1);
		end if;
	end process;
	
	start_pulse <= '1' when (PB(0) = '0' and start_prev = '1') else '0';
	pause_pulse <= '1' when (PB(1) = '0' and pause_prev = '1') else '0';
	
	--Components
	
	score_display: score port map(
		clk				=> clk,
		increase_score => increase1,
		pixel_row 		=> p_row,
		pixel_column	=> p_col,
		score_on			=> score_on,
		carry => increase2
	);
	
	score_display2: score_digit_2 port map(
		clk				=> clk,
		increase_score => increase2,
		score_ten_count => score_ten_count,
		pixel_row 		=> p_row,
		pixel_column	=> p_col,
		score_on			=> score_on2
	);
	state_text: text port map(
		clk				=> clk,	
		state => s_state,
		pixel_row 		=> p_row,
		pixel_column	=> p_col,
		char_on			=> state_text_on
	);
	
	Bird : Bird_controller port map(
		Clk => clk,
		vert_sync => v_sync,
		state => s_state,
		pixel_column => p_col,
		pixel_row => p_row,
		mouse_click => mouse_left,
		bird_on => s_bird_on
	);
	
	pipe : Pipe_Controller port map(
		clk => clk,
		vert_sync => v_sync,
		enable => pipe_enable,
		reset => reset,
		state => s_state,
		mode => s_mode,
		pixel_row => p_row,
		pixel_col => p_col,
		pipe_on => s_pipe_on,
		increase => increase1
	);
	
	Mouse1: Mouse port map(
		clock_25Mhz => clk,
		reset => ground,
		mouse_data => PS2_DAT,
		mouse_clk => PS2_CLK,
		left_button => mouse_left, 
		right_button => mouse_right,
		mouse_cursor_row => mouse_x,
		mouse_cursor_column => mouse_y
	);
	
	
	
	
	timer1: invincibity_timer port map(
		vert_sync => v_sync,
		start => collision_detected,
		invincibity => invincible,
		inv_on => inv_on
	);

	collision_detector: collision_controller port map(
		clk				=> clk,
		collision 		=> collision,
		collision_detected 	=> collision_detected,
		reset						=> reset_collisions
	);
	
	life_display: life port map(
		clk				=> clk,
		reset				=> reset,
		decrease_life	=> collision_detected,
		pixel_row 		=> p_row,
		pixel_column	=> p_col,
		life_on			=>	life_on,
		zero_life		=> zero_life
	);
	
	collision <= (s_bird_on and s_pipe_on);
	
	reset_collisions <= not invincible;
	
	
	--State controller
	process(clk)
	begin
		if (rising_edge(clk)) then
			case s_state is
			
				when "00" => -- Main Menu
					case SW(0) is
						when '1' => s_mode <= "00";
                  when '0' => s_mode <= "01";
					end case; 

                if (start_pulse = '1') then
                    s_state <= "01"; -- go to gameplay
						  pipe_enable <= '1';
                end if;
                
            when "01" => -- Gameplay
					reset <= '0';
					
					if (s_mode = "01") then
						if (score_ten_count = "0001") then
							s_mode <= "10";
						elsif (score_ten_count = "0010") then
							s_mode <= "11";
						end if;
					end if;
					
					if (pause_pulse = '1') then
                    s_state <= "10"; -- go to pause
               end if;
					 
					if (zero_life = '1') then -- game_over
						s_state <= "11";
						pipe_enable <= '0';
					end if;
                
            when "10" => -- Paused
                if (pause_pulse = '1') then
                    s_state <= "01"; -- go back to pause
                end if;
                
            when "11" => -- Game_over
                if (start_pulse = '1') then
                    s_state <= "00"; -- go to main menu
						  reset <= '1';
                end if;
					 
			  end case;
		 end if;
	end process;
	
	-- Display outputs
	char_on <= state_text_on or life_on or score_on or score_on2;
	
	pipe_on <= s_pipe_on;
	bird_on <= s_bird_on;
	
end behaviour;