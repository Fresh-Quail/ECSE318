library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity part2 is
    port ( 
        A, B: in std_logic_vector(1 downto 0);
        C : out std_logic_vector(1 downto 0);
        S : out std_logic_vector(3 downto 0)
    );
end entity part2;

architecture structural of part2 is
    type DD is array (0 to 1) of std_logic_vector(1 downto 0);
    signal carries  : DD;
    signal sums     : std_logic_vector(1 downto 0);
begin

    fullAdder00: entity work.FA     
    -- First stage adder when the carry in is zero
        port map(
            A => A(0),
            B => B(0),  
            Cin => '0',
            C => carries(0)(0),
            S => S(0)
        );
        
    fullAdder01: entity work.FA     
    -- First stage adder when the carry in is one
        port map(
            A => A(0),
            B => B(0),  
            Cin => '1',
            C => carries(0)(1),
            S => S(2)
        );

    fullAdder10: entity work.FA     
    -- Second stage adder when the carry in is zero
        port map(
            A => A(1),
            B => B(1),  
            Cin => '0',
            C => carries(1)(0),
            S => sums(0)
        );

    fullAdder11: entity work.FA     
    -- Second stage adder when the carry in is one
        port map(
            A => A(1),
            B => B(1),  
            Cin => '1',
            C => carries(1)(1),
            S => sums(1)
        );

    mux0: entity work.mux1bit(structural)       -- Mux when the carry is zero
        port map(
            sel => carries(0)(0),
            A => carries(1)(0),
            B => carries(1)(1),
            C => sums(0),
            D => sums(1),
            Cout => C(0),
            Sout => S(1)
        );

    mux1: entity work.mux1bit(structural)       -- Mux when the carry is 1
        port map(
            sel => carries(0)(1),
            A => carries(1)(0),
            B => carries(1)(1),
            C => sums(0),
            D => sums(1),
            Cout => C(1),
            Sout => S(3)
        );
end structural;
