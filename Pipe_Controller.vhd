library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Pipe_Controller is
	port(Clk, vert_sync, enable, reset: in std_logic;
		state, mode: in std_logic_vector(1 downto 0); 
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		pipe_on, increase: out std_logic
	);
end entity Pipe_Controller;

architecture behaviour of Pipe_Controller is

	component Pipes is
		port(
			clk, vert_sync, enable, reset: in std_logic;
			pixel_row, pixel_col: in std_logic_vector(9 downto 0);
			pipe_x_motion: unsigned(9 downto 0);
			random_number: in unsigned(9 downto 0);
			pipe_on, increase: out std_logic
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
			increase => increase1);
			
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
			increase => increase2);

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
			increase => increase3);
			
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
						when "10" => pipe_x_motion <= to_unsigned(0,10);
						when "11" => pipe_x_motion <= to_unsigned(4,10);
					end case;
				else
					pipe_x_motion <= to_unsigned(0,10);
				end if;
			end if;
		end process;
		
		pipe_on <= '1' when ((pipe_on1 = '1') or (pipe_on2 = '1') or (pipe_on3 = '1')) and ((state = "01") or (state = "10")) else '0';
		increase <= increase1 or increase2 or increase3;
		
		process(vert_sync)
		variable count  : integer := 0;
		begin
				if rising_edge(vert_sync) then
					if reset = '1' then 
						count := 0;
					end if;
					if (enable = '1') then
						
						enable1 <= '1';
					
						if count = 233 then
							enable2 <= '1';
							count := count + 1;
							
						elsif count > 466 then
							enable3 <= '1';
						else
							count := count + 1;
						end if;
					end if;
			end if;
		end process;
			
				

end behaviour;