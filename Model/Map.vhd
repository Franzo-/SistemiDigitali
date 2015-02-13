library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity MapEntity is
  port
    (
      CLOCK   : in std_logic;
      RESET_N : in std_logic;

      -- Query sul contenuto delle celle
      QUERY_NEARBY   : in  cell_nearby;
      RESPONSE_NEARBY : out cell_nearby_content;

      -- Rimuove una caramellina su richiesta del controller
      REMOVE_CANDY         : in cell_coordinates;
      UPDATE_CANDY_COUNTER : in std_logic;

      -- Valori del contatore di caramelline
      CANDY_LEFT : out integer range 0 to (MAX_CANDIES-1);
      SCORE      : out integer range 0 to (MAX_CANDIES-1)
      );

end entity MapEntity;

architecture RTL of MapEntity is
  signal map_board     : map_type;
  signal candy_removal : std_logic;

begin

  CandyCounter : entity work.CandyCounter
    port map (
      RESET_N => RESET_N;
      CLK     => CLOCK;
      ENABLE  => UPDATE_CANDY_COUNTER;
      COUNT   => CANDY_LEFT;
      SCORE   => SCORE
      );

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


  QueryNearby : process(QUERY_NEARBY, map_board)
    
  variable selected_cell_up : map_cell_type;
  variable selected_cell_down : map_cell_type;
  variable selected_cell_left : map_cell_type;
  variable selected_cell_right : map_cell_type;
	 
  begin
  
    RESPONSE_NEARBY.cell_up_content.is_wall <= '0';
	 RESPONSE_NEARBY.cell_down_content.is_wall <= '0';
	 RESPONSE_NEARBY.cell_left_content.is_wall <= '0';
	 RESPONSE_NEARBY.cell_right_content.is_wall <= '0';
	 
    RESPONSE_NEARBY.cell_up_content.is_candy <= '0';
	 RESPONSE_NEARBY.cell_down_content.is_candy <= '0';
	 RESPONSE_NEARBY.cell_left_content.is_candy <= '0';
	 RESPONSE_NEARBY.cell_right_content.is_candy <= '0';
	 
    selected_cell_up := map_board(QUERY_NEARBY.cell_up.row, QUERY_NEARBY.cell_up.col);
	 selected_cell_down := map_board(QUERY_NEARBY.cell_down.row, QUERY_NEARBY.cell_down.col);
	 selected_cell_left := map_board(QUERY_NEARBY.cell_left.row, QUERY_NEARBY.cell_left.col);
	 selected_cell_right := map_board(QUERY_NEARBY.cell_right.row, QUERY_NEARBY.cell_right.col);
	 
	 RESPONSE_NEARBY.cell_up <= selected_cell_up;
    RESPONSE_NEARBY.cell_down <= selected_cell_down;
	 RESPONSE_NEARBY.cell_left <= selected_cell_left;
	 RESPONSE_NEARBY.cell_right <= selected_cell_right;

  end process QueryNearby;


  -- Segnala internamente al process sincrono di rimuovere la caramellina
  RemoveCandy : process(REMOVE_CANDY)
  begin
    candy_removal <= '1';
  end process RemoveCandy;

end architecture;
