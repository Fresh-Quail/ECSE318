library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;


  entity piso is 
    port(clk: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        clear: in STD_LOGIC;
        set: in STD_LOGIC;
        piso_output: out STD_LOGIC);
    end entity piso;

    architecture behavioral of piso is
        signal memory : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    begin 
        process(clk, clear, set)
        begin 
            if (clear = '0') then
                piso_output <= '0';
                memory <= data;
            else if set = '0'  then
                if rising_edge(clk) then
                    piso_output <= memory(0);
                    
                   memory <= '0' & memory(7 downto 1);
            end if;
            end if;
            end if;
        end process;
    end behavioral;