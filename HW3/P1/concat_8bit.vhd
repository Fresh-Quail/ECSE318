library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity concat_8bit is
    
    port (
        A : in STD_LOGIC_VECTOR(3 downto 0); -- Input vector A
        B : in STD_LOGIC_VECTOR(3 downto 0); -- Input vector B
        output : out STD_LOGIC_VECTOR(7 downto 0) -- Output concatenation of A and B
    );
end entity concat_8bit;

architecture structural of concat_8bit is
begin
    output <= A & B; -- Concatenate A and B
end architecture structural;