library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity highscore is
	port( clk : in std_logic;
			tens, ones : in std_logic_vector(3 downto 0);
			hex0, hex1 : out std_logic_vector(6 downto 0));
end highscore;

architecture behaviour of highscore is

component BCD_to_SevenSeg is
     port (BCD_digit : in std_logic_vector(3 downto 0);
           SevenSeg_out : out std_logic_vector(6 downto 0));
end component;

signal high_tens, high_ones : std_logic_vector(3 downto 0) := "0000";


begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if ((unsigned(tens) > unsigned(high_tens)))
			or ((high_tens = "0000") and (unsigned(ones) > unsigned(high_ones))) then
				high_tens <= tens;
				high_ones <= ones;
			end if;
		end if;
	end process;
	
	
  one : BCD_to_SevenSeg
    port map(
      BCD_digit => high_ones,
      SevenSeg_out => hex0
  );
  
  ten : BCD_to_SevenSeg
    port map(
      BCD_digit => high_tens,
      SevenSeg_out => hex1
  );
  
 end architecture behaviour;
		