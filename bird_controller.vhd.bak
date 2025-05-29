LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird_controller IS
	PORT
		( clk, vert_sync, mouse_click	: IN std_logic;
		  pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  -- state/mode after restructure
		  bird_on 							: OUT std_logic);		
END bird_controller;

architecture behavior of bird_controller is

SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL bird_y_pos, bird_x_pos	: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0) := "0000000000";

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- bird_x_pos and bird_y_pos show the (x,y) for the centre of bird

bird_x_pos <= CONV_STD_LOGIC_VECTOR(100,10);


bird_on <= '1' when ( ('0' & bird_x_pos <= pixel_column + size) and ('0' & pixel_column <= bird_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & bird_y_pos <= pixel_row + size) and ('0' & pixel_row <= bird_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


Bird_Physics : process (vert_sync)  	
begin
	-- Move bird once every vertical sync
	if (rising_edge(vert_sync)) then		
		
		if (bird_y_pos + bird_y_motion <= CONV_STD_LOGIC_VECTOR(479,10) - size)  then 
			if (bird_y_motion < 5) then
				bird_y_motion <= bird_y_motion + CONV_STD_LOGIC_VECTOR(1,10);
			end if;
		else
			bird_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
		end if;
		
		
		if (mouse_click = '1') and (bird_y_motion >= CONV_STD_LOGIC_VECTOR(0,10))  then
			bird_y_motion <= - CONV_STD_LOGIC_VECTOR(12,10);
		end if;
		
		-- Compute next bird Y position
		bird_y_pos <= bird_y_pos + bird_y_motion;
		
	end if;
end process Bird_Physics;


END behavior;

