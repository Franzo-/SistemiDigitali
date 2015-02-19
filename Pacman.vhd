-- TOP LEVEL ENTITY

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.pacman_package.all;

entity Pacman is

	port
	(
		CLOCK_50            : in  std_logic;
		KEY                 : in  std_logic_vector(3 downto 0);

		SW                  : in  std_logic_vector(9 downto 0);
		VGA_R               : out std_logic_vector(3 downto 0);
		VGA_G               : out std_logic_vector(3 downto 0);
		VGA_B               : out std_logic_vector(3 downto 0);
		VGA_HS              : out std_logic;
		VGA_VS              : out std_logic;
		
		HEX0                : out   std_logic_vector(6 downto 0);
		HEX1                : out   std_logic_vector(6 downto 0);
		HEX2                : out   std_logic_vector(6 downto 0);
		HEX3                : out   std_logic_vector(6 downto 0)
	);

end;

architecture RTL of Pacman is

-- Signal Controller/Model
------------------------------------------------------------------------

signal reset_n, pause : std_logic;
signal b_up, b_down, b_right, b_left : std_logic;
signal candy_left : integer range 0 to (MAX_CANDIES -1); 
signal character_coordinates_array : character_cell_array;
signal response_nearby_array : cell_nearby_content_array;
signal remove_candy : cell_coordinates;
signal query_nearby_array : cell_nearby_array;
signal move_commands_array : move_commands_array;
signal current_state : state_controller_type;

--Signal Model/View
------------------------------------------------------------------------

signal query_view : cell_coordinates;
signal response_view : map_cell_type;

-- Signal VGA
------------------------------------------------------------------------

signal clock_vga : std_logic;
signal h_sync : std_logic;
signal v_sync : std_logic;
signal disp_ena : std_logic;
signal column : integer;
signal row : integer;
signal n_blank : std_logic;
signal n_sync : std_logic;

------------------------------------------------------------------------
signal clock_move : std_logic;
 
begin 
 
  reset_n <= SW(9);
  pause <= not SW(0);
  b_right <= not KEY(0); 
  b_up <= not KEY(1); 
  b_down <= not KEY(2); 
  b_left <= not KEY(3);

  
------------------------------------------------------------------------
  
  Controller : entity work.ControllerTopLevel
    port map (

    RESET_N => reset_n,
    CLK  => clock_move,
    BUTTON_UP => b_up,
    BUTTON_DOWN => b_down,
    BUTTON_RIGHT => b_right,
    BUTTON_LEFT => b_left,
    CANDY_LEFT => candy_left,
    CHARACTER_COORDINATES_ARRAY => character_coordinates_array,
    RESPONSE_NEARBY_ARRAY => response_nearby_array,
    REMOVE_CANDY => remove_candy,
    QUERY_NEARBY_ARRAY => query_nearby_array,
    MOVE_COMMANDS_ARRAY => move_commands_array,
    CURRENT_STATE => current_state 

      );
		
------------------------------------------------------------------------

  Model : entity work.ModelTopLevel
    port map (

    RESET_N => reset_n,
    CLOCK  => clock_move,
    QUERY_NEARBY_ARRAY => query_nearby_array,
    QUERY_VIEW  => query_view,
    REMOVE_CANDY  => remove_candy,
    RESPONSE_NEARBY_ARRAY => response_nearby_array,
    RESPONSE_VIEW => response_view,
    CANDY_LEFT => candy_left,
    MOVE_COMMANDS_ARRAY => move_commands_array,
    CHARACTERS_COORDINATES_ARRAY => character_coordinates_array

      );

------------------------------------------------------------------------

  PLL : entity work.pll
    port map (
		inclk0 => CLOCK_50,
		c0	=> clock_vga
	);
	
------------------------------------------------------------------------

  VGA_Controller : entity work.vga_controller
    port map (

      pixel_clk => clock_vga,	
		reset_n	=> reset_n,	
		h_sync	=> h_sync,	
		v_sync	=> v_sync,	
		disp_ena	=> disp_ena,
		column	=> column,	 
		row	=> row,	
		n_blank	=> n_blank,	
		n_sync	=> n_sync 

      );
		
------------------------------------------------------------------------

  HW_IMAGE_GENERATOR : entity work.hw_image_generator
    port map (
		disp_ena	=> disp_ena,
		column	=> column,	
		row	=> row,	
		red => VGA_R,
		green => VGA_G,
		blue => VGA_B 


      );

------------------------------------------------------------------------

	timegen : process(CLOCK_50, reset_n)
		variable counter : integer range 0 to (25000000-1);
	begin
		if (reset_n = '0') then
			counter := 0;
			clock_move <= '0';
		elsif (rising_edge(CLOCK_50)) then
			if(counter = counter'high) then
				counter := 0;
				clock_move <= '1';
			else
				counter := counter+1;
				clock_move <= '0';			
			end if;
		end if;
	end process;
	

end architecture;