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

		SW                  : in  std_logic_vector(9 downto 9);
		VGA_R               : out std_logic_vector(3 downto 0);
		VGA_G               : out std_logic_vector(3 downto 0);
		VGA_B               : out std_logic_vector(3 downto 0);
		VGA_HS              : out std_logic;
		VGA_VS              : out std_logic;
		
		SRAM_ADDR           : out   std_logic_vector(17 downto 0);
		SRAM_DQ             : inout std_logic_vector(15 downto 0);
		SRAM_CE_N           : out   std_logic;
		SRAM_OE_N           : out   std_logic;
		SRAM_WE_N           : out   std_logic;
		SRAM_UB_N           : out   std_logic;
		SRAM_LB_N           : out   std_logic
	);

end;

architecture RTL of Pacman is

begin 



end architecture;