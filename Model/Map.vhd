library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity map_entity is
  port
    (
      CLOCK : in std_logic;
      RESET_N : in std_logic;

      -- Query sul contenuto delle celle
      QUERY_CELL : in cell_coordinates;
      CELL_CONTENT : out map_cell_type;

      -- Rimuove una caramellina su richiesta del controller
      REMOVE_CANDY : in cell_coordinates
      
);
  
end entity map_entity;

architecture RTL of map_entity is
  signal map_board : map_type;
  variable candy_removal : std_logic := '0';

begin

  MapUpdate : process(CLOCK, RESET_N)
    variable selected_cell : map_cell_type;    
  begin

    if (RESET_N = '0') then

      for i in 0 to MAP_ROWS-1 loop
        for j in 0 to MAP_COLUMNS-1 loop
          -- TODO: logica incredibile per creazione mappa
        end loop;
      end loop;

    -- L'aggiornamento della mappa è sincrono con il clock di sistema  
    elsif (rising_edge(CLOCK)) then
      if (candy_removal = '1') then
        selected_cell := map_board(REMOVE_CANDY.row, REMOVE_CANDY.col);
        selected_cell.is_candy := '0';
        map_board(REMOVE_CANDY.row, REMOVE_CANDY.col) <= selected_cell;
        candy_removal := '0';
    end if;

  end process MapUpdate;

  
  QueryCell : process(QUERY_CELL, map_board)
    variable selected_cell : map_cell_type;
  begin
    CELL_CONTENT.is_wall <= '0';
    CELL_CONTENT.is_candy <= '0';

    selected_cell := map_board(QUERY_CELL.row, QUERY_CELL.col);

    CELL_CONTENT <= selected_cell;

  end process QueryCell;


  -- Segnala internamente al process sincrono di rimuovere la caramellina
  RemoveCandy : process(REMOVE_CANDY)
  begin
    candy_removal := '1';
  end process RemoveCandy;

end architecture;
