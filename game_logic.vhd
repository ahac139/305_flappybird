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
	
	--Outputs to System
	state								: out std_logic_vector(1 downto 0) := "00";
	char_on, bird_on, pipe_on	: out std_logic := '0';
	
	Clk								: in std_logic
	);
end entity game_logic;

architecture behaviour of game_logic is

--Game state signals
signal s_state, s_mode			: std_logic_vector(1 downto 0) := "00";

--Input management signals
signal start_prev, pause_prev	 	: std_logic := '0';
signal start_pulse, pause_pulse	: std_logic;


begin
	--Signal assignments
	state <= s_state;

	--Edge detection and pulse generation
	process(clk)
	begin 
		if rising_edge(clk) then
			start_prev <= PB(0);
			pause_prev <= PB(1);
		end if;
	end process;
	
	start_pulse <= '1' when (PB(0) = '1' and start_prev = '0') else '0';
	pause_pulse <= '1' when (PB(1) = '1' and pause_prev = '0') else '0';
	
	
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