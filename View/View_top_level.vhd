-- TOP LEVEL VIEW

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;
use work.view_package.all;

entity ViewTopLevel is

  port (
    CLOCK   : in  std_logic;
    RESET_N : in  std_logic;
    --
    H_SYNC  : out std_logic;
    V_SYNC  : out std_logic;
    VGA_R   : out std_logic_vector(3 downto 0);
    VGA_G   : out std_logic_vector(3 downto 0);
    VGA_B   : out std_logic_vector(3 downto 0)
    );

end entity ViewTopLevel;

architecture Structural of ViewTopLevel is

  signal disp_ena : std_logic;
  signal column   : integer;
  signal row      : integer;

  signal n_blank : std_logic;
  signal n_sync  : std_logic;

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
      disp_ena  => disp_ena,
      column    => column,
      row       => row,
      n_blank   => n_blank,             -- boh
      n_sync    => n_sync               -- boh

      );

------------------------------------------------------------------------

--  HW_IMAGE_GENERATOR : entity work.hw_image_generator
--    generic map (
--      pixels_x => 50,
--      pixels_y => 50
--      )
--
--    port map (
--      disp_ena => disp_ena,
--      column   => column,
--      row      => row,
--      red      => VGA_R,
--      green    => VGA_G,
--      blue     => VGA_B
--      );


end architecture Structural;
