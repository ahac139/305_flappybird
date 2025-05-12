library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_divider is
	port(Clk : in std_logic;
	Clk_out : out std_logic);
end entity clock_divider;

architecture behaviour of clock_divider is 

signal count : integer := 1;
signal temp_clk : std_logic := '0';

begin

	main : process(Clk)
	
	begin
		if (rising_edge(Clk)) then
			temp_clk <= not temp_clk;
		end if;
	end process;
	
	Clk_out <= temp_clk;

end behaviour;