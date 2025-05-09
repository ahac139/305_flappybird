library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;

entity seven_seg_display is
     port (
			  binary_in : in std_logic_vector(7 downto 0);
			  hex0, hex1, hex2 : out std_logic_vector(6 downto 0));
end entity;

architecture arc1 of seven_seg_display  is

  component BCD_to_SevenSeg is
    port ( BCD_digit : in std_logic_vector(3 downto 0);
    	   SevenSeg_out : out std_logic_vector(6 downto 0));
  end component BCD_to_SevenSeg;
	

	component binary_to_bcd is
     port (binary_in : in std_logic_vector(7 downto 0);
           bcd_out : out std_logic_vector(11 downto 0));
	end component;
	
	signal bcd : std_logic_vector(11 downto 0);
begin

  converter : binary_to_bcd 
	 port map(
		binary_in => binary_in,
		bcd_out => bcd
	);

  ones : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd(3 downto 0),
      SevenSeg_out => hex0
  );
  
  tens : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd(7 downto 4),
      SevenSeg_out => hex1
  );
  hundreds : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd(11 downto 8),
      SevenSeg_out => hex2
  );
  


end architecture arc1; 
