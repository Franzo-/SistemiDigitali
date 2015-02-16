library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.pacman_package.all;


entity Eating_controller is 

	port(
			--segnali ingresso
			PACMAN_COORDINATES 	  : in cell_coordinates; --da aggiungere i fantasmi o fare un array unico?
			--CHARACTERS_COORDINATES : in character_cell_array;
			GHOST1_COORDINATES     : in cell_coordinates;
			GHOST2_COORDINATES     : in cell_coordinates;
			GHOST3_COORDINATES     : in cell_coordinates;
			GHOST4_COORDINATES     : in cell_coordinates;
			CLOCK          		  : in  std_logic;
         RESET_N        		  : in  std_logic;
			CANDY_LEFT 				  : in integer;  
			RESPONSE_CANDY 		  : in map_cell_type;  --(presenza della caramella) riceve casella del pacman dopo query candy
			--segnali di uscita
			GAME_OVER 				  : out std_logic;
			WIN 						  : out std_logic;
			QUERY_CANDY  			  : out cell_coordinates;  --(chiede al model il blocco in cui si trova pacman mandando le sue coordinate)
			REMOVE_CANDY 			  : out cell_coordinates  --(indica al model di rimuovere una caramella)
			
			
		);
	
end entity;


architecture my_eating_controller of	Eating_controller is


begin


--processo per il pacman----------
	pacman_eating : process(PACMAN_COORDINATES) 
	
	begin
	QUERY_CANDY <= PACMAN_COORDINATES;  --ogni volta che cambiano le coordinate, le invio al model per ricevere le info della casella
	
	end process pacman_eating;
	
	
	
	
----------------------------------------------------------------------
--processo per i fantasmi----------
	ghost_eating : process(GHOST1_COORDINATES,GHOST2_COORDINATES,GHOST3_COORDINATES,GHOST4_COORDINATES) 
	
	begin
	--
	
	end process ghost_eating;
	
	
	
	
----------------------------------------------------------------------

--processo per il RESPONSE_CANDY----------
	Response_candy_trigger : process(RESPONSE_CANDY) 
	
	--inizializzare in qualche modo il RESPONSE_CANDY??
	begin
	--quando arriva la RESPONSE_CANDY dal model cosa faccio?
	if()
	
	end process Response_candy_trigger;
	
	
	
	
----------------------------------------------------------------------
  
  ------processo che si attiva ogni volta che cambia il numero delle caramelle-----
  Candy_trigger : process (CANDY_LEFT,RESET_N)
  begin
	WIN <= '1';
	
  if(RESET_N = '0') then
		WIN <= '0';

  elsif(CANDY_LEFT = 0) then
		WIN <= '1';
		
	end if;	
	end process Candy_trigger ;	
------------------------------------------------------------------------------------	
	
end architecture;