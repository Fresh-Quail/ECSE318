library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;

entity processor is 
    port (
        inprw, inp_strobe: in STD_LOGIC;
        in_addr        : in STD_LOGIC_VECTOR(15 downto 0);
        data_in     : in STD_LOGIC_VECTOR(31 downto 0);
        -- The above inputs are to 'simulate' the processor from the testbench
        -- The below signals are meant for the cache and are handled by the processor logic
        data_bus    : inout STD_LOGIC_VECTOR(31 downto 0);
        out_addr    : out STD_LOGIC_VECTOR(15 downto 0);
        ready     : in STD_LOGIC;
        outprw, outp_strobe: out STD_LOGIC
    );
end entity processor;

    architecture structural of processor is
    begin 
        outprw <= inprw;
        outp_strobe <= inp_strobe;
        data_bus <= data_in when ready = '0' else (others => 'Z'); -- Drive bus while transaction is not complete
    end structural;
