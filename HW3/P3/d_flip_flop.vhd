library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity d_flip_flop is 
    port(d, clk, clear, set: in STD_LOGIC;
    q: out STD_LOGIC);
end d_flip_flop;

architecture behavioral of d_flip_flop is
begin 
    process(clk, clear, set)
    begin 
      if(clear = '0') then 
        q <= '0';
      else
        if (set = '0') then
       if(rising_edge(clk)) then
       q <= d; 
      end if;
       end if;
    end if;        
    end process;  
   end behavioral; 
