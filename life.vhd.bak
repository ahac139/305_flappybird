LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity life is 
	PORT
		( clk, decrease_life	      : IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  life_on, zero_life		   : OUT std_logic);	
end life;

architecture behaviour of life is

	component char_rom IS
	PORT
	(
		character_address		:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock						: 	IN STD_LOGIC ;
		rom_mux_output			:	OUT STD_LOGIC
	);
	end component char_rom;
	
	SIGNAL size_2: std_logic_vector(9 DOWNTO 0) := "0000001111";  
	signal life_x_pos: std_logic_vector(9 downto 0) := "1000111111" ;
	signal life_y_pos: std_logic_vector(9 downto 0) := "0001000000" ;
	signal life_address: std_logic_vector(5 downto 0) := "110011";
	signal life_on_1: std_logic;
	signal prev_decrease_life: std_logic;
	begin 
	
	life: char_rom port map(
			character_address => life_address,
			font_row => pixel_row(3 downto 1),
			font_col => pixel_column(3 downto 1),
			clock => clk,
			rom_mux_output => life_on_1);
				
				
	life_on <= '1' when ( ('0' & life_x_pos <= '0' & pixel_column) and ('0' & pixel_column <= '0' & life_x_pos + size_2) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & life_y_pos <= pixel_row ) and ('0' & pixel_row <= life_y_pos + size_2)	-- y_pos - size <= pixel_row <= y_pos + size
					and (life_on_1 = '1')) else
					'0';
					
					
	
	process(clk)
		begin
		
			if(rising_edge(clk)) then
				prev_decrease_life <= decrease_life;
				if (prev_decrease_life = '0' and decrease_life = '1') then
					if (life_address /= "110000") then 
						life_address <= life_address - "000001";
					else 
						life_address <= "110011";
						zero_life <= '1';
					end if;
				end if;
			end if;
		end process;
end behaviour;