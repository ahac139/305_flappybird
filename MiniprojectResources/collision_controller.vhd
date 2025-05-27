library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY collision_controller IS
    PORT (
        clk           : IN std_logic;
        c1            : IN std_logic; 
        decrease_life : OUT std_logic  
    );		
END collision_controller;

architecture behaviour of collision_controller is
    signal collision_prev : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if (c1 = '1' and collision_prev = '0') then
                decrease_life <= '1';
            else
                decrease_life <= '0';
            end if;
            collision_prev <= c1;
        end if;
    end process;

end behaviour;