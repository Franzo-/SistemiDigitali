library ieee;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

package model_package is

  -- Tipo per la mappa

  type map_matrix is array (0 to MAP_ROWS - 1) of std_logic_vector (0 to MAP_COLUMNS - 1);

  -- Mappa 
  constant MAPPA : map_matrix := (
    "111111111111111111111",
    "100000000000000000001",
    "101011111111111110101",
    "100000000000000000001",
    "101011101111101110101",
    "101010000010000010101",
    "101010111010111010101",
    "101000100000001000101",
    "101010101101101010101",
    "101010001000100010101",
    "101011100000001110101",
    "101010001000100010101",
    "101010101101101010101",
    "101000100000001000101",
    "101010111010111010101",
    "101010000010000010101",
    "101011101111101110101",
    "100000000000000000001",
    "101011111111111110101",
    "100000000000000000001",
    "111111111111111111111"

    );


  -----------------------------------------------------------------------------

  -- Coordinates at reset

  type reset_position_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of cell_coordinates;

  constant RESET_POS : reset_position_array := (
    (col => (MAP_COLUMNS - 1)/2, row => (MAP_ROWS - 1)/2),
    (col => 1, row => 1),
    (col => MAP_COLUMNS - 2, row => 1),
    (col => 1, row => MAP_ROWS - 2),
    (col => MAP_COLUMNS - 2, row => MAP_ROWS - 2)
    );

  -----------------------------------------------------------------------------

end package model_package;
