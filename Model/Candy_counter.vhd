library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CandyCounter is
  port (RESET_N : in  std_logic;
        CLK     : in  std_logic;
        ENABLE  : in  std_logic;
		  CANDY_NUMBER : in integer range 0 to 9999;
        COUNT   : out integer range 0 to 9999

        );
end CandyCounter;

architecture Behavioral of CandyCounter is
  signal t_cnt : integer range 0 to 9999;  -- internal counter signal
begin
  process (CLK, RESET_N)
  begin
    if (RESET_N = '0') then
      t_cnt <= CANDY_NUMBER;
    elsif (rising_edge(CLK)) then
      if (ENABLE = '1') then
        t_cnt <= t_cnt - 1;             -- decr
      end if;
    end if;
  end process;

  COUNT <= t_cnt;

end architecture Behavioral;
