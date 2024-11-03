library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    port ( 
        A, B, Cin: in std_logic;
        C, S: out std_logic
    );
end entity FA;

architecture structural of FA is

begin
    S <= A XOR B XOR Cin;
    C <= (A AND B) OR (Cin AND A) OR (Cin AND B);
end structural;
