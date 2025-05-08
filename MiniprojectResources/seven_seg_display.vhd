library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;

entity seven_seg_display is
     port (binary_in : in std_logic_vector(9 downto 0);
			  hex0, hex1, hex2, hex3 : out std_logic_vector(6 downto 0));
end entity;

architecture arc1 of seven_seg_display  is

  component BCD_to_SevenSeg is
    port ( BCD_digit : in std_logic_vector(3 downto 0);
    	   SevenSeg_out : out std_logic_vector(6 downto 0));
  end component BCD_to_SevenSeg;
	
	signal shift_reg : unsigned(25 downto 0);
	signal bcd_out : std_logic_vector(15 downto 0) := "0000000000000001";
	signal i : integer;

begin


    process(binary_in)
    begin
        -- Initialize shift register: 16 bits of BCD + 10 bits of binary
        shift_reg <= (others => '0');
        shift_reg(9 downto 0) <= unsigned(binary_in);

        -- Perform 10 shift cycles
        for i in 0 to 9 loop
            -- If any BCD digit is >= 5, add 3
            if shift_reg(13 downto 10) > "0100" then
                shift_reg(13 downto 10) <= shift_reg(13 downto 10) + "0011";
            end if;
            if shift_reg(17 downto 14) > "0100" then
                shift_reg(17 downto 14) <= shift_reg(17 downto 14) + "0011";
            end if;
            if shift_reg(21 downto 18) > "0100" then
                shift_reg(21 downto 18) <= shift_reg(21 downto 18) + "0011";
            end if;
            if shift_reg(25 downto 22) > "0100" then
                shift_reg(25 downto 22) <= shift_reg(25 downto 22) + "0011";
            end if;

            -- Shift left
            shift_reg <= shift_reg(24 downto 0) & '0';
        end loop;

        -- Output the BCD digits
        bcd_out <= std_logic_vector(shift_reg(25 downto 10));  -- thousands, hundreds, tens, ones
    end process;
	 
	

  ones : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd_out(3 downto 0),
      SevenSeg_out => hex0
  );
  
  tens : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd_out(7 downto 4),
      SevenSeg_out => hex1
  );
  hundreds : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd_out(11 downto 8),
      SevenSeg_out => hex2
  );
  
  thousands : BCD_to_SevenSeg
    port map(
      BCD_digit => bcd_out(15 downto 12),
      SevenSeg_out => hex3
  );
  


end architecture arc1; 
