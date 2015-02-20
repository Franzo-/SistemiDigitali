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
      QUERY_VIEW      : in  cell_coordinates;
      REMOVE_CANDY    : in  cell_coordinates;
      --
      RESPONSE_NEARBY : out cell_nearby_content_array;
      RESPONSE_VIEW   : out map_cell_type;
      CANDY_LEFT      : out integer range 0 to 9999
      );

end entity MapEntity;

architecture RTL of MapEntity is
  signal map_board     : map_type;
  signal candy_removal : std_logic;
  signal candy_number : integer range 0 to 9999;

begin

  -- La logica del contatore è in un componente interno
  CandyCounter : entity work.CandyCounter
    port map (
      RESET_N => RESET_N,
      CLK     => CLOCK,
      ENABLE  => candy_removal,
      COUNT   => CANDY_LEFT,
		CANDY_NUMBER => candy_number
      );

  -----------------------------------------------------------------------------

  MapUpdate : process(CLOCK, RESET_N)
    variable selected_cell : map_cell_type;
	 variable accumulator_candy : integer range 0 to 9999;
  begin

    if (RESET_N = '0') then

      candy_removal <= '0';
		accumulator_candy := 0;

      for i in 0 to MAP_ROWS-1 loop
        for j in 0 to MAP_COLUMNS-1 loop

          selected_cell := map_board(i, j);

          if ((i = 0) or (j = 0) or (i = (MAP_ROWS -1)) or (j = (MAP_COLUMNS - 1))) then
            selected_cell.is_candy := '0';
            selected_cell.is_wall  := '1';

          elsif((i-1) mod 4 = 0) then
            selected_cell.is_candy := '1';
            selected_cell.is_wall  := '0';
				accumulator_candy := accumulator_candy + 1;

          elsif((j-1) mod 4 = 0) then
            selected_cell.is_candy := '1';
            selected_cell.is_wall  := '0';
				accumulator_candy := accumulator_candy + 1;

          else
            selected_cell.is_candy := '0';
            selected_cell.is_wall  := '1';

          end if;

          map_board(i, j) <= selected_cell;
        end loop;
      end loop;
		
		candy_number <= accumulator_candy;

    -- L'aggiornamento della mappa è sincrono con il clock di sistema  
    elsif (rising_edge(CLOCK)) then
		  candy_removal <= '0';
        selected_cell := map_board(REMOVE_CANDY.row, REMOVE_CANDY.col);
		  
		  if(selected_cell.is_candy = '1') then 
		      candy_removal <= '1';
				selected_cell.is_candy := '0';
				map_board(REMOVE_CANDY.row, REMOVE_CANDY.col) <= selected_cell;
		  end if;

    end if;

  end process MapUpdate;


  -----------------------------------------------------------------------------

  -- Aggiorna per tutti i personaggi con statements concorrenti
  eachCharacter : for i in QUERY_NEARBY'range generate

    RESPONSE_NEARBY(i).cell_up_content    <= map_board(QUERY_NEARBY(i).cell_up.row, QUERY_NEARBY(i).cell_up.col);
    RESPONSE_NEARBY(i).cell_down_content  <= map_board(QUERY_NEARBY(i).cell_down.row, QUERY_NEARBY(i).cell_down.col);
    RESPONSE_NEARBY(i).cell_left_content  <= map_board(QUERY_NEARBY(i).cell_left.row, QUERY_NEARBY(i).cell_left.col);
    RESPONSE_NEARBY(i).cell_right_content <= map_board(QUERY_NEARBY(i).cell_right.row, QUERY_NEARBY(i).cell_right.col);

  end generate eachCharacter;

  -----------------------------------------------------------------------------

  -- Risposta a query su singola cella con statement concorrente
  RESPONSE_VIEW <= map_board(QUERY_VIEW.row, QUERY_VIEW.col);


end architecture;
