library ieee;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

package controller_package is

  -- Segnali di can_move raggruppati
  type can_move is record
    can_move_up    : std_logic;
    can_move_down  : std_logic;
    can_move_right : std_logic;
    can_move_left  : std_logic;
  end record can_move;

  type can_move_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of can_move;

  ------------------------------------------------------------------------------

  -- Funzioni per l'intelligenza dei fantasmini

  function is_crossroad (
    current_dir : character_direction;
    can_moves   : can_move)
    return boolean;

  function random_direction (
    random_value          : integer;
    can_moves             : can_move;
    character_coordinates : cell_coordinates;
    index                 : integer)
    return character_direction;

end package controller_package;

package body controller_package is

  -- Funzione che riconosce se i fantasmini sono in un incrocio della mappa
  function is_crossroad (
    current_dir : character_direction;
    can_moves   : can_move)
    return boolean is variable incrocio : boolean := false;
  begin  -- function is_crossroad

    case current_dir is
      when UP_DIR | DOWN_DIR =>
        if ((can_moves.can_move_left = '1') or (can_moves.can_move_right = '1')) then
          incrocio := true;
        end if;
      when LEFT_DIR | RIGHT_DIR =>
        if ((can_moves.can_move_up = '1') or (can_moves.can_move_down = '1')) then
          incrocio := true;
        end if;
      when others => incrocio := false;
    end case;

    return incrocio;
  end function is_crossroad;

  -----------------------------------------------------------------------------

  -- Genera una direzione casuale quando il fantasmino è a un incrocio
  function random_direction (
    random_value          : integer;
    can_moves             : can_move;
    character_coordinates : cell_coordinates;
    index                 : integer)
    return character_direction is variable direction : character_direction := IDLE;
  begin  -- function random_direction

    case (character_coordinates.row * random_value + character_coordinates.col * (index+1)) mod 4 is
      when 0 =>
        if (can_moves.can_move_up = '1') then
          direction := UP_DIR;
        end if;
      when 1 =>
        if (can_moves.can_move_down = '1') then
          direction := DOWN_DIR;
        end if;
      when 2 =>
        if (can_moves.can_move_left = '1') then
          direction := LEFT_DIR;
        end if;
      when 3 =>
        if (can_moves.can_move_right = '1') then
          direction := RIGHT_DIR;
        end if;
      when others => direction := IDLE;
    end case;

    return direction;
  end function random_direction;

end package body controller_package;
