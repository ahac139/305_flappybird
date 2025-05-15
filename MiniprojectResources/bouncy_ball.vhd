LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( pb1, pb2, clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column, mouse_x, mouse_y	: IN std_logic_vector(9 DOWNTO 0);
			 mouse_clk : in std_logic;
		  ball_on : out std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos				: std_logic_vector(9 DOWNTO 0) := "1001001110";
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball


ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';

Move_Ball: process (vert_sync)  	
begin
	-- Move ball once every vertical sync
	if (rising_edge(vert_sync)) then			
		-- Bounce off top or bottom of the screen
		if (mouse_clk = '0') then
			if ( ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
				ball_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
			elsif (ball_y_pos <= size) then 
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			end if;
			-- Compute next ball Y position
			ball_y_pos <= ball_y_pos + ball_y_motion;
		else
			ball_x_pos <= mouse_x;
			ball_y_pos <= mouse_y;
		end if;
	end if;
end process Move_Ball;

END behavior;

