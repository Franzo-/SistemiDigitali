-- TOP LEVEL VIEW

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

entity ViewTopLevel is

  port (
    -- Inputs
    CLOCK                        : in std_logic;
    RESET_N                      : in std_logic;
    --
    CANDY_LEFT                   : in candy_count_type;
    --
    RESPONSE_VIEW                : in map_cell_type;
    CHARACTERS_COORDINATES_ARRAY : in character_cell_array;
    --
    MOUTH_OPEN                   : in std_logic;
    PACMAN_DIRECTION             : in character_direction;
    --
    CURRENT_STATE                : in state_controller_type;

    -- Outputs
    QUERY_VIEW : out cell_coordinates;
    --
    HEX0       : out std_logic_vector(6 downto 0);
    HEX1       : out std_logic_vector(6 downto 0);
    HEX2       : out std_logic_vector(6 downto 0);
    HEX3       : out std_logic_vector(6 downto 0);
    --
    H_SYNC     : out std_logic;
    V_SYNC     : out std_logic;
    VGA_R      : out std_logic_vector(3 downto 0);
    VGA_G      : out std_logic_vector(3 downto 0);
    VGA_B      : out std_logic_vector(3 downto 0)
    );

end entity ViewTopLevel;

architecture Structural of ViewTopLevel is

  signal disp_enable : std_logic;
  signal column      : integer;
  signal row         : integer;
  signal timer_blinking : std_logic;

begin  -- architecture Structural

  VGA_Controller : entity work.vga_controller
    generic map (
      h_pixels => H_PIXELS,
      v_pixels => V_PIXELS,
      h_fp     => 16,
      v_fp     => 10,
      h_pulse  => 96,
      v_pulse  => 2,
      h_bp     => 48,
      v_bp     => 33,
      h_pol    => '0',
      v_pol    => '0'

      )

    port map (

      pixel_clk => CLOCK,
      reset_n   => RESET_N,
      h_sync    => H_SYNC,
      v_sync    => V_SYNC,
      disp_ena  => disp_enable,
      column    => column,
      row       => row,
      n_blank   => open,                -- unused
      n_sync    => open                 -- unused

      );

  -----------------------------------------------------------------------------

  ImageGenerator : entity work.ImageGenerator
    port map (
      DISP_ENABLE                  => disp_enable,
      ROW                          => row,
      COLUMN                       => column,
      CELL_CONTENT                 => RESPONSE_VIEW,
      CHARACTERS_COORDINATES_ARRAY => CHARACTERS_COORDINATES_ARRAY,
      MOUTH_OPEN                   => MOUTH_OPEN,
      PACMAN_DIRECTION             => PACMAN_DIRECTION,
      CURRENT_STATE                => CURRENT_STATE,
      RED                          => VGA_R,
      GREEN                        => VGA_G,
      BLUE                         => VGA_B,
      QUERY_CELL                   => QUERY_VIEW,
		TIMER_BLINKING               => timer_blinking
      );

  -----------------------------------------------------------------------------

  SevenSegments : entity work.SevenSegEntity
    port map (
      CANDY_LEFT => CANDY_LEFT,
      HEX0       => HEX0,
      HEX1       => HEX1,
      HEX2       => HEX2,
      HEX3       => HEX3
      );
		
		
-----------------------------------------------------------------------------

-- Impulso ogni quarto di secondo
  timeblinkgen : process(CLOCK, reset_n)
    variable counter : integer range 0 to (12500000-1);
  begin
    if (reset_n = '0') then
      counter    := 0;
      timer_blinking <= '0';
    elsif (rising_edge(CLOCK)) then
      if(counter = counter'high ) then
        counter    := 0;
		elsif (counter <= 5000000) then
		  counter    := counter+1;
		  timer_blinking<= '1';
      else
        counter    := counter+1;
        timer_blinking <= '0';
      end if;
    end if;
  end process;
  

end architecture Structural;
