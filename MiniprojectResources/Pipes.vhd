library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Pipes is
	port(clk, vert_sync: in std_logic;
		  pixel_row, pixel_col: in std_logic_vector(9 downto 0);
		  red, green, blue: out std_logic);
end Pipes;

architecture behaviour of Pipes is
	signal size_y, size_x: std_logic_vector(9 downto 0);
	signal pipe_y_pos, pipe_x_pos, pipe_x_motion: std_logic_vector(9 downto 0);
	signal pipe_on: std_logic;
	signal max_x, min_x: std_logic_vector(9 downto 0);
	begin
		
		size_y <= CONV_STD_LOGIC_VECTOR(240, 10);
		size_x <= CONV_STD_LOGIC_VECTOR(120, 10);
		--pipe_y_pos <= CONV_STD_LOGIC_VECTOR(0, 10);
		pipe_x_pos <= CONV_STD_LOGIC_VECTOR(0, 10);
		pipe_x_motion <= CONV_STD_LOGIC_VECTOR(2, 10);
		max_x <= CONV_STD_LOGIC_VECTOR(639, 10);
		min_x <= CONV_STD_LOGIC_VECTOR(0, 10);
		
		
		pipe_on <= '1' when (pipe_x_pos <= pixel_col) and (pixel_col <= pipe_x_pos + size_x) 
							and (pipe_y_pos <= pixel_row) and (pixel_row <= pipe_y_pos + size_y )
						else '0';
						
		red <= not pipe_on;
		green <= '1';
		blue <= not pipe_on;
		
	Move_pipe: process (vert_sync)
	begin
		if rising_edge(vert_sync) then
			if (pipe_x_pos + pipe_x_motion >= max_x) then
				pipe_x_pos <= min_x;
			else
				pipe_x_pos <= pipe_x_pos + pipe_x_motion;
			end if;
		end if;
	end process Move_pipe;
						
end behaviour;