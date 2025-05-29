library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pipes is
	port(
		clk, vert_sync, enable, reset, power_up_enable, pu_collected: in std_logic;
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		pipe_x_motion: unsigned(9 downto 0);
		random_number: in unsigned(9 downto 0);
		pipe_on, increase, power_up_on: out std_logic
	);
end Pipes;

architecture behaviour of Pipes is
		
	signal size_x: unsigned(9 downto 0) := to_unsigned(60, 10);
	signal pipe_x_pos: unsigned (9 downto 0) := to_unsigned(639, 10);
	--signal pipe_x_motion: unsigned(9 downto 0);
	signal max_x, min_x: unsigned(9 downto 0);
	signal gap_size_y: unsigned(9 downto 0);
	signal gap_y: unsigned(9 downto 0) := to_unsigned(250,10);
	signal prev_enable: std_logic;

	signal s_power_up_enable : std_logic;

	component life_power_up IS
	PORT
		( clk, enable, pu_collected: IN std_logic;
        pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		  y_pos, x_pos 				: IN unsigned (9 downto 0);
		  power_up_on					: out std_logic);		
	END component life_power_up;

begin

	powerUp : life_power_up port map(
		clk => clk,
		pu_collected => pu_collected,
		pixel_row => pixel_row,
		pixel_col => pixel_col,
		y_pos => gap_y,
		x_pos => pipe_x_pos,
		enable => s_power_up_enable,
		power_up_on => power_up_on);


	max_x <= to_unsigned(639, 10);
	min_x <= to_unsigned(0, 10);
	gap_size_y <= to_unsigned(130,10);

	pipe_on <= '1' when (pipe_x_pos <= unsigned(pixel_col)) and (unsigned(pixel_col) <= pipe_x_pos + size_x) and 
					   (not((unsigned(pixel_row) > gap_y) and (unsigned(pixel_row) < gap_y + gap_size_y)))
			  else '0';

	Move_pipe: process (enable, vert_sync)
	begin
		if (rising_edge(vert_sync)) then
		
			if (reset = '1') or (enable = '0') then
				pipe_x_pos <= to_unsigned(639, 10);
			end if;
		
			if prev_enable = '0' and enable = '1' then
				gap_y <= random_number;
			end if;
			prev_enable <= enable;
			
			if (enable = '1') then
			
				if (pipe_x_pos - pipe_x_motion < min_x + pipe_x_motion) or (pipe_x_pos = to_unsigned(0, 10)) then
				
					if (size_x = MIN_X) then
						size_x <= to_unsigned(60, 10);
						pipe_x_pos <= max_x;
						gap_y <= random_number;

						s_power_up_enable <= power_up_enable;
					else	
						pipe_x_pos <= to_unsigned(0, 10);
						size_x <= size_x - pipe_x_motion;
					end if;
					
				else
					pipe_x_pos <= pipe_x_pos - pipe_x_motion;
				end if;
			end if;
						
			if (pipe_x_pos + size_x < to_unsigned(100,10)) then
				increase <= '1';
			else
				increase <= '0';
			end if;
			
		end if;
	end process Move_pipe;
	
	

end behaviour;
