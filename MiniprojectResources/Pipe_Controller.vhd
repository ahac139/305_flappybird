library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Pipe_Controller is
	port(Clk, vert_sync: in std_logic;
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		pipe_x_motion: in unsigned(9 downto 0);
		pipe_on: out std_logic
	);
end entity Pipe_Controller;

architecture behaviour of Pipe_Controller is

	component Pipes is
		port(
			clk, vert_sync, enable: in std_logic;
			pixel_row, pixel_col: in std_logic_vector(9 downto 0);
			random_number: in unsigned(9 downto 0);
			pipe_x_motion: in unsigned(9 downto 0);
			pipe_on: out std_logic
		);
	end component Pipes;
	
	component random_number_generator is
    port (
        clk : in std_logic;
        random_number : out unsigned(9 downto 0)
    );
	end component;
	
	--signal gap1 : unsigned(9 downto 0) := to_unsigned(10,10);
	--signal gap2 : unsigned(9 downto 0) := to_unsigned(20,10);
	--signal gap3 : unsigned(9 downto 0) := to_unsigned(30,10);
	signal gap: unsigned(9 downto 0);
	signal pipe_on1 : std_logic;
	signal pipe_on2 : std_logic;
	signal pipe_on3 : std_logic;
	signal enable1 : std_logic := '0';
	signal enable2 : std_logic := '0';
	signal enable3 : std_logic := '0';
	
	
	begin
		
		--gap1 <= to_unsigned(200,10);
		--gap2 <= to_unsigned(100,10);
		--gap3 <= to_unsigned(150,10);
		
		P0: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable1,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			random_number => gap,
			pipe_x_motion => pipe_x_motion,
			pipe_on =>pipe_on1);
			
		P1: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable2,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			random_number => gap,
			pipe_x_motion => pipe_x_motion,
			pipe_on =>pipe_on2);

		P2: Pipes port map(
			clk => Clk,
			vert_sync => vert_sync,
			enable => enable3,
			pixel_row => pixel_row,
			pixel_col => pixel_col,
			random_number => gap,
			pipe_x_motion => pipe_x_motion,
			pipe_on => pipe_on3);
			
		RNG: random_number_generator port map(
				clk => vert_sync,
				random_number => gap);
		
		
			pipe_on <= pipe_on1 or pipe_on2 or pipe_on3;
		
			process(vert_sync)
				 variable count  : integer := 0;
			begin
				 if rising_edge(vert_sync) then
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
		 end process;
				

end behaviour;