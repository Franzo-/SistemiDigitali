library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

package font_package is

  -- TIPO FONT
  type font_matrix is array (0 to CELL_STRING_SIZE-1) of std_logic_vector (0 to CELL_STRING_SIZE-1);

  type message_type is array (0 to MAX_MESSAGE_LENGTH-1) of font_matrix;

  -- Messaggi
--  constant WIN_MESSAGE       : message_type := (space, space, space, w, i, n, space, space, space, space);
--  constant PAUSE_MESSAGE     : message_type := (space, space, p, a, u, s, e, space, space, space);
--  constant START_MESSAGE     : message_type := (s, t, a, r, t, space, g, a, m, e);
--  constant GAME_OVER_MESSAGE : message_type := (g, a, m, e, space, o, v, e, r, space);

  -- Lettere
  function init_a (bold : integer range 0 to 5) return font_matrix;
  constant BOLD         : integer     := 2;
  constant a            : font_matrix := init_a(BOLD);


  -----------------------------------------------------------------------------

  -- Sceglie il pixel dalla stringa associata allo stato di gioco
  function draw_letter_pixel (
    game_state : state_controller_type;
    pixel_row  : integer;
    pixel_col  : integer)
    return color_type;

end package font_package;

-------------------------------------------------------------------------------

package body font_package is

  function draw_letter_pixel (
    game_state : state_controller_type;
    pixel_row  : integer;
    pixel_col  : integer)
    return color_type is variable color_vector : color_type;
  begin

--	 case game_state is
--	   when PAUSE        =>
--		when GAME_OVER    =>
--		when START_SCREEN =>
--		when PLAYING      => color_vector := COLOR_BLACK;
--		when WIN          =>
--		when others       => color_vector := COLOR_BLACK;
--	 end case;
	 
	 
--	 if(game_state = PAUSE) then 
--		 if (a(pixel_row mod CELL_STRING_SIZE)(pixel_col mod CELL_STRING_SIZE) = '1') then
--			color_vector := COLOR_WHITE;
--		 else 
--		   color_vector := COLOR_BLACK;
--	    end if;
--    else
--			color_vector := COLOR_BLACK;
--	 end if;

    return color_vector;
  end function draw_letter_pixel;

  -----------------------------------------------------------------------------

  function init_a(bold : integer range 0 to 5) return font_matrix is
    variable temp : font_matrix;

  begin

    aLetterRow : for i in 0 to (CELL_STRING_SIZE-1) loop
      aLetterCol : for j in 0 to (CELL_STRING_SIZE-1) loop

        temp(i)(j) := '0';

        if (i <= BOLD or (i <= ((CELL_STRING_SIZE-1)/2 + BOLD/2) and i >= ((CELL_STRING_SIZE-1)/2 - BOLD/2))) then
          if(j /= 0 and j /= CELL_STRING_SIZE-1) then
            temp(i)(j) := '1';
          end if;
        end if;

        if (j <= BOLD or (j >= (CELL_STRING_SIZE-2 - BOLD) and j <= CELL_STRING_SIZE-2)) then
          temp(i)(j) := '1';
        end if;
      end loop aLetterCol;
    end loop aLetterRow;

    return temp;
  end function init_a;

end package body font_package;
