library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;

entity fullmod is 
    port (
        -- Signals that exclusively simulate a processor - we decide what the processor is requesting explicitly
        clk, inprw, inp_strobe  : in STD_LOGIC;
        in_addr                 : in STD_LOGIC_VECTOR(15 downto 0);
        data_in                 : in STD_LOGIC_VECTOR(31 downto 0);
        -- outputs for testbench simulation
        data_out                : out STD_LOGIC_VECTOR(31 downto 0) -- Data received from cache by processor
    );
end entity fullmod;

architecture structural of fullmod is
    -- Signals that exist exclusively between the processor and cache memory
    signal prw      : std_logic;
    signal strobe   : std_logic;
    signal ready    : std_logic;
    signal addr     : std_logic_vector(15 downto 0);
    signal data_bus : std_logic_vector(31 downto 0);

begin 
    processor: entity work.processor
    port map(
        clk => clk,
        inprw => inprw, 
        inp_strobe => inp_strobe,
        in_addr => in_addr,
        data_in => data_in,
        out_addr => addr,
        data_bus => data_bus,
        ready => ready,
        outprw => prw, 
        outp_strobe => strobe
    );

    cache: entity work.cache
    port map(
    clk => clk,
    pro_rw => prw,
    p_strobe => strobe,
    address => addr,
    p_ready => ready,
    p_data_bus => data_bus
    );
    data_out <= data_bus;
end structural;
