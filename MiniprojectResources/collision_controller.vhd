library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY collision_controller IS
    PORT (
        clk, reset : IN std_logic;
        collision	    : IN std_logic; 
        collision_detected : OUT std_logic  
    );		
END collision_controller;


architecture behaviour of collision_controller is
   signal collision_prev : std_logic := '0';
	signal reset_prev : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if (collision = '1' and collision_prev = '0') then
                collision_detected <= '1';
				end if;
				if (reset = '1' and reset_prev = '0') then
                collision_detected <= '0';
				end if;
				
            collision_prev <= collision;
				reset_prev <= reset;
        end if;
    end process;

end behaviour;