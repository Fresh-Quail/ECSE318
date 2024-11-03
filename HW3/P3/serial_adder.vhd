library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

  entity serial_adder is 
    
    port (
        clear: in STD_LOGIC;
        set: in STD_LOGIC;
        clk : in STD_LOGIC;
        addend : in STD_LOGIC_VECTOR (7 downto 0); 
        augand : in STD_LOGIC_VECTOR(7 downto 0); 
        addend_output: out STD_LOGIC;
        augand_output: out STD_LOGIC;
        sum_output : out STD_LOGIC;
        C_in : out STD_LOGIC;
        Cout:  out STD_LOGIC
    );
end entity serial_adder;

architecture behavioral of serial_adder is
    
    --signal
    signal augand_wire: STD_LOGIC := '0';
    signal addend_wire: STD_LOGIC := '0';
    signal cin : STD_LOGIC := '0';
    signal cout_temp : STD_LOGIC := '0';
    signal sum_reg: STD_LOGIC := '0';


    component FA is 
        port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            C: out STD_LOGIC;
            S : out STD_LOGIC
        );
        end component;

    component d_flip_flop is 
        port(d, clk, set, clear: in STD_LOGIC;
            q: out STD_LOGIC);
        end component;

    component piso is 
        port(
        clk: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        reset: in STD_LOGIC;
        enable: in STD_LOGIC;
        piso_output: out STD_LOGIC);
    end component;

    component siso is 
        port(
        clk: in STD_LOGIC;
        set : in STD_LOGIC;
        reset: in STD_LOGIC;
        siso_input: in STD_LOGIC;
        siso_output: out STD_LOGIC);
    end component;

    begin
        FA_0: FA
        port map(
            A => addend_wire,
            B => augand_wire,
            Cin => cin,
            C => cout_temp,
            S => sum_reg
            
        );

        addend_reg: piso
        port map(
            clk => clk,
            data => addend,
            reset => clear,
            enable => set, 
            piso_output => addend_wire);

            augand_reg: piso
            port map(
                clk => clk,
                data => augand,
                reset => clear,
                enable => set, 
                piso_output => augand_wire);
            
        flip_flop: d_flip_flop
        port map(
            d => cout_temp, 
            clk => clk,
            set => set, 
            clear => clear,
            q => cin
            );
        
        sum_out: siso
        port map(
        clk => clk,
        set => set,
        reset => clear, 
        siso_input => sum_reg,
        siso_output => sum_output
        );

        addend_output <= addend_wire;
    augand_output <= augand_wire;

    Cout <= cout_temp;
    C_in <= cin;
       
        
        end architecture behavioral;
        
        

    
