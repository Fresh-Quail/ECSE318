library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FA is
    port ( A, B, Cin: in bit;
    C, S: out bit);
    end entity FA;

    architecture structural of FA is

    begin

    S <= A XOR B XOR Cin ;
    C <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;
    end structural;
