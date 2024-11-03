library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;

entity mux is 
    generic (
         N : integer := 1
    );
    port (
        sel : in std_logic;
        A : in std_logic; 
        B : in std_logic; 
        C : in STD_LOGIC_VECTOR(N-1 downto 0); 
        D : in STD_LOGIC_VECTOR(N-1 downto 0); 
        Cout : out std_logic;
        Sout : out STD_LOGIC_VECTOR(N-1 downto 0) 
    );
end entity mux;

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  
entity mux1bit is 
    generic (
         N : integer := 1
    );
    port (
        sel : in std_logic;
        A : in std_logic; 
        B : in std_logic; 
        C : in std_logic; 
        D : in std_logic; 
        Cout : out std_logic;
        Sout : out std_logic 
    );
end entity mux1bit;

architecture structural of mux is
begin 
    cout <= B when sel = '1' else A;
    sout <= D when sel = '1' else C;
end structural;
