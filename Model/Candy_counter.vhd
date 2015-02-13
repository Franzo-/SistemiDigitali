library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CandyCounter is
  port (RESET_N : in  std_logic;
        CLK     : in  std_logic;
        ENABLE  : in  std_logic;
        COUNT   : out integer range 0 to (MAX_CANDIES-1)
        );
end CandyCounter;

architecture Behavioral of CandyCounter is
  signal t_cnt : integer range 0 to (MAX_CANDIES-1);  -- internal counter signal
begin
  process (CLK, RESET_N)
  begin
    if (RESET_N = '0') then
      t_cnt <= MAX_CANDIES-1;
    elsif (rising_edge(CLK)) then
      if (ENABLE = '1') then
        t_cnt <= t_cnt - 1;             -- decr
      end if;
    end if;
  end process;

  COUNT <= t_cnt;

end architecture Behavioral;
