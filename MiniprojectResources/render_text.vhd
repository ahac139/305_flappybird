library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity render_text is
	port(vert_sync : in std_logic;
	text_on : out std_logic;
	pixel_row, pixel_column: IN std_logic_vector(9 DOWNTO 0)
	);
end entity render_text;

architecture behaviour of render_text is 

	constant TEXT_LENGTH : integer := 3;
	constant TEXT_X : integer := 100;
	constant TEXT_Y : integer := 100;
	
	
	type text_array is array (0 to TEXT_LENGTH - 1) of std_logic(5 downto 0);
	signal text_string : text_array := (
		0 => "000001", -- A
		0 => "000010", -- B
		0 => "000011"  -- C
	);
	
begin

	process(pixel_column, pixel_row)
		variable pix_col_int : integer;
		variable pix_row_int : integer;
		
		variable in_text_area : std_logic;
		variable char_index : integer;
	begin
		
		pix_col_int := to_integer(unsigned(pixel_col));
		
		pix_row_int := to_integer(unsigned(pixel_row));
		
		in_text_area := (pix_col_int >= TEXT_X and pix_col_int < TEXT_X * 8) and
							 (pix_row_int >= TEXT_Y and pix_row_int < TEXT_Y);
		
		if (in_text_area = '1') then
			char_index := (pixel_column - TEXT_x) / 8;
			
		
	
	end process;

end behaviour;