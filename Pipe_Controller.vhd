library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Pipe_Controller is
	port(Clk, vert_sync, enable, reset, pu_collected: in std_logic;
		state, mode: in std_logic_vector(1 downto 0); 
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		pipe_on, increase, power_up_on: out std_logic
	);
end entity Pipe_Controller;

architecture behaviour of Pipe_Controller is

	component Pipes is
		port(
			clk, vert_sync, enable, reset, power_up_enable, pu_collected: in std_logic;
			pixel_row, pixel_col: in std_logic_vector(9 downto 0);
			pipe_x_motion: unsigned(9 downto 0);
			random_number: in unsigned(9 downto 0);
			pipe_on, increase, power_up_on: out std_logic
		);
	end component Pipes;
		
	component random_number_generator is
    port (
        clk : in std_logic;
        random_number : out unsigned(9 downto 0)
    );
	end component;
	
	
	
	signal pipe_x_motion: unsigned(9 downto 0);
	signal gap: unsigned(9 downto 0);
	
	signal pipe_on1 : std_logic;
	signal pipe_on2 : std_logic;
	signal pipe_on3 : std_logic;
	signal enable1 : std_logic := '0';
	signal enable2 : std_logic := '0';
	signal enable3 : std_logic := '0';
	signal increase1 : std_logic := '0';
	signal increase2 : std_logic := '0';
	signal increase3 : std_logic := '0';

	signal power_up_on1, power_up_on2, power_up_on3 : std_logic;

	signal power_up_enable, s_power_up_on, pu_onscreen_flag : std_logic := '0'; 
	signal stored_random_number : unsigned(9 downto 0);
	signal prev_vert_sync : std_logic := '0';
	
	begin
		
		
		P0: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable1,
			reset => reset,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on =>pipe_on1,
			increase => increase1,
			power_up_on => power_up_on1,
			power_up_enable => power_up_enable,
			pu_collected => pu_collected);
			
		P1: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable2,
			reset => reset,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on =>pipe_on2,
			increase => increase2,
			power_up_on => power_up_on2,
			power_up_enable => power_up_enable,
			pu_collected => pu_collected);

		P2: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable3,
			reset => reset,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on => pipe_on3,
			increase => increase3,
			power_up_on => power_up_on3,
			power_up_enable => power_up_enable,
			pu_collected => pu_collected);
			
		RNG: random_number_generator port map(
				clk => vert_sync,
				random_number => gap);
							  
		process(clk) 
		begin
			if(rising_edge(clk)) then
				if (state = "01") then
					case mode is
						when "00" => pipe_x_motion <= to_unsigned(1,10);
						when "01" => pipe_x_motion <= to_unsigned(1,10);
						when "10" => pipe_x_motion <= to_unsigned(3,10);
						when "11" => pipe_x_motion <= to_unsigned(6,10);
					end case;
				else
					pipe_x_motion <= to_unsigned(0,10);
				end if;
			end if;
		end process;
		
		pipe_on <= '1' when ((pipe_on1 = '1') or (pipe_on2 = '1') or (pipe_on3 = '1')) 
									and ((state = "01") or (state = "10")) 
									else '0';
		increase <= increase1 or increase2 or increase3;
		
		s_power_up_on <= power_up_on1 or power_up_on2 or power_up_on3;
		power_up_on <= s_power_up_on;
		
		process(vert_sync)
		variable count  : integer range 0 to 500 := 0;
		variable pu_count  : integer range 0 to 400 := 0;
		begin
		
		if rising_edge(vert_sync) then
			if (reset = '1') or (enable = '0') then 
				count := 0;
				enable1 <= '0';
				enable2 <= '0';
				enable3 <= '0';
			end if;
			
			if (enable = '1') then
				
				enable1 <= '1';
			
				if count = 233 then
					enable2 <= '1';
					count := count + 1;
					
				elsif count = 466 then
					enable3 <= '1';
					count := 466;
				else
					count := count + 1;
				end if;
			end if;

			if (pu_onscreen_flag = '1') then
				power_up_enable <= '0';
				
				stored_random_number <= gap;
			else
			-- if no other powerup onscreen, wait random interval and spawn one
				pu_count := pu_count + 1;
				if (to_unsigned(pu_count, 10) >= stored_random_number) then 
					pu_count := 0;
					power_up_enable <= '1';
				end if;
			end if;
			

		end if;
		end process;
		
		process(clk)
		begin
			if rising_edge(clk) then
				prev_vert_sync <= vert_sync;
				
				if (s_power_up_on = '1') then
				
					pu_onscreen_flag <= '1';
					
				end if;
				
				if (prev_vert_sync = '0' and vert_sync = '1') then
					pu_onscreen_flag <= '0';
				end if;
				
			end if;
		end process;
	 
				
				

end behaviour;