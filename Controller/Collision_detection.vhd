library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;


entity CollisionDetection is
  port (
			RESET_N : in  std_logic;
			CLK     : in  std_logic;  --clock di movimento
			CHARACTER_TO_MOVE : in character_cell_type; -- contiene la posizione del pacman/ghost
			CELL_CONTENT : in cell_coordinates;  
		  
			QUERY_CELL : out cell_coordinates;
		  
		  
			CAN_MOVE_UP : out std_logic;
			CAN_MOVE_DOWN : out std_logic;
			CAN_MOVE_LEFT : out std_logic;
			CAN_MOVE_RIGHT : out std_logic;
		  
        );
end CollisionDetection;

architecture my_collision_detection of CollisionDetection is

begin
	process (CLK, RESET_N)
     begin
  
	end process;
end architecture my_collision_detection;