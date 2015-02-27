library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.controller_package.all;

entity IAGhosts is
  generic (
    INDEX : integer := 1
    );

  port (
    CLOCK                 : in std_logic;
    RESET_N               : in std_logic;
    ENABLE                : in std_logic;
    TIMER_MOVE            : in std_logic;
    CHARACTER_COORDINATES : in cell_coordinates;

    --segnali che indicano se il ghost puo muoversi nella data direzione
    CAN_MOVES : in can_move;

    --segnali in uscita        
    MOVE_COMMANDS : out move_commands

    );

end entity IAGhosts;

architecture RTL of IAGhosts is

  signal rnd_count_r : integer;

begin

  Ghost_controller : process(CLOCK, RESET_N)

    variable current_direction : character_direction;

  begin

    if(RESET_N = '0') then
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';
      current_direction        := IDLE;

    elsif rising_edge(CLOCK) then

      MOVE_COMMANDS.move_down  <= '0';  --monoimpulsori
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';

      if (ENABLE = '1' and TIMER_MOVE = '1') then
        -- La direzione può cambiare casualmente quando il fantasmino incontra un
        -- incrocio oppure quando è fermo
        CrossroadCheck : if (is_crossroad(current_direction, CAN_MOVES) or current_direction = IDLE) then

          current_direction := random_direction(rnd_count_r, CAN_MOVES, CHARACTER_COORDINATES, INDEX);

        end if CrossroadCheck;

        case current_direction is
          when UP_DIR =>
            if(CAN_MOVES.can_move_up = '1') then
              MOVE_COMMANDS.move_up <= '1';
            else
              MOVE_COMMANDS.move_down <= '1';
              current_direction       := DOWN_DIR;
            end if;

          when DOWN_DIR =>
            if(CAN_MOVES.can_move_down = '1') then
              MOVE_COMMANDS.move_down <= '1';
            else
              MOVE_COMMANDS.move_up <= '1';
              current_direction     := UP_DIR;
            end if;

          when LEFT_DIR =>
            if(CAN_MOVES.can_move_left = '1') then
              MOVE_COMMANDS.move_left <= '1';
            else
              MOVE_COMMANDS.move_right <= '1';
              current_direction        := RIGHT_DIR;
            end if;

          when RIGHT_DIR =>
            if(CAN_MOVES.can_move_right = '1') then
              MOVE_COMMANDS.move_right <= '1';
            else
              MOVE_COMMANDS.move_left <= '1';
              current_direction       := LEFT_DIR;
            end if;

          when IDLE => null;

        end case;

      end if;  --ENABLE

    end if;  -- clock

  end process Ghost_controller;

  -------------------------------------------------------------------------

  -- Random number generator
  process(CLOCK)

    variable rand_temp : std_logic_vector(31 downto 0) := (31 => '1', others => '0');
    variable temp      : std_logic                     := '0';

  begin

    if(rising_edge(CLOCK)) then
      temp                   := rand_temp(31) xor rand_temp(30);
      rand_temp(31 downto 1) := rand_temp(30 downto 0);
      rand_temp(0)           := temp;
    end if;

    rnd_count_r <= to_integer(unsigned (rand_temp));

  end process;

end architecture;
