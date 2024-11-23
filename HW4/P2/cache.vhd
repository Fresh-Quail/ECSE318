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
  signal data_mem : data_array := ( -- Init memory for testbench
      16#12# => x"00000012",  -- 16#0012# converted to 32-bit
      16#45# => x"00000045",  -- 16#0045# converted to 32-bit
      16#76# => x"00000076",  -- 16#0076# converted to 32-bit
      16#66# => x"00000066",  -- 16#0066# converted to 32-bit
      16#59# => x"00000059",  -- 16#0059# converted to 32-bit
      others => (others => '0')
  );
  signal ready          : std_logic;

begin
  process(clk)
  variable index        : std_logic_vector(7 downto 0) := (others => '0');
  variable tag          : std_logic_vector(5 downto 0) := (others => '0');
  variable count        : std_logic_vector(2 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if (p_strobe = '1' or count /= "000") then
          index := address(9 downto 2);
          tag := address(15 downto 10);
            if pro_rw = '1' then
                if valid(to_integer(unsigned(index))) = '1' and tag_mem(to_integer(unsigned(index))) = tag then
                    -- cache hit logic
                    p_data_bus <= cache_mem(to_integer(unsigned(index)));
                    ready <= '1';
                    p_ready <= '1';
                else
                    -- cache miss logic
                    -- Cache miss: load from memory (wait 4 cycles)
                    if(count = "100") then
                      valid(to_integer(unsigned(index))) <= '1';
                      tag_mem(to_integer(unsigned(index))) <= tag;
                      cache_mem(to_integer(unsigned(index))) <= data_mem(to_integer(unsigned(address)));
                      p_data_bus <= data_mem(to_integer(unsigned(address)));
                      p_ready <= '1';
                      count := "000";
                    else
                      count := count + "001";
                      p_ready <= '0';
                      p_data_bus <= (others => 'Z');
                    end if;
                end if;
            else
              if(count = "100") then
                valid(to_integer(unsigned(index))) <= '1';
                tag_mem(to_integer(unsigned(index))) <= tag;
                cache_mem(to_integer(unsigned(index))) <= p_data_bus;
                data_mem(to_integer(unsigned(address))) <= p_data_bus;
                p_ready <= '1';
                ready <= '1';
                count := "000";
              else
                count := count + "001";
                p_ready <= '0';
                p_data_bus <= (others => 'Z');
              end if;
            end if;
      else
        if(ready = '1') then
          ready <= '0';
          p_ready <= '0';
          p_data_bus <= (others => 'Z');
        end if;
      end if; -- p_strobe endif
    end if; -- clk endif
  end process;
end architecture behavioral;


      


    

