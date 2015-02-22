library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

package sprite_package is

  -- Tipo sprite
  type sprite_matrix is array (0 to CELL_SIZE-1) of std_logic_vector (0 to CELL_SIZE-1);

  constant candy : sprite_matrix := (
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000110000000",
    "0000001111000000",
    "0000000110000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000"
    );

  constant pacman_opened : sprite_matrix := (
    "0000000000000000",
    "0000011111100000",
    "0001111111111000",
    "0011111111111100",
    "0111111111111100",
    "1111111111110000",
    "1111111110000000",
    "1111111000000000",
    "1111111000000000",
    "1111111110000000",
    "1111111111110000",
    "0111111111111100",
    "0011111111111100",
    "0001111111111000",
    "0000011111100000",
    "0000000000000000"
    );

  constant pacman_closed : sprite_matrix := (
    "0000000000000000",
    "0000011111100000",
    "0001111111111000",
    "0011111111111100",
    "0111111111111110",
    "1111111111111110",
    "1111111111111110",
    "1111111111111110",
    "1111111110000000",
    "1111111111111110",
    "1111111111111110",
    "0111111111111110",
    "0011111111111100",
    "0001111111111000",
    "0000011111100000",
    "0000000000000000"
    );

  constant ghost : sprite_matrix := (
    "0000000000000000",
    "0000111111110000",
    "0111111111111110",
    "1111111111111111",
    "1111111111111111",
    "1111000111100011",
    "1111000111100011",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "1101111001111011",
    "1000110000110001"
    );

  -----------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Funzioni per il disegno dei personaggi su VGA
-------------------------------------------------------------------------------

  function draw_character_pixel (
    character_cell   : character_cell_type;
    pixel_row        : integer;
    pixel_col        : integer;
    pacman_mouth     : std_logic;
    pacman_direction : character_direction)
    return color_type;

  function get_from_sprite (
    sprite    : sprite_matrix;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type)
    return color_type;

  function get_from_pacman_sprite (
    sprite    : sprite_matrix;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type;
    direction : character_direction
    )
    return color_type;

  -----------------------------------------------------------------------------

end package sprite_package;

package body sprite_package is

  -- Restituisce il pixel della sprite del personaggio richiesto
  function draw_character_pixel (
    character_cell   : character_cell_type;
    pixel_row        : integer;
    pixel_col        : integer;
    pacman_mouth     : std_logic;
    pacman_direction : character_direction)
    return color_type is variable color_vector : color_type;
  begin

    case character_cell.cell_character is
      when PACMAN_CHAR =>
        if (pacman_mouth = '1') then
          color_vector := get_from_pacman_sprite(pacman_opened, pixel_row, pixel_col, COLOR_YELLOW, pacman_direction);
        else
          color_vector := get_from_pacman_sprite(pacman_closed, pixel_row, pixel_col, COLOR_YELLOW, pacman_direction);
        end if;

      when GHOST1_CHAR => color_vector := get_from_sprite(ghost, pixel_row, pixel_col, COLOR_RED);
      when GHOST2_CHAR => color_vector := get_from_sprite(ghost, pixel_row, pixel_col, COLOR_CYAN);
      when GHOST3_CHAR => color_vector := get_from_sprite(ghost, pixel_row, pixel_col, COLOR_GREEN);
      when GHOST4_CHAR => color_vector := get_from_sprite(ghost, pixel_row, pixel_col, COLOR_ORANGE);
      when others      => color_vector := COLOR_BLACK;
    end case;

    return color_vector;
  end function draw_character_pixel;

-----------------------------------------------------------------------------------------

  function get_from_sprite (
    sprite    : sprite_matrix;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type
    )
    return color_type is variable sprite_color : color_type := COLOR_BLACK;

                         variable i : integer := 0;
                         variable j : integer := 0;

  begin
    i := pixel_row mod CELL_SIZE;
    j := pixel_col mod CELL_SIZE;

    if(sprite(i)(j) = '0') then
      sprite_color := COLOR_BLACK;
    else
      sprite_color := color;
    end if;

    return sprite_color;
  end function get_from_sprite;

  -----------------------------------------------------------------------------

  function get_from_pacman_sprite (
    sprite    : sprite_matrix;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type;
    direction : character_direction
    )
    return color_type is variable sprite_color : color_type := COLOR_BLACK;

                         variable i : integer := 0;
                         variable j : integer := 0;
  begin

    case direction is

      when DOWN_DIR => i := (CELL_SIZE-1) - (pixel_col mod CELL_SIZE);
                       j := pixel_row mod CELL_SIZE;

      when UP_DIR => i := (CELL_SIZE-1) - (pixel_col mod CELL_SIZE);
                     j := (CELL_SIZE-1) - (pixel_row mod CELL_SIZE);

      when RIGHT_DIR => i := pixel_row mod CELL_SIZE;
                        j := pixel_col mod CELL_SIZE;

      when LEFT_DIR => i := pixel_row mod CELL_SIZE;
                       j := (CELL_SIZE-1) - (pixel_col mod CELL_SIZE);

      when others => null;

    end case;

    if(sprite(i)(j) = '0') then
      sprite_color := COLOR_BLACK;
    else
      sprite_color := color;
    end if;

    return sprite_color;
  end function get_from_pacman_sprite;

  -----------------------------------------------------------------------------

end package body sprite_package;
