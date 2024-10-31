library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity concat is
    
    port (
        A : in STD_LOGIC; -- Input vector A
        B : in STD_LOGIC; -- Input vector B
        output : out STD_LOGIC_VECTOR(1 downto 0) -- Output concatenation of A and B
    );
end entity concat;

architecture structural of concat is
begin
    output <= A & B; -- Concatenate A and B
end architecture structural;