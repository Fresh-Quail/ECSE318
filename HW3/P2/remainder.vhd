library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity remainder is
    generic (
        N : integer := 4
    );
    port (
        control : in std_logic;
        A, B    : in std_logic_vector(N-1 downto 0);
        Cin : in std_logic;
        S   : out std_logic_vector(N-1 downto 0)
    );
end remainder;

architecture logic of remainder is
    signal op2  :   std_logic_vector(N-1 downto 0) := (others => '0');
    signal Cout :   std_logic_vector(N-1 downto 0) := (others => '0');
begin
    op2(0) <= B(0) and control;
    Cout(0) <= (A(0) and op2(0)) or (A(0) and Cin) or (op2(0) and Cin);
    S(0) <= A(0) xor op2(0) xor Cin;
    gen: for i in 1 to N-1 generate
        op2(i) <= B(i) and control;
        Cout(i) <= (A(i) and op2(i)) or (A(i) and Cout(i-1)) or (op2(i) and Cout(i-1));
        S(i) <= A(i) xor op2(i) xor Cout(i-1);
    end generate;
end logic;