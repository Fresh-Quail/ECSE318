library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  use IEEE.NUMERIC_STD.ALL;
entity cache is 
    port(
       in_data: in STD_LOGIC_VECTOR(31 downto 0);
       p_address: in STD_LOGIC_VECTOR(15 downto 0);
       clk: in STD_LOGIC;
       p_strobe: in STD_LOGIC;
       pro_rw: in STD_LOGIC;
       p_ready: out STD_LOGIC;
       sys_rw: out STD_LOGIC;
       sys_address: out STD_LOGIC_VECTOR(15 downto 0);
       p_out_data: out std_logic_vector(31 downto 0);
       out_data: out STD_LOGIC_VECTOR(8 downto 0) 
    );

    end entity cache;

    architecture behavioral of cache is
      constant block_size : integer := 4;
      constant line_size: integer := 256;
      type data_array is array(0 to line_size-1) of std_logic_vector(8*block_size-1 downto 0);
      type tag_array is array (0 to line_size-1) of std_logic_vector(5 downto 0); 
      type valid_array is array (0 to line_size-1) of std_logic;

      signal data_mem : data_array := (others => (others => '0'));
      signal tag_mem  : tag_array := (others => (others => '0'));
      signal valid    : valid_array := (others => '0');

      signal tag, index, byte_offset : std_logic_vector(15 downto 0);
      signal selected_data           : std_logic_vector(7 downto 0);
      signal cache_hit               : std_logic;

    begin
      tag <= address(15 downto 10);
      index <= address(9 downto 2); 
      byte_offset <= address(1 downto 0); 
      
      process(clk, p_strobe)
      begin
        if rising_edge(clk) then
          if (p_strobe = '1') then 
            if valid(to_integer(unsigned(index))) = '1' and tag_mem(to_integer(unsigned(index))) = tag then
                    cache_hit <= '1';
                else
                    cache_hit <= '0';
                end if;
            
                if pro_rw = '1' then
                  -- read operation
                  if cache_hit = '1' then
                      -- cache hit
                      selected_data <= data_mem(to_integer(unsigned(index)))(to_integer(unsigned(byte_offset)*8+7) downto to_integer(unsigned(byte_offset)*8));
                      out_data <= selected_data;
                  else
                      -- Cache miss: Return default data (or load from memory in a real system)
                      out_data <= (others => '0');
                  end if;
            
           
    end architecture behavioral;


      


    

