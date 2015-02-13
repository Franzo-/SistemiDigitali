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
      BUTTON_NORTH     : in  std_logic;
      BUTTON_SOUTH    : in  std_logic;
      BUTTON_EAST    : in  std_logic;
      BUTTON_WEST   : in  std_logic;


      --segnali che indicano se il pacman puo muoversi nella data direzione
      CAN_MOVE_NORTH : in std_logic;
      CAN_MOVE_SOUTH : in std_logic;
      CAN_MOVE_EAST : in std_logic;
      CAN_MOVE_WEST : in std_logic;
      --segnali in uscita	 
      MOVE_NORTH : out std_logic;
      MOVE_SOUTH : out std_logic;
      MOVE_EAST : out std_logic;
      MOVE_WEST : out std_logic		
      
    );

end entity Pacman_controller;

begin 
Pacman_controller : process(CLOCK,RESET_N)
begin
	
	if(RESET_N = '0') then
		MOVE_NORTH      <= '0';  --monoimpulsori
		MOVE_SOUTH      <= '0';
		MOVE_WEST       <= '0';
		MOVE_EAST       <= '0';

	elsif rising_edge(CLOCK) then
		MOVE_NORTH      <= '0';  --monoimpulsori
		MOVE_SOUTH      <= '0';
		MOVE_WEST       <= '0';
		MOVE_EAST       <= '0';

	--ad ogni fronte positivo di ck verifico dove deve andare il pacman
	--(ad ogni passo corrisponde la pressione di un tasto)

		if(BUTTON_NORTH = '1' and CAN_MOVE_NORTH = '1' )
			MOVE_NORTH <= '1';

		elsif(BUTTON_SOUTH = '1' and CAN_MOVE_SOUTH = '1' )
			MOVE_SOUTH <= '1';

		elsif(BUTTON_EAST = '1' and CAN_MOVE_EAST = '1' )
			MOVE_EAST <= '1';

		elsif(BUTTON_WEST = '1' and CAN_MOVE_WEST = '1' )
			MOVE_WEST <= '1';
		end if;
	end if;
end process;


		
	
