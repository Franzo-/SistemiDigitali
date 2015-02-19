library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.view_package.all;
use work.pacman_package.all;

-------------------------------------------------------------------------------
-- questa entita prende in ingresso il segnale candy_left proveniente
-- dal candy counter e poi genera i 4 segnali HEX per i 7 segment display
-------------------------------------------------------------------------------
entity SevenSegEntity is
  port
    (
      CANDY_LEFT : in  integer range 0 to (MAX_CANDIES-1);
      HEX0       : out std_logic_vector(6 downto 0);
      HEX1       : out std_logic_vector(6 downto 0);
      HEX2       : out std_logic_vector(6 downto 0);
      HEX3       : out std_logic_vector(6 downto 0)
      );

end entity SevenSegEntity;

-------------------------------------------------------------------------------

architecture Dataflow of SevenSegEntity is

  signal digit1, digit2, digit3, digit4 : integer range 0 to 9 := 0;

begin

  seg_ctrl(CANDY_LEFT, digit1, digit2, digit3, digit4);
  HEX0 <= int_to7seg(digit1);
  HEX1 <= int_to7seg(digit2);
  HEX2 <= int_to7seg(digit3);
  HEX3 <= int_to7seg(digit4);

end architecture;
