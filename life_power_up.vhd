LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

ENTITY life_power_up IS
	PORT
		( clk, enable, pu_collected	: IN std_logic;
        pixel_row, pixel_col	: IN std_logic_vector(9 DOWNTO 0);
		  y_pos, x_pos 				: IN unsigned (9 downto 0);
		  power_up_on					: out std_logic);		
END life_power_up;

architecture behaviour of life_power_up is
	SIGNAL size 					: unsigned(9 DOWNTO 0) := to_unsigned(8,10);  
	signal enabled_flag			: std_logic;
	signal prev_pu_collected : std_logic;
	
	begin
	
	
	power_up_on <= '1' when ( ('0' & x_pos + to_unsigned(30, 10) <= unsigned(pixel_col) + size) 
						and ('0' & unsigned(pixel_col) <= x_pos + to_unsigned(30, 10) + size) 
						and ('0' & y_pos + to_unsigned(100,10) <= unsigned(pixel_row) + size) 
						and ('0' & unsigned(pixel_row) <= y_pos + size + to_unsigned(100,10)) 
						and (enabled_flag = '1') ) else	
						'0';
	
	
	process (enable, clk)
	begin
		if (rising_edge(clk)) then
			
			prev_pu_collected <= pu_collected;
			
			if (enable = '1') then
				enabled_flag <= '1';
			end if;
			
			if (pu_collected = '1') and (prev_pu_collected = '0') then
				enabled_flag <= '0';
			end if;
			
			if (x_pos < to_unsigned(10, 10)) then
				enabled_flag <= '0';
			end if;
			
		end if;
	end process Move_pipe;
	
end behaviour;

