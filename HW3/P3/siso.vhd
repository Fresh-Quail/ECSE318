library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

  entity siso is 
    port(clk: in STD_LOGIC;
        set: in STD_LOGIC;
        reset: in STD_LOGIC;
        siso_input: in STD_LOGIC;
        siso_output: out STD_LOGIC);
    end entity siso;

    architecture behavioral of siso is
        signal qq : STD_LOGIC_VECTOR(7 downto 0) := (others => '0') ;

        begin
       siso_output <= qq(7);
            -- set and reset are active low
    process(clk, reset, set)
    begin
       
        if (reset = '0') then
            qq <= (others => '0');
        else if (set = '0') then 
            if rising_edge(clk) then
                qq <= siso_input & qq(7 downto 1);
                
            
          
        end if;
    end if;
end if;
    end process;
end behavioral;