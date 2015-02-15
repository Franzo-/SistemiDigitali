library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity MapEntity is
  port
    (
      CLOCK           : in  std_logic;
      RESET_N         : in  std_logic;
      QUERY_NEARBY    : in  cell_nearby_array;
      QUERY_CANDY : in cell_coordinates;
      QUERY_VIEW : in cell_coordinates;
      REMOVE_CANDY    : in  cell_coordinates;
      --
      RESPONSE_NEARBY : out cell_nearby_content_array;
      RESPONSE_CANDY : out map_cell_type;
      RESPONSE_VIEW : out map_cell_type;
      CANDY_LEFT      : out integer range 0 to (MAX_CANDIES-1)
      );

end entity MapEntity;

architecture RTL of MapEntity is
  signal map_board     : map_type;
  signal candy_removal : std_logic;

begin

  -- La logica del contatore è in un componente interno
  CandyCounter : entity work.CandyCounter
    port map (
      RESET_N => RESET_N,
      CLK     => CLOCK,
      ENABLE  => candy_removal,
      COUNT   => CANDY_LEFT
      );

  -----------------------------------------------------------------------------

  MapUpdate : process(CLOCK, RESET_N)
    variable selected_cell : map_cell_type;
  begin

    if (RESET_N = '0') then

      candy_removal <= '0';

      for i in 0 to MAP_ROWS-1 loop
        for j in 0 to MAP_COLUMNS-1 loop
        -- TODO: logica incredibile per creazione mappa
        end loop;
      end loop;

    -- L'aggiornamento della mappa è sincrono con il clock di sistema  
    elsif (rising_edge(CLOCK)) then
      if (candy_removal = '1') then
        selected_cell                                 := map_board(REMOVE_CANDY.row, REMOVE_CANDY.col);
        selected_cell.is_candy                        := '0';
        map_board(REMOVE_CANDY.row, REMOVE_CANDY.col) <= selected_cell;
        candy_removal                                 <= '0';
      end if;
    end if;

  end process MapUpdate;

  -----------------------------------------------------------------------------

  -- Aggiorna per tutti i personaggi
  QueryNearby : process(QUERY_NEARBY, map_board)
  begin

    eachCharacter : for character in QUERY_NEARBY'range loop

      RESPONSE_NEARBY(character).cell_up_content    <= map_board(QUERY_NEARBY(character).cell_up.row, QUERY_NEARBY(character).cell_up.col);
      RESPONSE_NEARBY(character).cell_down_content  <= map_board(QUERY_NEARBY(character).cell_down.row, QUERY_NEARBY(character).cell_down.col);
      RESPONSE_NEARBY(character).cell_left_content  <= map_board(QUERY_NEARBY(character).cell_left.row, QUERY_NEARBY(character).cell_left.col);
      RESPONSE_NEARBY(character).cell_right_content <= map_board(QUERY_NEARBY(character).cell_right.row, QUERY_NEARBY(character).cell_right.col);

    end loop eachCharacter;

  end process QueryNearby;

  -----------------------------------------------------------------------------

  -- Risposta a query su singola cella
  SingleCellQuery: process (QUERY_CANDY, QUERY_VIEW) is
  begin
    RESPONSE_CANDY <= map_board(QUERY_CANDY.row, QUERY_CANDY.col);
    RESPONSE_VIEW <=  map_board(QUERY_VIEW.row, QUERY_VIEW.col);
  end process SingleCellQuery;

  -----------------------------------------------------------------------------

  -- Segnala internamente al process sincrono di rimuovere la caramellina
  RemoveCandy : process(REMOVE_CANDY)
  begin
    candy_removal <= '1';
  end process RemoveCandy;

end architecture;
