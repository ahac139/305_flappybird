library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity random_number_generator is
    port (
        clk : in std_logic;
        random_number : out unsigned(9 downto 0)
    );
end entity;

architecture behavior of random_number_generator is
    signal lfsr : unsigned(8 downto 0) := "111111111";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            lfsr(0) <= lfsr(8);
            lfsr(1) <= lfsr(0);
            lfsr(2) <= lfsr(1);
            lfsr(3) <= lfsr(2);
            lfsr(4) <= lfsr(3) xor lfsr(8);
            lfsr(5) <= lfsr(4);
            lfsr(6) <= lfsr(5);
            lfsr(7) <= lfsr(6);
            lfsr(8) <= lfsr(7);
        end if;
    end process;
	random_number <=  '0' & (lfsr - to_unsigned(300, 9)) when lfsr > to_unsigned(300,9) else '0' & lfsr;
end architecture;