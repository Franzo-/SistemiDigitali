library ieee;
use ieee.std_logic_1164.all;

package pacman_package is

  -- Constants
  constant MAP_COLUMNS          : positive := 21;  -- cells
  constant MAP_ROWS             : positive := 21;  -- cells
  constant NUMBER_OF_CHARACTERS : positive := 5;   -- pacman + ghosts

  -----------------------------------------------------------------------------

  -- Tipo per il candy counter
  subtype candy_count_type is integer range 0 to 9999;

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

  -- Query su celle adiacenti
  type cell_nearby is record
    cell_up    : cell_coordinates;
    cell_down  : cell_coordinates;
    cell_left  : cell_coordinates;
    cell_right : cell_coordinates;
  end record;

  type cell_nearby_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of cell_nearby;  -- 0 = pacman; others = ghosts

  -- Risposta alla query su celle adiacenti
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

  -- Direzione di movimento dei personaggi
  type character_direction is (UP_DIR, DOWN_DIR, LEFT_DIR, RIGHT_DIR, IDLE);

  -----------------------------------------------------------------------------

  -- Stato corrente del gioco
  type state_controller_type is (START_SCREEN, PLAYING, PAUSE, WIN, GAME_OVER);

end package;
