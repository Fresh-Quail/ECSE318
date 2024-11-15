library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  use IEEE.NUMERIC_STD.ALL;

  entity traffic_light_controller is 
    

    port (
        Sa : in STD_LOGIC;
        Sb: in STD_LOGIC;
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        Ga: out STD_LOGIC;
        Ya: out STD_LOGIC;
        Ra: out STD_LOGIC;
        Gb: out STD_LOGIC;
        Yb: out STD_LOGIC;
        Rb: out STD_LOGIC;
        state_test: out STD_LOGIC_VECTOR(3 downto 0)
    );
    end traffic_light_controller;

    architecture behavioral of traffic_light_controller is
        type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
        signal state, next_state : state_type;


    begin
        state_test <= std_logic_vector(to_unsigned(state_type'pos(state), state_test'length));
        --state transition
        process(clk, rst)
        begin
            if rst = '1' then
                state <= s0;
            elsif rising_edge(clk) then
                state <= next_state;
            end if;
        end process;

        --next state transition logic
        process(state, Sa, Sb)
        begin

            case state is
                when s0 =>
                next_state <= s1;

                when s1 =>
                next_state <= s2;

                when s2 =>
                next_state <= s3;

                when s3 =>
                next_state <= s4;

                when s4 =>
                next_state <= s5;
                
                when s5 =>
                if Sb = '0' then
                    next_state <= s5;
                else 
                    next_state <= s6;
                end if;

                when s6 =>
                next_state <= s7;
                
                when s7 =>
                next_state <= s8;
                
                when s8 =>
                next_state <= s9;

                when s9 =>
                next_state <= s10;

                when s10 =>
                next_state <= s11;

                when s11 =>
                if (Sa = '1' or Sb = '0') then
                next_state <= s12;
            else 
                next_state <= s11;
            end if;

                when s12 =>
                next_state <= s0;

                when others => 
                next_state <= s0;

            end case;
        end process;


        --output behavior
        Ga <= '1' when state = s0 or state = s1 or state = s2 or state = s3 or state = s4 or state = s5 else '0';
        Ya <= '1' when state = s6 else '0';
        Ra <= '1' when state = s7 or state = s8 or state = s9 or state = s10 or state = s11 or state = s12 else '0';
        Gb <= '1' when state = s7 or state = s8 or state = s9 or state = s10 or state = s11 else '0';
        Yb <= '1' when state = s12 else '0';
        Rb <= '1'  when state = s0 or state = s1 or state = s2 or state = s3 or state = s4 or state = s5 or state = s6 else '0';


    end behavioral;
    

