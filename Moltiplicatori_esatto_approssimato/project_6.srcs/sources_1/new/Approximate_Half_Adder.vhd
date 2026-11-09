library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Approximate_Half_Adder is
    Port(A,B: in std_logic; 
    Sum: out std_logic);
end Approximate_Half_Adder;

architecture Behavioral of Approximate_Half_Adder is

begin
    Sum<=A or B;

end Behavioral;