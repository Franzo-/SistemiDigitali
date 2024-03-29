-- TOP LEVEL CONTROLLER

library ieee;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.controller_package.all;

entity ControllerTopLevel is
  port (

    -- segnali di ingresso
    RESET_N                     : in std_logic;
    CLK                         : in std_logic;
    BUTTON_UP                   : in std_logic;
    BUTTON_DOWN                 : in std_logic;
    BUTTON_RIGHT                : in std_logic;
    BUTTON_LEFT                 : in std_logic;
    PAUSE                       : in std_logic;
    CANDY_LEFT                  : in candy_count_type;
    CHARACTER_COORDINATES_ARRAY : in character_cell_array;
    RESPONSE_NEARBY_ARRAY       : in cell_nearby_content_array;

    -- segnali di uscita
    REMOVE_CANDY        : out cell_coordinates;
    QUERY_NEARBY_ARRAY  : out cell_nearby_array;
    MOVE_COMMANDS_ARRAY : out move_commands_array;
    CURRENT_STATE       : out state_controller_type;
    MOUTH_OPEN          : out std_logic;
    PACMAN_DIRECTION    : out character_direction

    );

end entity ControllerTopLevel;

architecture Structural of ControllerTopLevel is

  signal can_moves_array  : can_move_array;
  signal game_over        : std_logic;
  signal win              : std_logic;
  signal enable           : std_logic;
  signal timer_move       : std_logic;
  signal timer_move_ghost : std_logic;

begin  -- architecture Structural

  Eating_controller : entity work.Eating_controller
    port map (
      RESET_N                => RESET_N,
      CLOCK                  => CLK,
      CHARACTERS_COORDINATES => CHARACTER_COORDINATES_ARRAY,
      CANDY_LEFT             => CANDY_LEFT,
      GAME_OVER              => game_over,
      WIN                    => win,
      REMOVE_CANDY           => REMOVE_CANDY

      );

-----------------------------------------------------------------------------

  Pacman_controller : entity work.Pacman_controller
    port map (
      RESET_N          => RESET_N,
      CLOCK            => CLK,
      TIMER_MOVE       => timer_move,
      BUTTON_UP        => BUTTON_UP,
      BUTTON_DOWN      => BUTTON_DOWN,
      BUTTON_RIGHT     => BUTTON_RIGHT,
      BUTTON_LEFT      => BUTTON_LEFT,
      CAN_MOVES        => can_moves_array(0),
      MOVE_COMMANDS    => MOVE_COMMANDS_ARRAY(0),
      ENABLE           => enable,
      MOUTH_OPEN       => MOUTH_OPEN,
      PACMAN_DIRECTION => PACMAN_DIRECTION
      );

-----------------------------------------------------------------------------


  CollisionEntityIteration : for i in 0 to (NUMBER_OF_CHARACTERS - 1) generate

    CollisionDetection : entity work.CollisionDetection
      port map (
        CHARACTER_COORDINATES => CHARACTER_COORDINATES_ARRAY(i).coordinates,
        RESPONSE              => RESPONSE_NEARBY_ARRAY(i),
        QUERY                 => QUERY_NEARBY_ARRAY(i),
        CAN_MOVES             => can_moves_array(i)

        );

  end generate;

-----------------------------------------------------------------------------

  IAEntityIteration : for i in 1 to (NUMBER_OF_CHARACTERS - 1) generate

    IAGhosts : entity work.IAGhosts
      generic map(
        INDEX => i
        )

      port map (
        RESET_N               => RESET_N,
        CLOCK                 => CLK,
        TIMER_MOVE            => timer_move_ghost,
        CAN_MOVES             => can_moves_array(i),
        MOVE_COMMANDS         => MOVE_COMMANDS_ARRAY(i),
        ENABLE                => enable,
        CHARACTER_COORDINATES => CHARACTER_COORDINATES_ARRAY(i-1).coordinates
        );

  end generate;

  -----------------------------------------------------------------------------

  FSM_controller : entity work.FSM_controller
    port map (
      RESET_N           => RESET_N,
      CLOCK             => CLK,
      GAME_OVER_SIGNAL  => game_over,
      WIN_SIGNAL        => win,
      BUTTON_DOWN       => BUTTON_DOWN,
      BUTTON_UP         => BUTTON_UP,
      BUTTON_LEFT       => BUTTON_LEFT,
      BUTTON_RIGHT      => BUTTON_RIGHT,
      ENABLE_CONTROLLER => enable,
      CURRENT_STATE     => CURRENT_STATE,
      PAUSE_SIGNAL      => PAUSE
      );

  -----------------------------------------------------------------------------

  -- Impulso ogni quarto di secondo
  timegen : process(CLK, reset_n)
    variable counter : integer range 0 to (12500000-1);
  begin
    if (reset_n = '0') then
      counter          := 0;
      timer_move       <= '0';
      timer_move_ghost <= '0';
    elsif (rising_edge(CLK)) then
      if(counter = counter'high) then
        counter    := 0;
        timer_move <= '1';
      elsif(counter = 12000000) then
        timer_move_ghost <= '1';
        counter          := counter+1;
      else
        counter          := counter+1;
        timer_move       <= '0';
        timer_move_ghost <= '0';
      end if;
    end if;
  end process;

end architecture Structural;
