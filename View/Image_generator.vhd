library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

entity ImageGenerator is

  port (
    -- Inputs
    DISP_ENABLE                  : in std_logic;
    ROW                          : in integer;
    COLUMN                       : in integer;
    --
    CELL_CONTENT                 : in map_cell_type;
    CHARACTERS_COORDINATES_ARRAY : in character_cell_array;
    --
    MOUTH_OPEN                   : in std_logic;
    PACMAN_DIRECTION             : in character_direction;
    --
    CURRENT_STATE                : in state_controller_type;

    -- Outputs
    RED        : out std_logic_vector(3 downto 0);
    GREEN      : out std_logic_vector(3 downto 0);
    BLUE       : out std_logic_vector(3 downto 0);
    --
    QUERY_CELL : out cell_coordinates

    );

end entity ImageGenerator;

-------------------------------------------------------------------------------

architecture RTL of ImageGenerator is

  signal color_vector : color_type;
  signal cell_row     : integer range 0 to (MAP_ROWS-1);
  signal cell_col     : integer range 0 to (MAP_COLUMNS-1);

begin  -- architecture RTL

  -- Colora l'immagine pixel per pixel
  ImagePixeling : process (DISP_ENABLE, ROW, COLUMN, CELL_CONTENT, CHARACTERS_COORDINATES_ARRAY)

    variable tmp_character : character_cell_type;
    variable is_map_pixel  : boolean;

  begin  -- process ImagePixeling

    DisplayEnable : if (DISP_ENABLE = '1') then  --display time

      BoardPixel : if (is_in_board(ROW, COLUMN)) then
        is_map_pixel := true;

        -- pixel coordinates -----> cell coordinates
        cell_row <= (ROW - TOP_MARGIN) / CELL_SIZE;
        cell_col <= (COLUMN - LEFT_MARGIN) / CELL_SIZE;

        -- Prima si controlla se il pixel fa parte della cella occupata da un personaggio
        CharacterPixel : for i in CHARACTERS_COORDINATES_ARRAY'range loop

          tmp_character := CHARACTERS_COORDINATES_ARRAY(i);

          if ((tmp_character.coordinates.row = cell_row) and
              (tmp_character.coordinates.col = cell_col)) then
            color_vector <= draw_character_pixel(tmp_character, ROW - TOP_MARGIN, COLUMN - LEFT_MARGIN, MOUTH_OPEN, PACMAN_DIRECTION);
            is_map_pixel := false;
          end if;

        end loop CharacterPixel;

        -- Se la cella non ha un personaggio, si disegna il contenuto della mappa
        MapPixel : if (is_map_pixel) then

          QUERY_CELL.row <= cell_row;
          QUERY_CELL.col <= cell_col;

          if (CELL_CONTENT.is_wall = '1') then
            color_vector <= COLOR_BLUE;
          elsif (CELL_CONTENT.is_candy = '1') then
            color_vector <= get_from_sprite(candy, ROW - TOP_MARGIN, COLUMN - LEFT_MARGIN, COLOR_WHITE);
          else
            color_vector <= COLOR_BLACK;
          end if;

        end if MapPixel;

      elsif (is_in_message_board(ROW, COLUMN, CURRENT_STATE)) then
        color_vector <= draw_letter_pixel(CURRENT_STATE, ROW, COLUMN);
      else

        color_vector <= COLOR_BLACK;

      end if BoardPixel;

    else                                --blanking time

      color_vector <= COLOR_BLACK;

    end if DisplayEnable;

    -- Color assignments
    RED   <= color_vector(11 downto 8);
    GREEN <= color_vector(7 downto 4);
    BLUE  <= color_vector(3 downto 0);

  end process ImagePixeling;

end architecture RTL;
