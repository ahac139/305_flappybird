-- Morteza (March 2023)
-- VHDL code for BCD to 7-Segment conversion
-- In this case, LED is on when it is '0'   
library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;

entity binary_to_bcd is
     port (binary_in : in std_logic_vector(7 downto 0);
           bcd_out : out std_logic_vector(15 downto 0));
end entity;

architecture Behavioral of binary_to_bcd is
begin
    process(binary_in)
        variable binary : unsigned(7 downto 0);
        variable bcd    : unsigned(11 downto 0);
        variable i      : integer;
    begin
        binary := unsigned(binary_in);
        bcd := (others => '0');
        
        -- Double Dabble algorithm
        for i in 0 to 7 loop
            if bcd(11 downto 8) > "0100" then
                bcd(11 downto 8) := bcd(11 downto 8) + "0011";
            end if;
            if bcd(7 downto 4) > "0100" then
                bcd(7 downto 4) := bcd(7 downto 4) + "0011";
            end if;
            if bcd(3 downto 0) > "0100" then
                bcd(3 downto 0) := bcd(3 downto 0) + "0011";
            end if;
            
            bcd := bcd(10 downto 0) & binary(7); -- shift left
            binary := binary(6 downto 0) & '0';
        end loop;
        
        bcd_out(11 downto 0) <= std_logic_vector(bcd);
    end process;
end Behavioral;
