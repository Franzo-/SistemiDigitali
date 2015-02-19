library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity IAGhosts is

  port (
    CLOCK     : in std_logic;
    RESET_N   : in std_logic;
    ENABLE    : in std_logic;
    --segnali che indicano se il ghost puo muoversi nella data direzione
    CAN_MOVES : in can_move;

    --segnali in uscita        
    MOVE_COMMANDS : out move_commands
    );

end entity IAGhosts;

architecture RTL of IAGhosts is

  signal current_direction : ghost_direction;
  signal rnd_count_r       : integer range 0 to 3;

begin

  Ghost_controller : process(CLOCK, RESET_N)

  begin

    if(RESET_N = '0') then
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';
      current_direction        <= IDLE;

    elsif rising_edge(CLOCK) then

      MOVE_COMMANDS.move_down  <= '0';  --monoimpulsori
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';

      if(ENABLE = '1') then
        -- La direzione può cambiare casualmente quando il fantasmino incontra un
        -- incrocio oppure quando è fermo
        CrossroadCheck : if (is_crossroad(current_direction, CAN_MOVES) or
                             current_direction = IDLE) then

          current_direction <= random_direction(rnd_count_r, CAN_MOVES);

        end if CrossroadCheck;

        case current_direction is
          when UP_DIR =>
            if(CAN_MOVES.can_move_up = '1') then
              MOVE_COMMANDS.move_up <= '1';
            else
              MOVE_COMMANDS.move_down <= '1';
            end if;

          when DOWN_DIR =>
            if(CAN_MOVES.can_move_down = '1') then
              MOVE_COMMANDS.move_down <= '1';
            else
              MOVE_COMMANDS.move_up <= '1';
            end if;

          when LEFT_DIR =>
            if(CAN_MOVES.can_move_left = '1') then
              MOVE_COMMANDS.move_left <= '1';
            else
              MOVE_COMMANDS.move_right <= '1';
            end if;

          when RIGHT_DIR =>
            if(CAN_MOVES.can_move_right = '1') then
              MOVE_COMMANDS.move_right <= '1';
            else
              MOVE_COMMANDS.move_left <= '1';
            end if;
			 when OTHERS => 
			   MOVE_COMMANDS.move_up <= '0';
				MOVE_COMMANDS.move_right <= '0';
				MOVE_COMMANDS.move_down <= '0';
				MOVE_COMMANDS.move_left <= '0';
        end case;

      end if;  --ENABLE

    end if;  -- clock

  end process Ghost_controller;

  -------------------------------------------------------------------------

  -- Contatore per la generazione della direzione casuale
  rand_counter : process(RESET_N, CLOCK)
  begin
    if (RESET_N = '0') then
      rnd_count_r <= 0;

    elsif (rising_edge(CLOCK)) then

      if(rnd_count_r /= rnd_count_r'high-1) then
        rnd_count_r <= rnd_count_r + 1;
      else
        rnd_count_r <= 0;
      end if;

    end if;
  end process rand_counter;

end architecture;
