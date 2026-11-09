library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Compressor4_2 is
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
end Compressor4_2;

architecture Behavioral of Compressor4_2 is
begin
    Sum <= A xor B xor C xor D xor Cin;
    Cout <= (C and (A xor B)) or (A and (not(A xor B)));
    Carry <= (Cin and(A xor B xor C xor D))or(D and (not(A xor B xor C xor D)));
end Behavioral;
