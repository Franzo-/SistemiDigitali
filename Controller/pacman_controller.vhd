library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;


entity Pacman_controller is
  port
    (
      CLOCK   : in std_logic;
      CAN_MOVE : in std_logic;
      RESET_N : in std_logic;

      --segnali dei tasti direzionali
      BUTTON_UP     : in  std_logic;
      BUTTON_DOWN    : in  std_logic;
      BUTTON_RIGHT    : in  std_logic;
      BUTTON_LEFT   : in  std_logic;


      --segnali che indicano se il pacman puo muoversi nella data direzione
      CAN_MOVE_UP : in std_logic;
      CAN_MOVE_DOWN : in std_logic;
      CAN_MOVE_RIGHT : in std_logic;
      CAN_MOVE_LEFT : in std_logic;
      --segnali in uscita	 
      MOVE_UP : out std_logic;
      MOVE_DOWN : out std_logic;
      MOVE_RIGHT : out std_logic;
      MOVE_LEFT : out std_logic		
      
    );

end entity Pacman_controller;

begin 
Pacman_controller : process(CLOCK,RESET_N)
begin
	
	if(RESET_N = '0') then
		MOVE_UP      <= '0';  --monoimpulsori
		MOVE_DOWN      <= '0';
		MOVE_LEFT       <= '0';
		MOVE_RIGHT       <= '0';

	elsif rising_edge(CLOCK) then
		MOVE_UP      <= '0';  --monoimpulsori
		MOVE_DOWN      <= '0';
		MOVE_LEFT       <= '0';
		MOVE_RIGHT       <= '0';

	--ad ogni fronte positivo di ck verifico dove deve andare il pacman
	--(ad ogni passo corrisponde la pressione di un tasto)

		if(BUTTON_UP = '1' and CAN_MOVE_UP = '1' )
			MOVE_UP <= '1';

		elsif(BUTTON_DOWN = '1' and CAN_MOVE_DOWN = '1' )
			MOVE_DOWN <= '1';

		elsif(BUTTON_RIGHT = '1' and CAN_MOVE_RIGHT = '1' )
			MOVE_RIGHT <= '1';

		elsif(BUTTON_LEFT = '1' and CAN_MOVE_LEFT = '1' )
			MOVE_LEFT <= '1';
		end if;
	end if;
end process;

--prova bla bl abadadsadas

		
	
