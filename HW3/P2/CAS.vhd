library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity CAS is
    generic (
        N : integer := 4
    );
    port (
        control : in std_logic;
        A, B    : in std_logic_vector(N-1 downto 0);
        C   : out std_logic;
        S   : out std_logic_vector(N-1 downto 0)
    );
end CAS;

architecture logic of CAS is
    signal op2  :   std_logic_vector(N-1 downto 0) := (others => '0');
    signal Cout :   std_logic_vector(N-1 downto 0) := (others => '0');
begin
    op2(0) <= B(0) xor control;
    Cout(0) <= (A(0) and op2(0)) or (A(0) and control) or (op2(0) and control);
    S(0) <= A(0) xor op2(0) xor control;
    gen: for i in 1 to N-1 generate
        op2(i) <= B(i) xor control;
        Cout(i) <= (A(i) and op2(i)) or (A(i) and Cout(i-1)) or (op2(i) and Cout(i-1));
        S(i) <= A(i) xor op2(i) xor Cout(i-1);
    end generate;
    C <= Cout(N-1);
end logic;