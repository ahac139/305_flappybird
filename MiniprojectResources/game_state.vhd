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
	pixel_row, pixel_col	: in std_logic_vector(9 downto 0);
	
	--Outputs to Board
	hex0, hex1, hex2 		: out std_logic_vector(6 downto 0);
	LEDR						: out std_logic_vector(9 downto 0) := "0000000000";
	
	--Outputs to System
	state, mode, lives	: out std_logic_vector(1 downto 0);
	score						: out std_logic_vector(3 downto 0);
	);
end entity game_state;

architecture behaviour of game_state is

--Components
	--Bird
		--state in
		--row, col in
		-- bird_n out
		
	--Pipe
		--state in
		--mode in
		--row, col in
		--pipe_on out

--Gameplay signals
signal s_state					: std_logic_vector(1 downto 0) := "00";
signal s_mode					: std_logic_vector(1 downto 0) := "00";
signal s_score, lives 		: integer := 0;
signal collision				: std_logic;

--Input signals
signal start_prev, pause_prev	 	: std_logic := "0";
signal start_pulse, pause_pulse	: std_logic;

begin
	
	--Signal assignment
	collision <= bird_on and pipe_on;

	--Edge detection and pulse generation
	process(clk)
	begin 
		if rising_edge(clk) then
			start_prev <= pb1;
			pause_prev <= pb2;
		end if;
	end process;
	
	start_pulse <= '1' when (pb1 = '1' and start_prev = '0') else '0';
	pause_pulse <= '1' when (pb2 = '1' and pause_prev = '0') else '0';
	
	
	--State controller
	process(clk)
	begin
	if (rising_edge(clk)) then
		case s_state is
		
			when "00" =>-- Main Menu
			
			case SW(0) is
				when '1' => s_mode <= "00";
				when '0' => s_mode <= "01";
				
			if (start_pulse = '1') then
				s_state <= "01";
			end if;
			
				
			when "01" =>-- Gameplay
			if (pause_pulse = '0') then
				s_state <= "10";
			elsif (collision = '1') then --Currently will take more than one life per pipe
				if (lives = 1) then
					s_state = "11";
				end if;
				lives = lives - 1;
			end if;
			
			--if N_clear
				-- if H_clear
						--mode <= "11"
				-- else
					--mode <= "10"
			
			when "10" =>-- Paused
			if (pause_pulse = '1') then
				s_state <= "01";
			end if;
			
			
			when "11" =>-- Game_over
			if (start_pulse = '1') then
				s_state <= "00";
			end if;
			

end behaviour;