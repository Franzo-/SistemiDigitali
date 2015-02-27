library IEEE;
use IEEE.std_logic_1164.all;
use work.pacman_package.all;

entity Eating_controller is

  port(
    --segnali ingresso
    CLOCK                  : in std_logic;
    RESET_N                : in std_logic;
    CHARACTERS_COORDINATES : in character_cell_array;
    CANDY_LEFT             : in integer;

    --segnali di uscita
    GAME_OVER    : out std_logic;
    WIN          : out std_logic;
    REMOVE_CANDY : out cell_coordinates  --(indica al model di rimuovere una caramella)
    );

end entity;


architecture my_eating_controller of Eating_controller is

  signal pacman_coordinates : cell_coordinates;
  signal ghost1_coordinates : cell_coordinates;
  signal ghost2_coordinates : cell_coordinates;
  signal ghost3_coordinates : cell_coordinates;
  signal ghost4_coordinates : cell_coordinates;


begin

  pacman_coordinates <= CHARACTERS_COORDINATES(0).coordinates;
  ghost1_coordinates <= CHARACTERS_COORDINATES(1).coordinates;
  ghost2_coordinates <= CHARACTERS_COORDINATES(2).coordinates;
  ghost3_coordinates <= CHARACTERS_COORDINATES(3).coordinates;
  ghost4_coordinates <= CHARACTERS_COORDINATES(4).coordinates;

--statement concorrente per il pacman----------
--dove passa il pacman viene sempre rimossa a prescindere la caramella (se non c'e non succede nulla)
  REMOVE_CANDY <= pacman_coordinates;

----------------------------------------------------------------------

--processo per i fantasmi----------
  ghost_eating : process(CLOCK, RESET_N)

  begin

    if(RESET_N = '0') then
      GAME_OVER <= '0';

    elsif rising_edge(CLOCK) then

      --confronto le coordinate del pacman con le coordinate dei fantasmi
      --genera gameover se uno dei confronti ha successo
      if (ghost1_coordinates = pacman_coordinates or
          ghost2_coordinates = pacman_coordinates or
          ghost3_coordinates = pacman_coordinates or
          ghost4_coordinates = pacman_coordinates) then

        GAME_OVER <= '1';
      end if;

    end if;
  end process ghost_eating;

  ------processo che si attiva ogni volta che cambia il numero delle caramelle-----
  Candy_trigger : process (CLOCK, RESET_N)
  begin

    if(RESET_N = '0') then
      WIN <= '0';

    elsif rising_edge(CLOCK) then

      if (CANDY_LEFT = 0) then
        WIN <= '1';
      end if;

    end if;
  end process Candy_trigger;

end architecture;
