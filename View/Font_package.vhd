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
  constant WIN_MESSAGE       : message_type := (space, space, space, w, i, n, space, space, space, space);
  constant PAUSE_MESSAGE     : message_type := (space, space, p, a, u, s, e, space, space, space);
  constant START_MESSAGE     : message_type := (s, t, a, r, t, space, g, a, m, e);
  constant GAME_OVER_MESSAGE : message_type := (g, a, m, e, space, o, v, e, r, space);

  -- Lettere
  function init_a (bold : integer range 0 to 5) return font_matrix;
  constant BOLD         : integer     := 2;
  constant  a        : font_matrix := init_a(BOLD);
  constant  w			: font_matrix;
  constant  i			: font_matrix;
  constant  n			: font_matrix;
  constant  p			: font_matrix;
  constant  u			: font_matrix;
  constant  s			: font_matrix;
  constant  e			: font_matrix;
  constant  t			: font_matrix;
  constant  r			: font_matrix;
  constant  g			: font_matrix;
  constant  m			: font_matrix;
  constant  v			: font_matrix;
  constant  o			: font_matrix;
  constant  space			: font_matrix;


  -----------------------------------------------------------------------------

  -- Sceglie il pixel dalla stringa associata allo stato di gioco
  function draw_letter_pixel (
    game_state : state_controller_type;
    pixel_row  : integer;
    pixel_col  : integer)
    return color_type;
	 
	 
--funzione che prende in ingresso il messaggio da visualizzare e seleziona a sua volta la lettera da stampare,
--mandandola come input della funzione get_from_letter	 
  function get_from_string (
	  message   : message_type;
	  pixel_row : integer;
	  pixel_col : integer;
	  color		: color_type )
	 return color_type; 
	 
	 
--funzione che prende in ingresso la sprite della lettera da stampare e restituisce il colore del pixel corrente	 
	function get_from_letter(
	  selected_letter  : font_matrix;
	  pixel_row        : integer;
	  pixel_col        : integer;
	  color				 : color_type)
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

	 case game_state is
	   when PAUSE        => color_vector := get_from_string(PAUSE_MESSAGE,pixel_row,pixel_col,COLOR_MAGENTA);
		when GAME_OVER    => color_vector := get_from_string(GAME_OVER_MESSAGE,pixel_row,pixel_col,COLOR_RED);
		when START_SCREEN => color_vector := get_from_string(START_MESSAGE,pixel_row,pixel_col,COLOR_GREEN);
		when PLAYING      => color_vector := COLOR_BLACK;
		when WIN          => color_vector := get_from_string(PAUSE_MESSAGE,pixel_row,pixel_col,COLOR_CYAN);
		when others       => color_vector := COLOR_BLACK;
	 end case;
	 

    return color_vector;
  end function draw_letter_pixel;
  
 ------------------------------------------------------------------------------------
 
   function get_from_string (
	  message   : message_type; --è fatto di un certo numero di font_matrix
	  pixel_row : integer;
	  pixel_col : integer;
	  color		: color_type )
	 return color_type is variable color_vector: color_type;
	 
	 variable j   : integer := 0;

	begin
		j := pixel_col / CELL_STRING_SIZE; --con la divisione andiamo a selezionare la cella del messaggio 
		
		color_vector := get_from_letter(message(j), pixel_row, pixel_col, color); --message(i) seleziona la particolare lettera
		
		return color_vector;
	end function get_from_string;	
  

  -----------------------------------------------------------------------------
  	function get_from_letter(
	  selected_letter  : font_matrix;
	  pixel_row        : integer;
	  pixel_col        : integer;
	  color				 : color_type)
	  return color_type is variable color_vector: color_type;
	 
	 variable i   : integer := 0;
    variable j   : integer := 0;
	 
	 
	 begin 
	 i := pixel_row mod CELL_STRING_SIZE; -- con il modulo andiamo a selezionare gli indici della sprite della lettera
	 j := pixel_col mod CELL_STRING_SIZE;
	 
	 if(selected_letter(i)(j) = '0') then
	   color_vector := COLOR_BLACK;
	 else
		color_vector := color ;
	 end if;	
	 
	 return color_vector;
	 end function get_from_letter;
	  
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
