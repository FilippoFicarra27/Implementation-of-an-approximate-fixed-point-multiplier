library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Approximate_Multiplier_8bit is
  Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
        B : in STD_LOGIC_VECTOR (7 downto 0);
        Product : out STD_LOGIC_VECTOR (15 downto 0) );
end Approximate_Multiplier_8bit;

architecture Behavioral of Approximate_Multiplier_8bit is
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

    component Approximate_Half_Adder
        Port(
            A,B: in std_logic; 
            Sum: out std_logic
        );
    end component;
    
    component Approximate_Full_Adder
        Port ( 
            A,B,C: in std_logic;
            Sum, Cout: out std_logic
        );
    
    end component;
    
    component Approximate_Compressor_NAC
            Port ( A,B,C,D: in std_logic;
                    Sum: out std_logic
            );
    end component;
    
    component Error_correction_module
             Port (A,B,C,D: in std_logic;
                    O: out std_logic
              );
    end component;

type matrice is array (0 to 7, 0 to 7) of std_logic;
signal P: matrice;

type matrice2 is array (0 to 2, 0 to 15) of std_logic;
signal S, C, Co: matrice2;

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

            --metà  destra della matrice di prodotti parziali
    
            HA: Half_Adder port map (P(0,2), P(1,1), S(1,5), Co(0,5));	   
            NAC: Approximate_Compressor_NAC port map(P(0,3),P(1,2),P(2,1),P(3,0),S(1,1)); 
            NAC2: Approximate_Compressor_NAC port map(P(0,4),P(1,3),P(2,2),P(3,1),S(1,2)); 
            NAC3: Approximate_Compressor_NAC port map(P(0,5),P(1,4),P(2,3),P(3,2),S(1,3)); 
            NAC4: Approximate_Compressor_NAC port map(P(0,6),P(1,5),P(2,4),P(3,3),S(1,4)); 
    	    ECM: Error_correction_module port map(P(0,6),P(1,5),P(2,4),P(3,3), Co(0,7));
            AHA: Approximate_Half_Adder port map(P(4,1),P(5,0), S(2,2));  
            AFA: Approximate_Full_Adder port map(P(4,2),P(5,1),P(6,0), S(2,3), Co(1,7)); 
    
            --metà sinistra della matrice di prodotti parziali
           C1: Compressor4_2 port map(P(0,7),P(1,6), P(2,5), P(3,4), Co(0,7), S(1,8), Co(0,8), C(1,8));        
           C2: Compressor4_2 port map(P(1,7),P(2,6), P(3,5), P(4,4), Co(0,8), S(1,9), Co(0,9), C(1,9));
           C3: Compressor4_2 port map(P(2,7),P(3,6), P(4,5), P(5,4), Co(0,9), S(1,10), Co(0,10), C(1,10));
           C4: Compressor4_2 port map(P(3,7),P(4,6), P(5,5), P(6,4), Co(0,10), S(1,11), Co(0,11), C(1,11));
           FA: Full_Adder port map(P(4,7), P(5,6), Co(0,11), S(1,12), C(1,12));
           C5: Compressor4_2 port map(P(4,3),P(5,2), P(6,1), P(7,0), Co(1,7), S(2,8), Co(1,8),C(2,8));             
           C6: Compressor4_2 port map(P(5,3),P(6,2), P(7,1), '0', Co(1,8), S(2,9), Co(1,9),C(2,9));            
		   FA2: Full_Adder port map(P(6,3), P(7,2), Co(1,9), S(2,10), C(2,10));	
			
----------------------------------------------------------------------------------------------------------

--Secondo stadio di compressione

    --metà  destra	
	 		HA2: Half_Adder port map(P(0,1),P(1,0),SR1(1),CR1(2));
            AFA2: Approximate_Full_Adder port map(S(1,5),P(2,0),CR1(2),SR1(2),CR1(3));           
            AFA3: Approximate_Full_Adder port map(Co(0,5),S(1,1),CR1(3),SR1(3),CR1(4));           	
			AFA4: Approximate_Full_Adder port map(P(4,0),S(1,2),CR1(4),SR1(4),CR1(5));	
            AFA5: Approximate_Full_Adder port map(S(2,2),S(1,3),CR1(5),SR1(5),CR1(6));
			AFA6: Approximate_Full_Adder port map(S(2,3),S(1,4),CR1(6),SR1(6),CR1(7));
			
     --metà  sinistra
            FA7: Full_Adder port map(S(1,8), S(2,8), CR1(7), SR1(7),CR1(8));
            C8: Compressor4_2 port map(C(1,8),S(1,9),S(2,9),C(2,8), '0', SR1(8),Co(2,10), CR1(9));
            C9: Compressor4_2 port map(S(1,10),C(1,9),C(2,9),S(2,10), Co(2,10), SR1(9), Co(2,11),CR1(10));
            C10: Compressor4_2 port map(C(1,10), S(1,11), P(7,3), C(2,10), Co(2,11), SR1(10), Co(2,12), CR1(11));  
            C11: Compressor4_2 port map(S(1,12),C(1,11), P(6,5), P(7,4), Co(2,12), SR1(11), Co(2,13), CR1(12));  
            C12: Compressor4_2 port map(C(1,12),P(5,7),P(6,6), P(7,5), Co(2,13), SR1(12), Co(2,14), CR1(13));
            FA3: Full_Adder port map(P(6,7), Co(2,14), P(7,6), SR1(13),CR1(14));
            
------------------------------------------------------------------------------------------------------------------
			SR1(0) <= P(0,0);
			SR1(14) <= P(7,7);
			SR1(15) <= '0';
			CR1(15) <= '0';
			
			Product(0)<=SR1(0);
			Product(1)<=SR1(1);
			Product(2)<=SR1(2);
			Product(3)<=SR1(3);
			Product(4)<=SR1(4);
			Product(5)<=SR1(5);
			Product(6)<=SR1(6);
			
			Product(15 downto 7) <= SR1(15 downto 7) + CR1(15 downto 7);

end Behavioral;





