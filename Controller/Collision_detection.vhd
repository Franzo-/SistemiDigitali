library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;

entity CollisionDetection is
  port (
    -- Input
    CHARACTER_COORDINATES : in cell_coordinates;
    RESPONSE             : in cell_nearby_content;

    -- Output
    QUERY          : out cell_nearby;
	 CAN_MOVES      : out can_move
	 
    );
end CollisionDetection;

architecture my_collision_detection of CollisionDetection is

begin

  ResponseChanged : process (RESPONSE)
  begin

    CAN_MOVES.can_move_up <= '1';
	 CAN_MOVES.can_move_down <= '1';
	 CAN_MOVES.can_move_left <= '1';
	 CAN_MOVES.can_move_right <= '1';
	 
    
    if(RESPONSE.cell_up_content.is_wall = '1') then
      CAN_MOVES.can_move_up <= '0';
    else
      CAN_MOVES.can_move_up <= '1';
    end if;

    if(RESPONSE.cell_down_content.is_wall = '1') then
      CAN_MOVES.can_move_down <= '0';
    else
      CAN_MOVES.can_move_down <= '1';
    end if;

    if(RESPONSE.cell_left_content.is_wall = '1') then
      CAN_MOVES.can_move_left <= '0';
    else
      CAN_MOVES.can_move_left <= '1';
    end if;

    if(RESPONSE.cell_right_content.is_wall = '1') then
      CAN_MOVES.can_move_right <= '0';
    else
      CAN_MOVES.can_move_right <= '1';
    end if;

  end process ResponseChanged;


  CoordinatesChanged : process (CHARACTER_COORDINATES)
  begin

    QUERY.cell_up.col <= CHARACTER_COORDINATES.col;
    QUERY.cell_up.row <= CHARACTER_COORDINATES.row - 1;

    QUERY.cell_down.col <= CHARACTER_COORDINATES.col;
    QUERY.cell_down.row <= CHARACTER_COORDINATES.row + 1;

    QUERY.cell_left.col <= CHARACTER_COORDINATES.col + 1;
    QUERY.cell_left.row <= CHARACTER_COORDINATES.row;

    QUERY.cell_right.col <= CHARACTER_COORDINATES.col - 1;
    QUERY.cell_right.row <= CHARACTER_COORDINATES.row;

  end process CoordinatesChanged;

end architecture my_collision_detection;
