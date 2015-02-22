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
  constant CELL_SIZE        : positive := 16;
  constant CELL_STRING_SIZE : positive := CELL_SIZE*2;

  -- Costanti della risoluzione video
  constant H_PIXELS : integer := 640;
  constant V_PIXELS : integer := 480;

  -- Margini per centrare la board nello schermo
  constant LEFT_MARGIN : integer := (H_PIXELS/2) - ((MAP_COLUMNS*CELL_SIZE)/2);
  constant TOP_MARGIN  : integer := (V_PIXELS/2) - ((MAP_ROWS*CELL_SIZE)/2);

  -- Lunghezza massima dei messaggi testuali
  constant MAX_MESSAGE_LENGTH : integer := 10;

  -- Margini per centrare i messaggi testuali
  constant TOP_MARGIN_MESSAGE  : integer := (TOP_MARGIN + (CELL_SIZE * MAP_ROWS)) + CELL_STRING_SIZE;
  constant LEFT_MARGIN_MESSAGE : integer := (H_PIXELS/2) - (MAX_MESSAGE_LENGTH/2 * CELL_STRING_SIZE);
  
  -- Margini per centrare il titolo
  constant TOP_MARGIN_TITLE : integer := TOP_MARGIN - (CELL_STRING_SIZE + CELL_STRING_SIZE/2);
  constant LEFT_MARGIN_TITLE : integer := (H_PIXELS/2) - (MAX_MESSAGE_LENGTH/2 * CELL_STRING_SIZE);

  -----------------------------------------------------------------------------

  -- Identifica i pixel interni alla board (mappa + personaggi)
  function is_in_board (
    pixel_row : integer;
    pixel_col : integer)
    return boolean;

  -- Identifica i pixel dei messaggi
  function is_in_message_board (
    pixel_row  : integer;
    pixel_col  : integer;
    game_state : state_controller_type)
    return boolean;
	 
  function is_in_title (
    pixel_row  : integer;
    pixel_col  : integer)
    return boolean;

end package;

-------------------------------------------------------------------------------

package body view_package is

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

  -----------------------------------------------------------------------------

  function is_in_message_board (
    pixel_row  : integer;
    pixel_col  : integer;
    game_state : state_controller_type)
    return boolean is variable in_message_board : boolean := false;

  begin

    Rows : if (pixel_row >= TOP_MARGIN_MESSAGE and
               pixel_row < (TOP_MARGIN_MESSAGE + CELL_STRING_SIZE)) then

      Cols : if (pixel_col >= LEFT_MARGIN_MESSAGE and
                 pixel_col < (LEFT_MARGIN_MESSAGE + (MAX_MESSAGE_LENGTH * CELL_STRING_SIZE))) then
        in_message_board := true;
      end if Cols;

    end if Rows;

    return in_message_board;
  end function is_in_message_board;
  
   -----------------------------------------------------------------------------
	
    function is_in_title (
		pixel_row  : integer;
		pixel_col  : integer)
		return boolean is variable in_title : boolean := false;
	 
	 begin
	 
	   Rows : if (pixel_row >= TOP_MARGIN_TITLE and
               pixel_row < (TOP_MARGIN_TITLE + CELL_STRING_SIZE)) then

      Cols : if (pixel_col >= LEFT_MARGIN_TITLE and
                 pixel_col < (LEFT_MARGIN_TITLE + (MAX_MESSAGE_LENGTH * CELL_STRING_SIZE))) then
        in_title := true;
      end if Cols;

    end if Rows;

	     return in_title;
  end function is_in_title;

end package body view_package;
