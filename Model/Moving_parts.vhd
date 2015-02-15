library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity MovingParts is

  port (
    CLOCK                  : in  std_logic;
    RESET_N                : in  std_logic;
    MOVE_COMMANDS          : in  move_commands_array;
    --
    CHARACTERS_COORDINATES : out character_cell_array
    );

end entity MovingParts;

architecture RTL of MovingParts is
  signal characters_cells      : character_cell_array;
  signal next_characters_cells : character_cell_array;

begin

  -- Aggiorna le coordinate di ogni personaggio in modo sincrono
  CoordinatesUpdate : process (CLOCK, RESET_N) is
  begin
    if (RESET_N = '0') then             -- asynchronous reset (active low)

      ResetLoop : for i in characters_cells'range loop

        -- Assegna l'enumerativo a seconda del valore dell'indice i
        character_cells(i).cell_character <= character_type'val(i);

        CoordinatesReset : if (characters_cells(i).cell_character = PACMAN_CHAR) then
          characters_cells(i).coordinates <= PACMAN_RESET_POS;
        else
          characters_cells(i).coordinates <= GHOSTS_RESET_POS;
        end if CoordinatesReset;

      end loop ResetLoop;

    elsif (rising_edge(CLOCK)) then     -- rising clock edge
      characters_cells <= next_characters_cells;
    end if;
  end process CoordinatesUpdate;

  -----------------------------------------------------------------------------

  -- Genera le coordinate di ogni personaggio da assegnare al clock successivo
  NextCoordinates : process (MOVE_COMMANDS, characters_cells) is
  begin

    next_characters_cells <= characters_cells;

    eachCharacter : for i in character_cells'range loop
      if (MOVE_COMMANDS(i).move_up = '1') then
        next_characters_cells(i).coordinates.row <= characters_cells(i).coordinates.row - 1;
      elsif (MOVE_COMMANDS(i).move_down = '1') then
        next_characters_cells(i).coordinates.row <= characters_cells(i).coordinates.row + 1;
      elsif (MOVE_COMMANDS(i).move_right = '1') then
        next_characters_cells(i).coordinates.col <= characters_cells(i).coordinates.col + 1;
      elsif (MOVE_COMMANDS(i).move_left = '1') then
        next_characters_cells(i).coordinates.col <= characters_cells(i).coordinates.col - 1;
      end if;
    end loop eachCharacter;

  end process NextCoordinates;

  -----------------------------------------------------------------------------

  -- Coordinate in uscita aggiornate con statement concorrente
  CHARACTERS_COORDINATES <= characters_cells;

end architecture RTL;
