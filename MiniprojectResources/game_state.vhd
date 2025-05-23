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
	obj_on					: in std_logic_vetor(9 downto 0);
	
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
signal s_mode					: std_logic_vector(1 downto 0) := "00"c;
signal s_score, lives 		: integer;

begin
	
	--clock rising edge
	
		--switch case main menu state
			-- switch case
				-- training when DIP = 1
				-- normal when DIP = 0
			--if rising edge start = 1
				--state = gameplay
				
		--case gameplay
			-- if pause = 1
				--change state to paused
			--if collision
				--if life = 1
					--state = game_over
				-- minus life
				-- 
			--if pipe pass
				--score++
				
		--case pause
			-- rising edge pause
				--state = gameplay
			
		--case game_over
			--rising edge start
				--state = main menu
			--rising edge pause
				--set state to gameplay

end behaviour;