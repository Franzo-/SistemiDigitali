library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

entity ImageGenerator is

  port (
    DISP_ENABLE : in std_logic;
    ROW         : in integer;
    COLUMN      : in integer;

    RESPONSE_VIEW                : in  map_cell_type;
    CHARACTERS_COORDINATES_ARRAY : in  character_cell_array;
    --
    RED                          : out std_logic_vector(3 downto 0);
    GREEN                        : out std_logic_vector(3 downto 0);
    BLUE                         : out std_logic_vector(3 downto 0);

    QUERY_VIEW : out cell_coordinates

    );

end entity ImageGenerator;

architecture RTL of ImageGenerator is

  signal color_vector : color_type;
  signal cell_row     : integer range 0 to (MAP_ROWS-1);
  signal cell_col     : integer range 0 to (MAP_COLUMNS-1);

begin  -- architecture RTL

  -- Colora l'immagine pixel per pixel
  ImagePixeling : process (DISP_ENABLE, ROW, COLUMN, RESPONSE_VIEW)

  begin  -- process ImagePixeling

    DisplayEnable : if (DISP_ENABLE = '1') then  --display time

      -- pixel coordinates -----> cell coordinates
      cell_row <= ROW / CELL_SIZE;
      cell_col <= COLUMN / CELL_SIZE;

      MovingParts : if (false) then  -- TODO: Funzione di confronto con parti mobili

      else

        QUERY_VIEW.row <= cell_row;
        QUERY_VIEW.col <= cell_col;

        ResponseView : if (RESPONSE_VIEW.is_wall = '1') then
          color_vector <= COLOR_BLUE;
        elsif (RESPONSE_VIEW.is_candy = '1') then
          color_vector <= COLOR_YELLOW;
        else
          color_vector <= COLOR_BLACK;
        end if ResponseView;

      end if MovingParts;

    else                                --blanking time

      color_vector <= COLOR_BLACK;

    end if DisplayEnable;

    RED   <= color_vector(11 downto 8);
    GREEN <= color_vector(7 downto 4);
    BLUE  <= color_vector(3 downto 0);

  end process ImagePixeling;



end architecture RTL;
