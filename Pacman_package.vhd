library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package pacman_package is

  -- Constants
  constant MAP_COLUMNS          : positive := 21;  -- cells
  constant MAP_ROWS             : positive := 21;  -- cells
  constant NUMBER_OF_CHARACTERS : positive := 5;   -- pacman + ghosts
  
  -- Tipo per la mapPA
  
  type map_matrix is array (0 to MAP_ROWS - 1) of std_logic_vector (0 to MAP_COLUMNS - 1);
  
  -- Mappa 
  constant MAPPA  : map_matrix :=  (
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

  type can_move_array is array (0 to (NUMBER_OF_CHARACTERS-1)) of can_move;

  ------------------------------------------------------------------------------

  -- Intelligenza dei fantasmini
  type character_direction is (UP_DIR, DOWN_DIR, LEFT_DIR, RIGHT_DIR, IDLE);

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

  -- enumerativi che indicano la stringa che  l'automa passa alla view (la stringa indica in che stato siamo)
  type state_controller_type is (START_SCREEN, PLAYING, PAUSE, WIN, GAME_OVER);

-----------------------------------------------------------------------------    
end package;

package body pacman_package is

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


-----------------------------------------------------------------------------------------

end package body pacman_package;
