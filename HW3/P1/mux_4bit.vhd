library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux_4bit is 
    

    port (
        sel : in STD_LOGIC; 
        A : in STD_LOGIC_VECTOR(3 downto 0); 
        B : in STD_LOGIC_VECTOR(3 downto 0); 
        mux_out : out STD_LOGIC_VECTOR(3 downto 0) 
    );
end entity mux_4bit;

architecture structural of mux_4bit is
begin
    process (sel, A, B) is
begin 
    if (sel = '1') then 
        mux_out <= B;
    else 
        mux_out <= A;
    end if;
end process;
end structural;
