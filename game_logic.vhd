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
	char_on, bird_on, pipe_on	: out std_logic := '0';
	
	Clk								: in std_logic
	);
end entity game_logic;

architecture behaviour of game_logic is

--Game state signals
signal s_state, s_mode				: std_logic_vector(1 downto 0) := "00";
--Input management signals
signal start_prev, pause_prev	 	: std_logic := '0';
signal start_pulse, pause_pulse	: std_logic;

--Component Signals
signal ground							: std_logic := '0';
signal mouse_x, mouse_y				: std_logic_vector(9 DOWNTO 0) := "0000000000"; 
signal mouse_right, mouse_left	: std_logic;

--Components
component text IS
	PORT
		( clk								: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  char_on						: out std_logic);		
END component text;

component bird_controller IS
	PORT
		( clk, vert_sync, mouse_click	: IN std_logic;
		  pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  -- state/mode after restructure
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
	char_display: text port map(
		clk				=> clk,				
		pixel_row 		=> p_row,
		pixel_column	=> p_col,
		char_on			=> char_on
	);
	
	Bird : Bird_controller port map(
		Clk => clk,
		vert_sync => v_sync,
		pixel_column => p_col,
		pixel_row => p_row,
		mouse_click => mouse_left,
		bird_on => bird_on
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
                    s_state <= "01";
                end if;
                
            when "01" => -- Gameplay
                if (pause_pulse = '0') then
                    s_state <= "10";
                end if;
                
            when "10" => -- Paused
                if (pause_pulse = '1') then
                    s_state <= "01";
                end if;
                
            when "11" => -- Game_over
                if (start_pulse = '1') then
                    s_state <= "00";
                end if;
					 
        end case;
    end if;
end process;
end behaviour;