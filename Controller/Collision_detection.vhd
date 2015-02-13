library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CollisionDetection is
  port (
			RESET_N : in  std_logic;
			CLK     : in  std_logic;  --clock di movimento
			CHARACTER_TO_MOVE : in character_cell_type; -- contiene la posizione del pacman/ghost
			RESPONSE : in cell_nearby_content;  
		  
			QUERY : out cell_nearby;
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
      if (RESET_N = '0') then
                --TODO logica iniziale
      elsif (rising_edge(CLK)) then
			  
		  -- QUALE CHARACTER TO MOVE??? COME FARE DETECTION PER TUTTE LE PARTI MOBILI?? UN ISTANZA PER OGNUNO?
		  -- LE COORDINATE COME LE LEGGIAMO??? UP è +1 oppure -1??
		  QUERY.cell_up.col <= CHARACTER_TO_MOVE.coordinates.col + 1;
        QUERY.cell_up.row <= CHARACTER_TO_MOVE.coordinates.row;
		  
		  QUERY.cell_down.col <= CHARACTER_TO_MOVE.coordinates.col - 1;
        QUERY.cell_down.row <= CHARACTER_TO_MOVE.coordinates.row;
		  
		  QUERY.cell_left.col <= CHARACTER_TO_MOVE.coordinates.col;
        QUERY.cell_left.row <= CHARACTER_TO_MOVE.coordinates.row - 1;
		  
		  QUERY.cell_right.col <= CHARACTER_TO_MOVE.coordinates.col;
        QUERY.cell_right.row <= CHARACTER_TO_MOVE.coordinates.row + 1;
		  
		  -- la risposta corretta dovrebbe arrivare al clock dopo..come dirlo?? segnali di sincronizzazione???
		  -- scrivo la logica...
		  
		  if(RESPONSE.cell_up_content.is_candy = '1') then
				CAN_MOVE_UP <= '1';
		  else 
				CAN_MOVE_UP <= '0';
		  end if;
		  
		  if(RESPONSE.cell_down_content.is_candy = '1') then
				CAN_MOVE_DOWN <= '1';
		  else 
				CAN_MOVE_DOWN <= '0';
		  end if;
		  
		  if(RESPONSE.cell_left_content.is_candy = '1') then
				CAN_MOVE_LEFT <= '1';
		  else 
				CAN_MOVE_LEFT <= '0';
		  end if;
		  
		  if(RESPONSE.cell_right_content.is_candy = '1') then
				CAN_MOVE_RIGHT <= '1';
		  else 
				CAN_MOVE_RIGHT <= '0';
		  end if;

    end if;
	end process;
end architecture my_collision_detection;