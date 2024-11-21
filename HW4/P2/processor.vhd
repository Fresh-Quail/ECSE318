library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;

entity processor is 
    port (
        clk, inprw, inp_strobe   : in STD_LOGIC;
        in_addr             : in STD_LOGIC_VECTOR(15 downto 0);
        data_in             : in STD_LOGIC_VECTOR(31 downto 0);
        -- The above inputs are to 'simulate' the processor from the testbench
        -- The below signals are meant for the cache and are handled by the processor logic
        ready       : in STD_LOGIC;
        out_addr    : out STD_LOGIC_VECTOR(15 downto 0);
        data_bus    : inout STD_LOGIC_VECTOR(31 downto 0);
        outprw, outp_strobe : out STD_LOGIC
    );
end entity processor;

architecture structural of processor is
begin 
    process(clk) begin
        if rising_edge(clk) then
            outprw <= inprw;
            out_addr <= in_addr;
            outp_strobe <= inp_strobe;
            if ready = '0' then
                -- Drive bus while transaction is not complete
                data_bus <= data_in;
            else 
                data_bus <= (others => 'Z'); -- Stop driving
            end if;
        end if;
    end process;
end structural;
