library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

package view_package is

  -- Colori
  subtype color_type is std_logic_vector(11 downto 0);

  constant COLOR_BLACK   : color_type := X"000";
  constant COLOR_WHITE   : color_type := X"FFF";
  constant COLOR_RED     : color_type := X"F00";
  constant COLOR_ORANGE  : color_type := X"F80";
  constant COLOR_GREEN   : color_type := X"0F0";
  constant COLOR_BLUE    : color_type := X"00F";
  constant COLOR_YELLOW  : color_type := X"FF0";
  constant COLOR_CYAN    : color_type := X"0FF";
  constant COLOR_MAGENTA : color_type := X"F0F";

  -----------------------------------------------------------------------------

  -- Pixel per cella
  constant CELL_SIZE : positive := 16;

  -- Costanti della risoluzione video
  constant H_PIXELS : integer := 640;
  constant V_PIXELS : integer := 480;

  -- Margini per centrare la board nello schermo
  constant LEFT_MARGIN : integer := (H_PIXELS/2) - ((MAP_COLUMNS*CELL_SIZE)/2);
  constant TOP_MARGIN  : integer := (V_PIXELS/2) - ((MAP_ROWS*CELL_SIZE)/2);

  -----------------------------------------------------------------------------

  -- Sprite Candies
  -- SPRITE FANTASMINI, PACMAN, CARAMELLINE, MURI
  -- LETTERE PER LE STRINGHE
  -- TIPO SPRITE, TIPO FONT 

  type array_type is array (15 downto 0) of std_logic_vector (15 downto 0);

  constant candy : array_type := (
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

  constant pacman : array_type := (
    "0000000000000000",
    "0000011111100000",
    "0001111111111000",
    "0011111111111100",
    "0111111111111110",
    "1111111111111110",
    "1111111111100000",
    "1111111000000000",
    "1111111000000000",
    "1111111111100000",
    "1111111111111110",
    "0111111111111110",
    "0011111111111100",
    "0001111111111000",
    "0000011111100000",
    "0000000000000000"
    );

  constant ghost : array_type := (
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

  -- funzioni per la gestione dei 7 segmenti della FPGA
  function int_to7seg (a : integer) return std_logic_vector;

  procedure seg_ctrl (signal number : in integer; signal digit1, digit2, digit3, digit4 : out integer range 0 to 9);

  -----------------------------------------------------------------------------

  -- Funzioni per il disegno dei personaggi su VGA
  function draw_character_pixel (
    character_cell : character_cell_type;
    pixel_row      : integer;
    pixel_col      : integer)
    return color_type;

  function get_from_sprite (
    sprite    : array_type;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type)
    return color_type;

  -----------------------------------------------------------------------------

  -- Identifica i pixel interni alla board (mappa + personaggi)
  function is_in_board (
    pixel_row : integer;
    pixel_col : integer)
    return boolean;


end package;

-------------------------------------------------------------------------------

package body view_package is

  function int_to7seg(a : integer) return std_logic_vector is
    variable result : std_logic_vector(6 downto 0);
  begin
    case a is
      when 0      => result := "1000000";
      when 1      => result := "1111001";
      when 2      => result := "0100100";
      when 3      => result := "0110000";
      when 4      => result := "0011001";
      when 5      => result := "0010010";
      when 6      => result := "0000010";
      when 7      => result := "1111000";
      when 8      => result := "0000000";
      when 9      => result := "0010000";
      when others => result := (others => '0');
    end case;

    return result;

  end int_to7seg;

------------------------------------------------------------------------------------

  procedure seg_ctrl (signal number : in integer; signal digit1, digit2, digit3, digit4 : out integer range 0 to 9) is

    variable temp : candy_count_type;
    variable d1   : integer range 0 to 9;
    variable d2   : integer range 0 to 9;
    variable d3   : integer range 0 to 9;
    variable d4   : integer range 0 to 9;

  begin
    temp := number;

    if(temp > 999)then
      d4   := temp/1000;
      temp := temp-d4*1000;
    else
      d4 := 0;
    end if;

    if(temp > 99)then
      d3   := temp/100;
      temp := temp-d3*100;
    else
      d3 := 0;
    end if;

    if(temp > 9)then
      d2   := temp/10;
      temp := temp-d2*10;
    else
      d2 := 0;
    end if;

    d1     := temp;
    digit1 <= d1;
    digit2 <= d2;
    digit3 <= d3;
    digit4 <= d4;

  end seg_ctrl;

-----------------------------------------------------------------------------------------

  -- Restituisce il pixel della sprite del personaggio richiesto
  function draw_character_pixel (
    character_cell : character_cell_type;
    pixel_row      : integer;
    pixel_col      : integer)
    return color_type is variable color_vector : color_type;
  begin

    case character_cell.cell_character is
      when PACMAN_CHAR => color_vector := get_from_sprite(pacman, pixel_row, pixel_col, COLOR_YELLOW);
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
    sprite    : array_type;
    pixel_row : integer;
    pixel_col : integer;
    color     : color_type
    )
    return color_type is variable sprite_color : color_type := COLOR_BLACK;

                         variable i          : integer := 0;
                         variable j          : integer := 0;
                         variable sprite_row : std_logic_vector(15 downto 0);


  begin
    i := pixel_row mod CELL_SIZE;
    j := pixel_col mod CELL_SIZE;

    sprite_row := sprite(i);

    if(sprite_row(j) = '0') then
      sprite_color := COLOR_BLACK;
    else
      sprite_color := color;
    end if;

    return sprite_color;
  end function get_from_sprite;

  -----------------------------------------------------------------------------

  function is_in_board (
    pixel_row : integer;
    pixel_col : integer)
    return boolean is variable in_board : boolean := false;
  begin

    if (pixel_row >= TOP_MARGIN and
        pixel_row < (TOP_MARGIN + (CELL_SIZE * MAP_ROWS)) and
        pixel_col >= LEFT_MARGIN and
        pixel_col < (LEFT_MARGIN + (CELL_SIZE * MAP_COLUMNS))) then
      in_board := true;
    end if;

    return in_board;
  end function is_in_board;


end package body view_package;
