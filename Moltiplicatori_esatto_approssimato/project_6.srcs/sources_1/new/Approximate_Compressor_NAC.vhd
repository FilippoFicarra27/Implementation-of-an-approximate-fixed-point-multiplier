library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Approximate_Compressor_NAC is
  Port ( A,B,C,D: in std_logic;
        Sum: out std_logic);
end Approximate_Compressor_NAC;

architecture Behavioral of Approximate_Compressor_NAC is

begin
    Sum<=(A or B) or (C or D);

end Behavioral;