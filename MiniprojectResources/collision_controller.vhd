library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY collision_controller IS
	PORT
		(clk,	c1: IN std_logic;
		decrease_life:out std_logic);		
END collision_controller;

architecture behaviour of collision_controller is 

--signal collision: std_logic;
signal prev_collision: std_logic := '0';

begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			--prev_collision <= c1;
			if	(prev_collision = '0' and c1 = '1') then
				decrease_life <= '1';
			else
				decrease_life <= '0';
			end if;
			prev_collision <= c1;
		end if;
	end process;

end behaviour;