library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pipes is
	port(
		clk, vert_sync, enable: in std_logic;
		pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		random_number: in unsigned(9 downto 0);
		pipe_x_motion: in unsigned(9 downto 0);
		pipe_on: out std_logic
	);
end Pipes;

architecture behaviour of Pipes is
		
	signal size_x: unsigned(9 downto 0) := to_unsigned(60, 10);
	signal pipe_x_pos: unsigned (9 downto 0) := to_unsigned(639, 10);
	signal max_x, min_x: unsigned(9 downto 0);
	signal gap_size_y: unsigned(9 downto 0);
	signal gap_y: unsigned(9 downto 0) := to_unsigned(250,10);
	signal prev_enable: std_logic;
begin

	-- Set constants
	--pipe_y_pos <= to_unsigned(0, 10);
	max_x <= to_unsigned(639, 10);
	min_x <= to_unsigned(0, 10);
	gap_size_y <= to_unsigned(200,10);

	-- Draw pipe
	pipe_on <= '1' when (pipe_x_pos <= unsigned(pixel_col)) and (unsigned(pixel_col) <= pipe_x_pos + size_x) and 
					   (not((unsigned(pixel_row) > gap_y) and (unsigned(pixel_row) < gap_y + gap_size_y)))
			  else '0';

	-- Color output
	--red <= not pipe_on;
	--green <= '1';
	--blue <= not pipe_on;

	-- Pipe movement
	Move_pipe: process (enable, vert_sync)
	begin
		if (rising_edge(vert_sync)) then
		
			if prev_enable = '0' and enable = '1' then
				gap_y <= random_number;
			end if;
			prev_enable <= enable;
			
			if (enable = '1') then
			
				if (pipe_x_pos - pipe_x_motion = min_x) then
				
					if (size_x = MIN_X) then
						size_x <= to_unsigned(60, 10);
						pipe_x_pos <= max_x;
						gap_y <= random_number;
					else				
						size_x <= size_x - pipe_x_motion;
					end if;
					
				else
					pipe_x_pos <= pipe_x_pos - pipe_x_motion;
				end if;
			end if;
		
		end if;
	end process Move_pipe;
	
	

end behaviour;
