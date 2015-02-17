library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;


entity FSM_Controller is
  port
    (
      ----input -------------------
      CLOCK            : in std_logic;
      RESET_N          : in std_logic;
      PAUSE_SIGNAL     : in std_logic;
      GAME_OVER_SIGNAL : in std_logic;
      WIN_SIGNAL       : in std_logic;
      BUTTON_UP        : in std_logic;  --automa sensibile ai tasti direzioni
      BUTTON_DOWN      : in std_logic;
      BUTTON_RIGHT     : in std_logic;
      BUTTON_LEFT      : in std_logic;
      ----output-------------------

      ENABLE_CONTROLLER : out std_logic;
      CURRENT_STATE     : out state_controller_type
      );
end entity;


architecture my_FSM_Controller of FSM_Controller is


  signal state : state_controller_type;

begin

  process(CLOCK, RESET_N)
  begin

    if (RESET_N = '0') then
      --al reset riparto dalla schermata iniziale e disattivo i controller
      state             <= START_SCREEN;
      ENABLE_CONTROLLER <= '0';
      CURRENT_STATE     <= state;       --START_SCREEN


    elsif (rising_edge(CLOCK)) then


      case (state) is

        --nella schermata iniziale l'automa è sensibile alla pressione dei tasti direzionali
        when START_SCREEN =>

          if (BUTTON_DOWN = '1' or BUTTON_UP = '1'
              or BUTTON_LEFT = '1' or BUTTON_RIGHT = '1') then
            state             <= PLAYING;
            ENABLE_CONTROLLER <= '1';
            CURRENT_STATE     <= state;  --PLAYING
          end if;

        when PLAYING =>
          --durante il gioco, l'automa cambia stato se viene premuto il tasto di pausa, se il pacman 
          -- collide con un fantasma, o se abbiamo finito le caramelle
          if(PAUSE_SIGNAL = '1') then
            state             <= PAUSE;
            ENABLE_CONTROLLER <= '0';
            CURRENT_STATE     <= state;  --PAUSE

          elsif (WIN_SIGNAL = '1') then
            state             <= WIN;
            ENABLE_CONTROLLER <= '0';
            CURRENT_STATE     <= state;  --WIN

          elsif (GAME_OVER_SIGNAL = '1') then
            state             <= GAME_OVER;
            ENABLE_CONTROLLER <= '0';
            CURRENT_STATE     <= state;  --GAME_OVER        

          end if;

        when PAUSE =>
                                         -- durante la pausa per ricominciare a giocare basta disattivare l'interruttore 
                                         -- sulla FPGA (PAUSE_SIGNAL ='0')
          if(PAUSE_SIGNAL = '0') then
            state             <= PLAYING;
            ENABLE_CONTROLLER <= '1';
            CURRENT_STATE     <= state;  --PLAYING  
          end if;

        when WIN | GAME_OVER =>
                                        --win e game over saranno molto simili: si resetta allo stato iniziale con la pressione del reset
                                        --e inviano semplicemente l'enumerativo alla view. stoppiamo tutti i movimenti
          ENABLE_CONTROLLER <= '0';

          if(state = WIN) then
            CURRENT_STATE <= state;
          elsif (state = GAME_OVER) then
            CURRENT_STATE <= state;
          end if;

      end case;

    end if;
  end process;

end architecture;
