library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CandyCounter is
  port (RESET_N : in  std_logic;
        CLK     : in  std_logic;
        ENABLE : in std_logic;  -- mappato sul segnale monoimpulsivo del controller
        COUNT   : out integer range 0 to (MAX_CANDIES-1);
        SCORE : out integer range 0 to (MAX_CANDIES-1)
        );
end CandyCounter;

architecture my_count of CandyCounter is
  signal t_cnt : integer range 0 to (MAX_CANDIES-1);  -- internal counter signal
begin
  process (CLK, RESET_N)
  begin
    if (RESET_N = '0') then
      t_cnt <= MAX_CANDIES-1;
    elsif (rising_edge(CLK)) then
      if (ENABLE = '1')
        t_cnt <= t_cnt - 1;               -- decr
      end if;
    end if;
  end process;
  
  COUNT <= t_cnt;
  
  SCORE <= (MAX_CANDIES-1) - t_cnt;     -- Il punteggio dipende direttamente dalle
                                        -- caramelline mangiate
  
end architecture my_count;
