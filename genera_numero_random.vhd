library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use ieee.MATH_REAL.all;	
use std.textio.all;
use ieee.std_logic_textio.all;	

entity tb is
end tb;
architecture tbbrand of tb is
signal A,B: std_logic_vector(7 downto 0); 
 signal Ris_esatto,Ris_approx :  std_logic_vector(15 downto 0);
begin				  

	process
	variable seed1, seed2: integer := 55;	
	variable seed3, seed4: integer := 5;
      variable r1,r2 : real;
	  constant max: integer := 255;
	  constant min: integer := 0;
	  variable ia,ib: integer;
	  variable vA,vB: std_logic_vector(7 downto 0);
	  variable vR :  std_logic_vector(15 downto 0);
	  FILE ft: text;
 variable l: line;
	  begin		
		
		  file_open(ft,"C:\Users\filip\valori.txt", write_mode);  
		for i in 0 to 20000 loop
  		uniform(seed1, seed2, r1); 
		ia := integer (round(r1 * real(max-min) + real(min) - 0.5));
		vA := conv_std_logic_vector(ia,8);	  
		uniform(seed1, seed2, r2); 
		ib := integer (round(r2 * real(max-min) + real(min) - 0.5));
		vB := conv_std_logic_vector(ib,8);	
		
		write(l, Ris_esatto);
		writeline(ft,l);
		write(l, Ris_approx);
		writeline(ft,l);
		
		A<= vA;
		B<= vB;
		
		wait for 10 ns;
		end loop;
		file_close(ft);	
		wait;
	end  process;
end tbbrand;
