library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.MATH_REAL.all;	
use std.textio.all;
use ieee.std_logic_textio.all;


entity tb_image_multiplication is
end tb_image_multiplication;


architecture behavior of tb_image_multiplication is
    signal A, B: std_logic_vector(7 downto 0); 
    signal Ris_esatto, Ris_approssimato: std_logic_vector(15 downto 0); 
    
    
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
        variable A_value, B_value: integer;
        variable result_value1, result_value2: integer;
        FILE image1_file, image2_file, result_file1, result_file2: text;
        variable line1, line2: line;
        variable header_line: line;
    begin     
        file_open(image1_file, 
        "C:/Users/Utente/Desktop/INGEGNERIA/Tesi/Nuove_immagini/th_1.pgm", 
        read_mode);
        file_open(image2_file, 
        "C:/Users/Utente/Desktop/INGEGNERIA/Tesi/Nuove_immagini/th_2.pgm", 
        read_mode);
        file_open(result_file1, 
        "C:/Users/Utente/Desktop/INGEGNERIA/Tesi/Nuove_immagini/risultato_esatto_1x2.pgm", 
        write_mode);
        file_open(result_file2, 
        "C:/Users/Utente/Desktop/INGEGNERIA/Tesi/Nuove_immagini/risultato_approssimato_1x2.pgm", 
        write_mode);

        
        readline(image1_file, header_line);
        readline(image1_file, header_line); 
        readline(image1_file, header_line); 
        readline(image1_file, header_line); 

        readline(image2_file, header_line);
        readline(image2_file, header_line); 
        readline(image2_file, header_line); 
        readline(image2_file, header_line); 


        while not endfile(image1_file) and not endfile(image2_file) loop
            readline(image1_file, line1);
            readline(image2_file, line2);
            read(line1, A_value);
            read(line2, B_value);
       
            A <= conv_std_logic_vector(A_value, 8);
            B <= conv_std_logic_vector(B_value, 8);

            wait for 0.001 ns;
    
            result_value1 := conv_integer(unsigned(Ris_esatto));
            result_value2 :=conv_integer(unsigned(Ris_approssimato));
            write(line1, result_value1);
            writeline(result_file1, line1);
            write(line1, result_value2);
            writeline(result_file2, line1);
        end loop;

        file_close(image1_file);
        file_close(image2_file);
        file_close(result_file1);
        file_close(result_file2);
        wait;
    end process;
end behavior;
