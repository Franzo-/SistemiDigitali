library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity IAGhosts is

  port (
      CLOCK   : in std_logic;
      RESET_N : in std_logic;

      --segnali che indicano se il ghost puo muoversi nella data direzione
		CAN_MOVES : in can_move;
      --segnali in uscita        
		MOVE_COMMANDS : out move_commands
    );

end entity IAGhosts;

architecture RTL of IAGhosts is

type ghost_direction is (UP_DIR, DOWN_DIR, LEFT_DIR, RIGHT_DIR, IDLE );
variable current_direction : ghost_direction;

begin 

  Ghost_controller : process(CLOCK, RESET_N)
		
  begin		

    if(RESET_N = '0') then
      MOVE_COMMANDS.move_down <= '0';  --monoimpulsori
		MOVE_COMMANDS.move_up <= '0';
		MOVE_COMMANDS.move_left <= '0';
		MOVE_COMMANDS.move_right <= '0';
		current_direction := IDLE;
		
	elsif rising_edge(CLOCK) then
	
	   MOVE_COMMANDS.move_down <= '0';  --monoimpulsori
		MOVE_COMMANDS.move_up <= '0';
		MOVE_COMMANDS.move_left <= '0';
		MOVE_COMMANDS.move_right <= '0';
		
		if(incrocio) then 
		
		else 
		
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
		end case 
	
	end if;
	
  end process Ghost_controller; 

end architecture;