library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity concat is
    generic (
        N : integer := 1; -- 
      
    );
    --generic (
      --  M : integer := 2 * N;
    --);
    constant M : integer := 2*N;
    port( A, B:  in STD_LOGIC_VECTOR(N-1 downto 0);
        Out: out in STD_LOGIC_VECTOR(M-1 downto 0)
    );
    end entity concat;

    architecture structural of concat is
       constant
    begin
        Out <= A & B;
    end structural;
