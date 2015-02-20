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

  -- Costanti della risoluzione video
  constant H_PIXELS : integer := 640;
  constant V_PIXELS : integer := 480;

  -----------------------------------------------------------------------------

   -- Sprite Candies
	
	type array_type is array (15 downto 0) of std_logic_vector (15 downto 0); 
	
	constant candy : array_type;

	candy( 0) <= "0000000000000000";
	candy( 1) <= "0000000000000000";
	candy( 2) <= "0000000000000000";
	candy( 3) <= "0000000000000000";
	candy( 4) <= "0000000000000000";
	candy( 5) <= "0000000000000000";
	candy( 6) <= "0000000110000000";
	candy( 7) <= "0000001111000000";
	candy( 8) <= "0000000110000000";
	candy( 9) <= "0000000000000000";
	candy(10) <= "0000000000000000";
	candy(11) <= "0000000000000000";
	candy(12) <= "0000000000000000";
	candy(13) <= "0000000000000000";
	candy(14) <= "0000000000000000";
	candy(15) <= "0000000000000000";

	
	
-- SPRITE FANTASMINI, PACMAN, CARAMELLINE, MURI
-- LETTERE PER LE STRINGHE
-- TIPO SPRITE, TIPO FONT 

  -----------------------------------------------------------------------------

  -- funzioni per la gestione dei 7 segmenti della FPGA
  function int_to7seg (a : integer) return std_logic_vector;

  procedure seg_ctrl (signal number : in integer; signal digit1, digit2, digit3, digit4 : out integer range 0 to 9);

  -----------------------------------------------------------------------------

  function draw_character_pixel (
    character_cell : character_cell_type;
    pixel_row      : integer;
    pixel_col      : integer)
    return color_type;
	 
  function get_from_sprite (
    sprite         : array_type;
    pixel_row      : integer;
    pixel_col      : integer)
  return color_type;
  

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

    variable temp : integer range 0 to 9999;
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
      when PACMAN_CHAR => color_vector := COLOR_YELLOW;
      when GHOST1_CHAR => color_vector := COLOR_RED;
      when GHOST2_CHAR => color_vector := COLOR_CYAN;
      when GHOST3_CHAR => color_vector := COLOR_GREEN;
      when GHOST4_CHAR => color_vector := COLOR_ORANGE;
      when others      => color_vector := get_from_sprite(candy, pixel_row, pixel_col);
    end case;

    return color_vector;
  end function draw_character_pixel;
  
  
-----------------------------------------------------------------------------------------

  function get_from_sprite (
    sprite         : array_type;
    pixel_row      : integer;
    pixel_col      : integer
  )
  return color_type is variable sprite_color : color_type := COLOR_BLACK;
  
  variable i : integer := 0;
  variable j : integer := 0;
  variable sprite_row : std_logic_vector(15 downto 0);
  
  
  begin 
	i:= pixel_row mod CELL_SIZE;
	j:= pixel_col mod CELL_SIZE;
	
	sprite_row := sprite(i);
	
	if(sprite_row(j) = '0') then 
		sprite_color := COLOR_BLACK;
	else 
	  sprite_color := COLOR_WHITE;
	end if;
	
	return sprite_color;
  end function get_from_sprite;
  

end package body view_package;
