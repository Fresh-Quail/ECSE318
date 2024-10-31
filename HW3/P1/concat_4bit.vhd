library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity concat_4bit is
    
    port (
        A : in STD_LOGIC_VECTOR(1 downto 0); -- Input vector A
        B : in STD_LOGIC_VECTOR(1 downto 0); -- Input vector B
        output : out STD_LOGIC_VECTOR(3 downto 0) -- Output concatenation of A and B
    );
end entity concat_4bit;

architecture structural of concat_4bit is
begin
    output <= A & B; -- Concatenate A and B
end architecture structural;