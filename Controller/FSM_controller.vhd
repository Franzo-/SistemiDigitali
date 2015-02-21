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
  signal next_state : state_controller_type;
  

begin

	CURRENT_STATE  <= state; --assegnamento concorrente


-------------------------------------------------------	
	State_update : process (CLOCK, RESET_N)
	begin
		if (RESET_N = '0') then
			state <= START_SCREEN;
		elsif rising_edge(CLOCK) then
			state<= next_state;
			
		end if;
	end process;
	
-------------------------------------------------------
	
	OutputAndNextState : process(state, BUTTON_DOWN,BUTTON_LEFT,BUTTON_RIGHT,BUTTON_UP,PAUSE_SIGNAL,WIN_SIGNAL,GAME_OVER_SIGNAL)
	begin

		ENABLE_CONTROLLER <= '0';
		next_state <= state;

      case (state) is

        --nella schermata iniziale l'automa è sensibile alla pressione dei tasti direzionali
        when START_SCREEN =>
				ENABLE_CONTROLLER <= '0';
				
          if (BUTTON_DOWN = '1' or BUTTON_UP = '1'
              or BUTTON_LEFT = '1' or BUTTON_RIGHT = '1') then
					next_state  <= PLAYING;

          end if;

        when PLAYING =>
				ENABLE_CONTROLLER <= '1';
          --durante il gioco, l'automa cambia stato se viene premuto il tasto di pausa, se il pacman 
          -- collide con un fantasma, o se abbiamo finito le caramelle
          if(PAUSE_SIGNAL = '1') then
            next_state  <= PAUSE;

          elsif (WIN_SIGNAL = '1') then
            next_state  <= WIN;
           
          elsif (GAME_OVER_SIGNAL = '1') then
            next_state   <= GAME_OVER;

          end if;

        when PAUSE =>
            ENABLE_CONTROLLER <= '0';        -- durante la pausa per ricominciare a giocare basta disattivare l'interruttore 
                                         -- sulla FPGA (PAUSE_SIGNAL ='0')
          if(PAUSE_SIGNAL = '0') then
            next_state  <= PLAYING;
          
          end if;

        when WIN | GAME_OVER =>
                                        --win e game over saranno molto simili: si resetta allo stato iniziale con la pressione del reset
                                        --e inviano semplicemente l'enumerativo alla view. stoppiamo tutti i movimenti
          ENABLE_CONTROLLER <= '0';

      end case;

  end process;

-------------------------------------------------------	

end architecture;
