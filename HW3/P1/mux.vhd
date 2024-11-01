library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux is 
    

    port (
        sel : in STD_LOGIC; 
        A : in STD_LOGIC; 
        B : in STD_LOGIC; 
        mux_out : out STD_LOGIC
    );
end entity mux;

architecture structural of mux is
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

