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
    QUERY_NEARBY_ARRAY    : in  cell_nearby_array;
    QUERY_VIEW            : in  cell_coordinates;
    REMOVE_CANDY          : in  cell_coordinates;
    --
    RESPONSE_NEARBY_ARRAY : out cell_nearby_content_array;
    RESPONSE_VIEW         : out map_cell_type;
    CANDY_LEFT            : out integer range 0 to (MAX_CANDIES-1);

    -- MovingParts
    MOVE_COMMANDS_ARRAY          : in  move_commands_array;
    --
    CHARACTERS_COORDINATES_ARRAY : out character_cell_array
    );

end entity ModelTopLevel;

architecture Structural of ModelTopLevel is

begin  -- architecture Structural

  MapEntity : entity work.MapEntity
    port map (
      CLOCK           => CLOCK,
      RESET_N         => RESET_N,
      QUERY_NEARBY    => QUERY_NEARBY_ARRAY,
      QUERY_VIEW      => QUERY_VIEW,
      REMOVE_CANDY    => REMOVE_CANDY,
      RESPONSE_NEARBY => RESPONSE_NEARBY_ARRAY,
      RESPONSE_VIEW   => RESPONSE_VIEW,
      CANDY_LEFT      => CANDY_LEFT
      );

  MovingParts : entity work.MovingParts
    port map (
      CLOCK                  => CLOCK,
      RESET_N                => RESET_N,
      MOVE_COMMANDS          => MOVE_COMMANDS_ARRAY,
      CHARACTERS_COORDINATES => CHARACTERS_COORDINATES_ARRAY
      );


end architecture Structural;
