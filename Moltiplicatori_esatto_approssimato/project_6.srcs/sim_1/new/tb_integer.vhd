library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use ieee.MATH_REAL.all;	
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_integer is
end tb_integer;

architecture tbbrand_integer of tb_integer is
    
    signal A, B: std_logic_vector(7 downto 0); 
    signal Ris_esatto, Ris_approssimato : std_logic_vector(15 downto 0) := (others => '0');

    
    component Multiplier_8bit
        port (
            A, B : in std_logic_vector(7 downto 0);
            Product : out std_logic_vector(15 downto 0)
        );
    end component;

    component Approximate_Multiplier_8bit
        port (
            A, B : in std_logic_vector(7 downto 0);
            Product : out std_logic_vector(15 downto 0)
        );
    end component;

begin
    
    UUT1: Multiplier_8bit
        port map (
            A => A,
            B => B,
            Product => Ris_esatto
        );

    
    UUT2: Approximate_Multiplier_8bit
        port map (
            A => A,
            B => B,
            Product => Ris_approssimato
        );

    
    process
        variable seed1, seed2: integer := 55;	
        variable seed3, seed4: integer := 5;
        variable r1, r2 : real;
        constant max: integer := 255;
        constant min: integer := 0;
        variable ia, ib: integer;
        variable vA, vB: std_logic_vector(7 downto 0);
        FILE ft: text;
        variable l: line;
    begin

        file_open(ft,
        "C:/Users/Utente/Desktop/INGEGNERIA/Tesi/Valori_casuali/valori_integer.txt", 
        write_mode);   

        for i in 0 to 20000 loop
           
            uniform(seed1, seed2, r1); 
            ia := integer(round(r1 * real(max-min) + real(min) - 0.5));
            vA := conv_std_logic_vector(ia, 8);
            uniform(seed3, seed4, r2); 
            ib := integer(round(r2 * real(max-min) + real(min) - 0.5));
            vB := conv_std_logic_vector(ib, 8);	
            
            A <= vA;
            B <= vB;
            wait for 20 ns;
            write(l, string'("Valore di A: "));
            write(l, integer'(ia));
            writeline(ft, l);
            write(l, string'("Valore di B: "));
            write(l, integer'(ib));
            writeline(ft, l);
            write(l, string'("Risultato esatto: "));
            
            write(l, conv_integer(Ris_esatto));
            writeline(ft, l);
            write(l, string'("Risultato approssimato: "));
            write(l, conv_integer(Ris_approssimato));
            writeline(ft, l);
        end loop;
        file_close(ft);
        wait;
    end process;
end tbbrand_integer;