library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;


entity Pacman_controller is
  port
    (
      CLOCK      : in std_logic;
      RESET_N    : in std_logic;
      ENABLE     : in std_logic;
      TIMER_MOVE : in std_logic;

      --segnali dei tasti direzionali
      BUTTON_UP    : in std_logic;
      BUTTON_DOWN  : in std_logic;
      BUTTON_RIGHT : in std_logic;
      BUTTON_LEFT  : in std_logic;

      --segnali che indicano se il pacman puo muoversi nella data direzione
      CAN_MOVES        : in  can_move;
      --segnali in uscita        
      MOVE_COMMANDS    : out move_commands;
      MOUTH_OPEN       : out std_logic;
      PACMAN_DIRECTION : out character_direction
      );

end entity Pacman_controller;

architecture my_pacman_controller of pacman_controller is

  signal pacman_mouth_open : std_logic;
  signal direction         : character_direction;

begin

  Pacman_controller : process(CLOCK, RESET_N)

  begin

    if(RESET_N = '0') then
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';

      pacman_mouth_open <= '1';
      direction         <= RIGHT_DIR;


    elsif rising_edge(CLOCK) then

      MOVE_COMMANDS.move_up    <= '0';  --monoimpulsori
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';

      Moves : if(ENABLE = '1' and TIMER_MOVE = '1') then
        --ad ogni fronte positivo di ck verifico dove deve andare il pacman
        --(ad ogni passo corrisponde la pressione di un tasto)

        if(BUTTON_UP = '1' and CAN_MOVES.can_move_up = '1') then
          MOVE_COMMANDS.move_up <= '1';
          direction             <= UP_DIR;

        elsif(BUTTON_DOWN = '1' and CAN_MOVES.can_move_down = '1') then
          MOVE_COMMANDS.move_down <= '1';
          direction               <= DOWN_DIR;

        elsif(BUTTON_RIGHT = '1' and CAN_MOVES.can_move_right = '1') then
          MOVE_COMMANDS.move_right <= '1';
          direction                <= RIGHT_DIR;

        elsif(BUTTON_LEFT = '1' and CAN_MOVES.can_move_left = '1') then
          MOVE_COMMANDS.move_left <= '1';
          direction               <= LEFT_DIR;
        end if;
      end if Moves;

      Mouth : if (ENABLE = '1' and TIMER_MOVE = '1') then
        pacman_mouth_open <= not pacman_mouth_open;
      end if Mouth;

    end if;
  end process;

  MOUTH_OPEN       <= pacman_mouth_open;
  PACMAN_DIRECTION <= direction;

end architecture;



