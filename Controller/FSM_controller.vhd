library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;


entity FSM_Controller is
	port
	(
	----input -------------------
		CLOCK          : in  std_logic;
		RESET_N        : in  std_logic;
		PAUSE_SIGNAL          : in  std_logic;
		GAME_OVER_SIGNAL      : in  std_logic;
		WIN_SIGNAL            : in std_logic;
		BUTTON_UP      : in std_logic;   --automa sensibile ai tasti direzioni
      BUTTON_DOWN    : in std_logic;
      BUTTON_RIGHT   : in std_logic;
      BUTTON_LEFT    : in std_logic;
	----output-------------------

		ENABLE_PACMAN_CONTROLLER 					: out std_logic;
		ENABLE_COLLISION_DETECTION_CONTROLLER   : out	std_logic;
		STRING_CONDITION_TYPE 						: out string_condition_type
		
	);
end entity;


architecture my_FSM_Controller of FSM_Controller is
	
	type   state_type    is (START_SCREEN, PLAYING, PAUSE, WIN, GAME_OVER);
	signal state        : state_type;

begin

	process(CLOCK, RESET_N)
	begin
	
		if (RESET_N = '0') then
		--al reset riparto dalla schermata iniziale e disattivo i controller
			state <= START_SCREEN;
			ENABLE_PACMAN_CONTROLLER	<= '0';
			ENABLE_COLLISION_DETECTION_CONTROLLER	<= '0';
			STRING_CONDITION_TYPE <= string_condition_type'val(0); --START_SCREEN


		elsif (rising_edge(CLOCK)) then
		
	
			case (state) is
			
			--nella schermata iniziale l'automa è sensibile alla pressione dei tasti direzionali
				when START_SCREEN => 
				
					if (BUTTON_DOWN = '1' or BUTTON_UP = '1' 
							or BUTTON_LEFT = '1' or BUTTON_RIGHT ='1') then
						state    <= PLAYING;
						ENABLE_PACMAN_CONTROLLER <= '1';
						ENABLE_COLLISION_DETECTION_CONTROLLER  <='1';
						STRING_CONDITION_TYPE <= string_condition_type'val(1); --PLAYING
					end if;
					
				when PLAYING =>
				--durante il gioco, l'automa cambia stato se viene premuto il tasto di pausa, se il pacman 
				-- collide con un fantasma, o se abbiamo finito le caramelle
				   if(PAUSE_SIGNAL = '1') then
						state <= PAUSE;
						ENABLE_PACMAN_CONTROLLER <= '0';
						ENABLE_COLLISION_DETECTION_CONTROLLER  <='0';
						STRING_CONDITION_TYPE <= string_condition_type'val(2); --PAUSE
					
					elsif  (WIN_SIGNAL = '1') then
						state <= WIN;
						ENABLE_PACMAN_CONTROLLER <= '0';
						ENABLE_COLLISION_DETECTION_CONTROLLER  <='0';
						STRING_CONDITION_TYPE <= string_condition_type'val(3); --WIN
						
					elsif  (GAME_OVER_SIGNAL = '1') then
						state <= GAME_OVER;
						ENABLE_PACMAN_CONTROLLER <= '0';
						ENABLE_COLLISION_DETECTION_CONTROLLER  <='0';
						STRING_CONDITION_TYPE <= string_condition_type'val(4); --GAME_OVER	
						
					end if;
				
				when PAUSE =>
					-- durante la pausa per ricominciare a giocare basta disattivare l'interruttore 
					-- sulla FPGA (PAUSE_SIGNAL ='0')
					if(PAUSE_SIGNAL = '0') then
						state <= PLAYING;
						ENABLE_PACMAN_CONTROLLER <= '1';
						ENABLE_COLLISION_DETECTION_CONTROLLER  <='1';
						STRING_CONDITION_TYPE <= string_condition_type'val(1); --PLAYING	
					end if;
				
			when WIN | GAME_OVER=>
					--win e game over saranno molto simili: si resetta allo stato iniziale con la pressione del reset
					--e inviano semplicemente l'enumerativo alla view. stoppiamo tutti i movimenti
					ENABLE_PACMAN_CONTROLLER <= '0';
					ENABLE_COLLISION_DETECTION_CONTROLLER  <='0';
					
					if(state = WIN) then
					STRING_CONDITION_TYPE <= string_condition_type'val(3); --è davvero necessaria sta riga??
					elsif (state = GAME_OVER) then
					STRING_CONDITION_TYPE <= string_condition_type'val(4); --è davvero necessaria sta riga??
					end if;
					
					if(RESET_N = '0') then --ricominciamo il gioco
						state <= START_SCREEN;
						STRING_CONDITION_TYPE <= string_condition_type'val(0); --START_SCREEN
					end if;	
					

			end case;
	
		end if;
	end process;
	
end architecture;