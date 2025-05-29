library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Pipe_Controller is
	port(Clk, vert_sync: in std_logic;
		state, mode: in std_logic_vector(1 downto 0); 
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		red, green, blue: out std_logic
	);
end entity Pipe_Controller;

architecture behaviour of Pipe_Controller is

	component Pipes is
		port(
			clk, vert_sync, enable: in std_logic;
			pixel_row, pixel_col: in std_logic_vector(9 downto 0);
			pipe_x_motion: unsigned(9 downto 0);
			random_number: in unsigned(9 downto 0);
			pipe_on: out std_logic
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
	
	
	signal pipe_on : std_logic;
	
	begin
		
		
		P0: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable1,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on =>pipe_on1);
			
		P1: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable2,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on =>pipe_on2);

		P2: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable3,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			pipe_x_motion => pipe_x_motion,
			random_number => gap,
			pipe_on => pipe_on3);
			
		RNG: random_number_generator port map(
				clk => vert_sync,
				random_number => gap);
		
		
		pipe_on <= pipe_on1 or pipe_on2 or pipe_on3;
			
		red <= not pipe_on;
		green <= '1';
		blue <= not pipe_on;
		

								  
		process(clk) 
		begin
			if(rising_edge(clk)) then
			
				if (state = "01") then
					pipe_x_motion <= to_unsigned(0,10);
					
				elsif (mode = "01") then
					pipe_x_motion <= to_unsigned(1,10);
					
				elsif (mode = "10") then
					pipe_x_motion <= to_unsigned(2,10);
					
				elsif (mode = "11") then 
					pipe_x_motion <= to_unsigned(4,10);
					
				end if;
			end if;
		end process;
		
		
		process(vert_sync)
			 variable count: integer := 0;
		begin
		
			 if rising_edge(vert_sync) then
				enable1 <= '1';
				
				if count = 233 then --(233 / pipe_x_motion) then --233 for 1 speed
					enable2 <= '1';
					count := count + 1;
					
				elsif count > 466 then--(466 / pipe_x_motion) then --466 for 1 speed
					enable3 <= '1';
					
				else
					count := count + 1;
					
				end if;
			end if;
	 end process;
				

end behaviour;