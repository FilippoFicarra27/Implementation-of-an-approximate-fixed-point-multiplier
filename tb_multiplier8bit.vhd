library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_multiplier8bit is
end tb_multiplier8bit;

architecture Behavioral of tb_multiplier8bit is

    component Multiplier_8bit
        Port (
            A : in STD_LOGIC_VECTOR (7 downto 0);
            B : in STD_LOGIC_VECTOR (7 downto 0);
            Product : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    
    signal A : STD_LOGIC_VECTOR(7 downto 0);
    signal B : STD_LOGIC_VECTOR(7 downto 0);
    signal Product : STD_LOGIC_VECTOR(15 downto 0);

begin
    
    dut: Multiplier_8bit
        port map (A,B, Product);

        A <= "00000011" after 1 ns,
        "00000101" after 2 ns, "11111111" after 3 ns, 
        "11111111"  after 4 ns, "10101010" after 5 ns,"00000000" after 6ns,
       "10000000" after 7ns, "01111111" after 8ns, "01010101" after 9ns, "11001100" after 10ns;
        B <= "00000010" after 1 ns,
         "00000101" after 2ns, "00000001"  after 3 ns, 
         "11111111"  after 4 ns, "01010101" after 5 ns, "10101010" after 6ns,
        "00000010" after 7ns, "00000010" after 8ns, "00110011" after 9ns, "10101010" after 10ns;
       
 

end Behavioral;
