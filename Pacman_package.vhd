library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package pacman_package is

  -- Constants
  constant CELL_SIZE   : positive := 10;  -- pixels
  constant MAP_COLUMNS : positive := 20;  -- cells
  constant MAP_ROWS    : positive := 20;  -- cells
  constant MAX_CANDIES : positive := 50;

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

  type cell_nearby_array is array (0 to 4) of cell_nearby;  -- 0 = pacman; 1-4 = ghosts

  type cell_nearby_content is record
    cell_up_content    : map_cell_type;
    cell_down_content  : map_cell_type;
    cell_left_content  : map_cell_type;
    cell_right_content : map_cell_type;
  end record;

  type cell_nearby_content_array is array (0 to 4) of cell_nearby_content;  -- 0 = pacman; 1-4 = ghosts

  -----------------------------------------------------------------------------

   -- Blocco mobile
  type character_type is (PACMAN_CHAR, GHOST1_CHAR, GHOST2_CHAR, GHOST3_CHAR, GHOST4_CHAR);
  attribute enum_encoding                   : string;
  attribute enum_encoding of character_type : type is "one-hot";

  type character_cell_type is record
    cell_character : character_type;
    coordinates    : cell_coordinates;
  end record;

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

end package;
