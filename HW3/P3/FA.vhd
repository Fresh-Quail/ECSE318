library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity FA is
    port ( A, B, Cin: in STD_LOGIC;
    C, S: out STD_LOGIC);
    end entity FA;

    architecture structural of FA is

    begin

    S <= A XOR B XOR Cin ;
    C <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;
    end structural;
