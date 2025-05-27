LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY score_power_up IS
	PORT
		( clk	: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  random_number				: in unsigned(9 downto 0);
		  power_up_on					: out std_logic);		
END score_power_up;

architecture behaviour of score_power_up is
	SIGNAL size 					: std_logic_vector(9 DOWNTO 0) := to_unsigned(8,10);;  
	SIGNAL power_up_y_pos, power_up_x_pos	: std_logic_vector(9 DOWNTO 0);
	signal power_up_x_motion: std_logic_vector(9 DOWNTO 0) := to_unsigned(1,10)
	begin
	
	
	power_up_on <= '1' when ( ('0' & bird_x_pos <= pixel_column + size) and ('0' & pixel_column <= bird_x_pos + size) 
						and ('0' & bird_y_pos <= pixel_row + size) and ('0' & pixel_row <= bird_y_pos + size) )  else	
						'0';
	
	process(clk) 
	begin
		if(rising_edge(clk)) then
			if(power_up_x_pos = to_unsigned(0,10)) then
			end if;
		end if;
	end process;
	
end behaviour;

