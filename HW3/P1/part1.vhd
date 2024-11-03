library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity part1 is
    port ( 
        A, B : in std_logic_vector(1 downto 0);
        Cin  : in std_logic;
        C : out std_logic;
        S : out std_logic_vector(1 downto 0)
    );
end entity part1;

architecture structural of part1 is
    signal carry : std_logic_vector(2 downto 0);
    signal sums : std_logic_vector(1 downto 0);
begin

    fullAdder00: entity work.FA     -- First stage adder when the carry in is zero
        port map(
            A => A(0),
            B => B(0),  
            Cin => Cin,
            C => carry(0),
            S => S(0)
        );

    fullAdder10: entity work.FA     -- Second stage adder when the carry in is zero
        port map(
            A => A(1),
            B => B(1),  
            Cin => '0',
            C => carry(1),
            S => sums(0)
        );

    fullAdder11: entity work.FA     -- Second stage adder when the carry in is one
        port map(
            A => A(1),
            B => B(1),  
            Cin => '1',
            C => carry(2),
            S => sums(1)
        );

    mux0: entity work.mux1bit(structural)       -- Mux for the carry
        port map(
            sel => carry(0),
            A => carry(1),
            B => carry(2),
            C => sums(0),
            D => sums(1),
            Cout => C,
            Sout => S(1)
        );
end structural;
