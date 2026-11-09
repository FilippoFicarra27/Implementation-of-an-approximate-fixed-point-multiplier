library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Error_correction_module is
 Port (A,B,C,D: in std_logic;
       O: out std_logic );
end Error_correction_module;

architecture Behavioral of Error_correction_module is

begin
    O<= (A or B) and (C or D);

end Behavioral;
