library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conditionalAdder is
    port (
        A, B   : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
        C   : out std_logic;
        S   : out std_logic_vector(7 downto 0)
    );
end entity conditionalAdder;

architecture logic of conditionalAdder is
    type DD is array (0 to 2) of std_logic_vector(1 downto 0);
    type SDD is array (0 to 2) of std_logic_vector(3 downto 0);
    type muxes is array (0 to 1) of std_logic_vector(1 downto 0);
    signal c2  : std_logic;
    signal c4  : std_logic;
    signal c8  : std_logic_vector(1 downto 0);

    signal carries  : DD;
    signal sums     : SDD;
    signal mux_sums : muxes;
    signal tempC : std_logic_vector(3 downto 0);
    signal tempD : std_logic_vector(3 downto 0);
begin

    cAdder00: entity work.part1     
    -- First stage adder when the carry in is zero
        port map(
            A => A(1 downto 0),
            B => B(1 downto 0),  
            Cin => Cin,
            C => c2,
            S => S(1 downto 0)
        );
        
    cAdder01: entity work.part2     
    -- First stage adder when the carry in is one
        port map(
            A => A(3 downto 2),
            B => B(3 downto 2),  
            C => carries(0),
            S => sums(0)
        );

    fullAdder10: entity work.part2     
    -- Second stage adder when the carry in is zero
        port map(
            A => A(5 downto 4),
            B => B(5 downto 4),  
            C => carries(1),
            S => sums(1)
        );

    fullAdder11: entity work.part2     
    -- Second stage adder when the carry in is one
        port map(
            A => A(7 downto 6),
            B => B(7 downto 6),  
            C => carries(2),
            S => sums(2)
        );

    mux0: entity work.mux       
    -- Mux for second stage    
        port map(
            sel => c2,
            A => carries(0)(0),
            B => carries(0)(1),
            C => sums(0)(1 downto 0),
            D => sums(0)(3 downto 2),
            Cout => c4,
            Sout => S(3 downto 2)
        );

    mux10: entity work.mux
           -- 4th stage mux when the carry is zero
        port map(
            sel => carries(1)(0),
            A => carries(2)(0),             -- Carry when carryin is zero
            B => carries(2)(1),             -- Carry when carryin is one
            C => sums(2)(1 downto 0),       -- Sum when carryin is zero
            D => sums(2)(3 downto 2),       -- Sum when carryin is one
            Cout => c8(0),
            Sout => mux_sums(0)
        );
    
    mux11: entity work.mux       
    -- Mux when the carry is one
        port map(
            sel => carries(1)(1),
            A => carries(2)(0),             -- Carry when carryin is zero
            B => carries(2)(1),             -- Carry when carryin is one
            C => sums(2)(1 downto 0),       -- Sum when carryin is zero
            D => sums(2)(3 downto 2),       -- Sum when carryin is one
            Cout => c8(1),
            Sout => mux_sums(1)
        );


    tempC <= mux_sums(0) & sums(1)(1 downto 0);
    tempD <= mux_sums(1) & sums(1)(3 downto 2);
    mux: entity work.mux
    -- Final mux
        generic map(
            N => 4
        )
        port map(
            sel => c4,
            A => c8(0),
            B => c8(1),
            C => tempC,
            D => tempD,
            Cout => C,
            Sout => S(7 downto 4)
        );
end logic;
