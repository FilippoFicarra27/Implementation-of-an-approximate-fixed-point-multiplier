library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Approximate_Full_Adder is
 Port ( 
    A,B,C: in std_logic;
    Sum, Cout: out std_logic);
end Approximate_Full_Adder;

architecture Behavioral of Approximate_Full_Adder is

begin
    Sum<=not(A or(B and C));
    Cout<=A or(B and C);
end Behavioral;