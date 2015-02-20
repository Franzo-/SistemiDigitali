library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CandyCounter is
  port (RESET_N      : in  std_logic;
        CLK          : in  std_logic;
        ENABLE       : in  std_logic;
        CANDY_NUMBER : in  candy_count_type;
        COUNT        : out candy_count_type
        );
end CandyCounter;

architecture Behavioral of CandyCounter is
  signal t_cnt : candy_count_type;      -- internal counter signal
begin
  process (CLK, RESET_N)
  begin
    if (RESET_N = '0') then
      t_cnt <= CANDY_NUMBER;            -- 0 + caramelline totali
    elsif (rising_edge(CLK)) then
      if (ENABLE = '1') then
        t_cnt <= t_cnt - 1;             -- decr
      end if;
    end if;
  end process;

  COUNT <= t_cnt;

end architecture Behavioral;
