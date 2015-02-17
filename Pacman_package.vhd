library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package pacman_package is

  -- Constants
  constant CELL_SIZE            : positive := 10;  -- pixels
  constant MAP_COLUMNS          : positive := 20;  -- cells
  constant MAP_ROWS             : positive := 20;  -- cells
  constant MAX_CANDIES          : positive := 50;
  constant NUMBER_OF_CHARACTERS : positive := 5;   -- pacman + ghosts

  -----------------------------------------------------------------------------

  -- Map declarations
  type map_cell_type is record
    is_wall  : std_logic;
    is_candy : std_logic;
  end record;

  type map_type is array(0 to (MAP_ROWS-1), 0 to (MAP_COLUMNS-1)) of map_cell_type;

  -----------------------------------------------------------------------------

  -- Coordinate 
  type cell_coordinates is record
    col : integer range 0 to (MAP_COLUMNS-1);
    row : integer range 0 to (MAP_ROWS-1);
  end record;

  ----------------------------------------------------------------------------- 

  -- Query su coordinate
  type cell_nearby is record
    cell_up    : cell_coordinates;
    cell_down  : cell_coordinates;
    cell_left  : cell_coordinates;
    cell_right : cell_coordinates;
  end record;

  type cell_nearby_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of cell_nearby;  -- 0 = pacman; others = ghosts

  type cell_nearby_content is record
    cell_up_content    : map_cell_type;
    cell_down_content  : map_cell_type;
    cell_left_content  : map_cell_type;
    cell_right_content : map_cell_type;
  end record;

  type cell_nearby_content_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of cell_nearby_content;  -- 0 = pacman; others = ghosts

  -----------------------------------------------------------------------------

  -- Blocco mobile
  type character_type is (PACMAN_CHAR, GHOST1_CHAR, GHOST2_CHAR, GHOST3_CHAR, GHOST4_CHAR);
  attribute enum_encoding                   : string;
  attribute enum_encoding of character_type : type is "one-hot";

  type character_cell_type is record
    cell_character : character_type;
    coordinates    : cell_coordinates;
  end record;

  type character_cell_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of character_cell_type;

  -----------------------------------------------------------------------------

  -- Comandi di move raggruppati
  type move_commands is record
    move_up    : std_logic;
    move_down  : std_logic;
    move_right : std_logic;
    move_left  : std_logic;
  end record move_commands;

  type move_commands_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of move_commands;

  -----------------------------------------------------------------------------

  -- Segnali di can_move raggruppati
  type can_move is record
    can_move_up    : std_logic;
    can_move_down  : std_logic;
    can_move_right : std_logic;
    can_move_left  : std_logic;
  end record can_move;

  ------------------------------------------------------------------------------

  -- Intelligenza dei fantasmini
  type ghost_direction is (UP_DIR, DOWN_DIR, LEFT_DIR, RIGHT_DIR, IDLE);

  function is_crossroad (
    signal current_dir : ghost_direction;
    signal can_moves   : can_move)
    return boolean;

  function random_direction (
    signal random_value : integer range 0 to 3;
    signal can_moves : can_move)
    return ghost_direction;

  -----------------------------------------------------------------------------

  -- Coordinates at reset
  constant PACMAN_RESET_POS : cell_coordinates := (
    col => 0,
    row => 0
    );

  constant GHOSTS_RESET_POS : cell_coordinates := (
    col => MAP_COLUMNS/2,
    row => MAP_ROWS/2
    );

	 
   -----------------------------------------------------------------------------

  -- enumerativi che indicano la stringa che  l'automa passa alla view (la stringa indica in che stato siamo)
  type string_condition_type is (START_SCREEN,PLAYING, PAUSE,WIN,GAME_OVER);

  -----------------------------------------------------------------------------	 
end package;

package body pacman_package is

  -- Funzione che riconosce se i fantasmini sono in un incrocio della mappa
  function is_crossroad (
    current_dir : ghost_direction;
    can_moves   : can_move)
    return boolean is variable incrocio : boolean;
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
    random_value : integer range 0 to 3;
    can_moves    : can_move)
    return ghost_direction is variable direction : ghost_direction := IDLE;
  begin  -- function random_direction

    case random_value is
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
  
  


end package body pacman_package;
