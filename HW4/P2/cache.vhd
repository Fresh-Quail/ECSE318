library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  use IEEE.NUMERIC_STD.ALL;
entity cache is 
  port(
    -- in_data: in STD_LOGIC_VECTOR(31 downto 0);
    -- p_address: in STD_LOGIC_VECTOR(15 downto 0);
    -- clk: in STD_LOGIC;
    -- p_strobe: in STD_LOGIC;
    -- pro_rw: in STD_LOGIC;
    -- p_ready: out STD_LOGIC;
    -- sys_rw: out STD_LOGIC;
    -- sys_address: out STD_LOGIC_VECTOR(15 downto 0);
    -- p_out_data: out std_logic_vector(31 downto 0);
    -- out_data: out STD_LOGIC_VECTOR(8 downto 0)
    clk: in STD_LOGIC;
    pro_rw: in STD_LOGIC;
    p_strobe: in STD_LOGIC;
    address: in STD_LOGIC_VECTOR(15 downto 0);
    p_ready: out STD_LOGIC;
    p_data_bus: inout std_logic_vector(31 downto 0)
  );
end entity cache;

architecture behavioral of cache is
  type data_array is array(0 to (2**16)-1) of std_logic_vector(31 downto 0);
  type tag_array is array (0 to (2**8)-1) of std_logic_vector(5 downto 0); 
  type valid_array is array (0 to (2**8)-1) of std_logic;
  type cache_memory is array (0 to (2**8)-1) of std_logic_vector(31 downto 0);

  signal valid    : valid_array := (others => '0');
  signal tag_mem  : tag_array := (others => (others => '0'));
  signal cache_mem  : cache_memory := (others => (others => '0'));
  signal data_mem : data_array := (others => (others => '0'));

begin
  -- data_mem(1) <= "11111111111111111111111111111111";
  process
begin
    data_mem(0) <= "11111111111111111111111111111111";  -- Assign at index 0
    data_mem(1) <= "00000000000000000000000000000001";  -- Assign at index 1
    wait; -- Prevent re-triggering
end process;

  process(clk)
  variable index        : std_logic_vector(7 downto 0);
  variable tag          : std_logic_vector(5 downto 0);
  begin
  
    if rising_edge(clk) then
        if (p_strobe = '1') then
          index := address(9 downto 2);
          tag := address(15 downto 10);
            if pro_rw = '1' then
                if valid(to_integer(unsigned(index))) = '1' and tag_mem(to_integer(unsigned(index))) = tag then
                    -- cache hit logic
                    p_data_bus <= cache_mem(to_integer(unsigned(index)));
                    p_ready <= '1';
                else
                    -- cache miss logic
                    -- Cache miss: load from memory (wait 4 cycles)
                    valid(to_integer(unsigned(index))) <= '1';
                    tag_mem(to_integer(unsigned(index))) <= tag;
                    cache_mem(to_integer(unsigned(index))) <= data_mem(to_integer(unsigned(address)));
                    p_data_bus <= data_mem(to_integer(unsigned(address))) after 400 ps; 
                    p_ready <= '1' after 400 ps;
                end if;
            else
                -- write to cache and memory                    
                valid(to_integer(unsigned(index))) <= '1';
                tag_mem(to_integer(unsigned(index))) <= tag;
                cache_mem(to_integer(unsigned(index))) <= p_data_bus after 400 ps;

                data_mem(to_integer(unsigned(address))) <= p_data_bus after 400 ps;
                p_ready <= '1' after 400 ps;
            end if;
        end if;
    end if;
  end process;
end architecture behavioral;


      


    

