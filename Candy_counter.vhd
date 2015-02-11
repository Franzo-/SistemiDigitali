2 ----------------------------------------------------------
3 -- Counter: synchronous up/down counter with asynchronous
4 -- reset and synchronous parallel load.
5 ----------------------------------------------------------
6 -- library declaration
7 library IEEE;
8 use IEEE.std_logic_1164.all;
9 use IEEE.numeric_std.all;
10
11 entity CandyCounter is
12 	port ( RESET,CLK;
13 			 DIN : in std_logic_vector (7 downto 0);
14			 COUNT : out std_logic_vector (7 downto 0));
15 end CandyCounter;
16 architecture my_count of CandyCounter is
17 	signal t_cnt : unsigned(7 downto 0); -- internal counter signal
18 begin
19	 process (CLK, RESET)
20 	 begin
21 		if (RESET = '1') then
22 			t_cnt <= unsigned(DIN);
23 		elsif (rising_edge(CLK)) then
27                      t_cnt <= t_cnt - 1; -- decr
30 		end if;
31	 end process;
32 	 COUNT <= std_logic_vector(t_cnt);
33 end my_count
