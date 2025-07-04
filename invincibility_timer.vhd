library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity invincibity_timer is
    port (
        vert_sync    : in  std_logic;  -- 25 Hz clock input
        start : in  std_logic;  -- start counting pulse (one clock cycle)
        invincibity, inv_on   : out std_logic   -- goes high after 3 seconds
    );
end entity invincibity_timer;

architecture behavioral of invincibity_timer is
    signal count    : unsigned(9 downto 0) := (others => '0');
begin

	

    process(vert_sync)
		variable counting : std_logic;
    begin
			if rising_edge(vert_sync) then
				if (start = '1') then
					counting := '1';
				end if;
				
            if counting = '0' then
                invincibity <= '0'; -- not invinc while not counting
					 count <= (others => '0');
            else
                -- counting = '1'
                if count = 128 then
                    invincibity <= '0';      -- reset invinc
                    counting := '0';  -- stop counting automatically
						  
                    count <= (others => '0');
                else
                    count <= count + 1;
                    invincibity <= '1'; -- invinc while counting
                end if;
					 
					 if count(3) = '1' then
						inv_on <= '1';
					 else
						inv_on <= '0';
					 end if;
					 
            end if;
				
        end if;
		  
    end process;
	 

end architecture behavioral;
