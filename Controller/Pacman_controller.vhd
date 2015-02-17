library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;


entity Pacman_controller is
  port
    (
      CLOCK   : in std_logic;
      RESET_N : in std_logic;
      ENABLE  : in std_logic;

      --segnali dei tasti direzionali
      BUTTON_UP    : in std_logic;
      BUTTON_DOWN  : in std_logic;
      BUTTON_RIGHT : in std_logic;
      BUTTON_LEFT  : in std_logic;

      --segnali che indicano se il pacman puo muoversi nella data direzione
      CAN_MOVES     : in  can_move;
      --segnali in uscita        
      MOVE_COMMANDS : out move_commands
      );

end entity Pacman_controller;

architecture my_pacman_controller of pacman_controller is

begin

  Pacman_controller : process(CLOCK, RESET_N)

  begin

    if(RESET_N = '0') then
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_up    <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';


    elsif rising_edge(CLOCK) then

      MOVE_COMMANDS.move_up    <= '0';  --monoimpulsori
      MOVE_COMMANDS.move_down  <= '0';
      MOVE_COMMANDS.move_left  <= '0';
      MOVE_COMMANDS.move_right <= '0';

      if(ENABLE = '1') then
        --ad ogni fronte positivo di ck verifico dove deve andare il pacman
        --(ad ogni passo corrisponde la pressione di un tasto)

        if(BUTTON_UP = '1' and CAN_MOVES.can_move_up = '1') then
          MOVE_COMMANDS.move_up <= '1';

        elsif(BUTTON_DOWN = '1' and CAN_MOVES.can_move_down = '1') then
          MOVE_COMMANDS.move_down <= '1';

        elsif(BUTTON_RIGHT = '1' and CAN_MOVES.can_move_right = '1') then
          MOVE_COMMANDS.move_right <= '1';

        elsif(BUTTON_LEFT = '1' and CAN_MOVES.can_move_left = '1') then
          MOVE_COMMANDS.move_left <= '1';
        end if;
      end if;
    end if;
  end process;

end architecture;



