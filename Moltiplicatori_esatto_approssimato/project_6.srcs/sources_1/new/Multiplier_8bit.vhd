library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity Multiplier_8bit is
    Port (
        A : in STD_LOGIC_VECTOR (7 downto 0);
        B : in STD_LOGIC_VECTOR (7 downto 0);
        Product : out STD_LOGIC_VECTOR (15 downto 0)
    );
end Multiplier_8bit;

architecture Behavioral of Multiplier_8bit is

    component Half_Adder
        Port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Sum : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    component Full_Adder
        Port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            Sum : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    component Compressor4_2
        Port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            C : in STD_LOGIC;
            D : in STD_LOGIC;
            Cin : in STD_LOGIC;
            Sum : out STD_LOGIC;
            Cout : out STD_LOGIC;
            Carry : out STD_LOGIC
        );
    end component;




    type matrice is array (0 to 7, 0 to 7) of std_logic;
    signal P: matrice;
    
    type matrice2 is array (0 to 2, 0 to 15) of std_logic;
    signal S, C, Co, SR, COR, CR: matrice2;	  
	
    signal SR1,CR1: std_logic_vector(15 downto 0);
begin

   process(A,B)
    begin
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                P(i,j) <= A(j) and B(i);
            end loop;
        end loop;
    end process;
--Primo stadio di compressione  
HA: Half_Adder port map (P(0,4), P(1,3), S(1,5), Co(0,5));
C1: Compressor4_2 port map(P(0,5),P(1,4), P(2,3), P(3,2), Co(0,5), S(1,6), Co(0,6), C(1,6));
C2: Compressor4_2 port map(P(0,6),P(1,5), P(2,4), P(3,3), Co(0,6), S(1,7), Co(0,7), C(1,7));
C3: Compressor4_2 port map(P(0,7),P(1,6), P(2,5), P(3,4), Co(0,7), S(1,8), Co(0,8), C(1,8));
C4: Compressor4_2 port map(P(1,7),P(2,6), P(3,5), P(4,4), Co(0,8), S(1,9), Co(0,9), C(1,9));
C5: Compressor4_2 port map(P(2,7),P(3,6), P(4,5), P(5,4), Co(0,9), S(1,10), Co(0,10), C(1,10));          
C6: Compressor4_2 port map(P(3,7),P(4,6), P(5,5), P(6,4), Co(0,10), S(1,11), Co(0,11), C(1,11));
FA: Full_Adder port map(P(4,7), P(5,6), Co(0,11), S(1,12), C(1,12));
HA2: Half_Adder port map(P(4,2), P(5,1), S(2,7), Co(1,7));
C7: Compressor4_2 port map(P(4,3),P(5,2), P(6,1), P(7,0), Co(1,7), S(2,8), Co(1,8),C(2,8));            
C7_3: Compressor4_2 port map(P(5,3),P(6,2), P(7,1), '0', Co(1,8), S(2,9), Co(1,9),C(2,9));            
FA2: Full_Adder port map(P(6,3), P(7,2), Co(1,9), S(2,10), C(2,10));	
--Secondo stadio di compressione
FA4: Full_Adder port map(P(0,2), P(1,1), P(2,0), SR1(2), CR1(3));
C8: Compressor4_2 port map(P(0,3), P(1,2), P(2,1), P(3,0), '0', SR1(3), Co(2,5), CR1(4));
C9: Compressor4_2 port map(S(1,5),P(2,2), P(3,1), P(4,0),Co(2,5), SR1(4), Co(2,6), CR1(5));
C10: Compressor4_2 port  map(S(1,6),P(4,1),P(5,0), '0',Co(2,6), SR1(5),Co(2,7), CR1(6));
C11: Compressor4_2 port map(C(1,6),S(1,7),S(2,7),P(6,0),Co(2,7),SR1(6),Co(2,8), CR1(7 ));
C12: Compressor4_2 port map(S(1,8),C(1,7),'0',S(2,8),Co(2,8), SR1(7), Co(2,9), CR1(8));
C13: Compressor4_2 port map(C(1,8),S(1,9),S(2,9),C(2,8), Co(2,9), SR1(8),Co(2,10), CR1(9));
C14: Compressor4_2 port map(S(1,10),C(1,9),C(2,9),S(2,10), Co(2,10), SR1(9), Co(2,11),CR1(10));
C15: Compressor4_2 port map(C(1,10), S(1,11), P(7,3), C(2,10), Co(2,11), SR1(10), Co(2,12), CR1(11));
C16: Compressor4_2 port map(S(1,12),C(1,11), P(6,5), P(7,4), Co(2,12), SR1(11), Co(2,13), CR1(12));
C17: Compressor4_2 port map(C(1,12),P(5,7),P(6,6), P(7,5), Co(2,13), SR1(12), Co(2,14), CR1(13));
FA5: Full_Adder port map(P(6,7), Co(2,14), P(7,6), SR1(13),CR1(14));
            
      		 
			SR1(0) <= P(0,0);
			SR1(1) <= P(1,0);
			SR1(14) <= P(7,7);
			SR1(15) <= '0';
			
			CR1(0) <= '0';
			CR1(1) <= P(0,1);
			CR1(2) <= '0';
			CR1(15) <= '0';
			
			Product <= SR1+ CR1;
			

end Behavioral;


