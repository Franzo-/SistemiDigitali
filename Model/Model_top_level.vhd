-- TOP LEVEL MODEL

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity ModelTopLevel is

  port (
    CLOCK   : in std_logic;
    RESET_N : in std_logic;

    -- Map
    QUERY_NEARBY    : in  cell_nearby_array;
    QUERY_VIEW      : in  cell_coordinates;
    REMOVE_CANDY    : in  cell_coordinates;
    --
    RESPONSE_NEARBY : out cell_nearby_content_array;
    RESPONSE_VIEW   : out map_cell_type;
    CANDY_LEFT      : out integer range 0 to (MAX_CANDIES-1);

    -- MovingParts
    MOVE_COMMANDS          : in  move_commands_array;
    --
    CHARACTERS_COORDINATES : out character_cell_array
    );

end entity ModelTopLevel;

architecture Structural of ModelTopLevel is

begin  -- architecture Structural

  MapEntity : entity work.MapEntity
    port map (
      CLOCK           => CLOCK,
      RESET_N         => RESET_N,
      QUERY_NEARBY    => QUERY_NEARBY,
      QUERY_VIEW      => QUERY_VIEW,
      REMOVE_CANDY    => REMOVE_CANDY,
      RESPONSE_NEARBY => RESPONSE_NEARBY,
      RESPONSE_VIEW   => RESPONSE_VIEW,
      CANDY_LEFT      => CANDY_LEFT
      );

  MovingParts : entity work.MovingParts
    port map (
      CLOCK                  => CLOCK,
      RESET_N                => RESET_N,
      MOVE_COMMANDS          => MOVE_COMMANDS,
      CHARACTERS_COORDINATES => CHARACTERS_COORDINATES
      );


end architecture Structural;
