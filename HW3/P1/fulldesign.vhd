library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

  

entity fulldesign is 
    
    port (
        Cin : in STD_LOGIC;
        X : in STD_LOGIC_VECTOR (7 downto 0); 
        Y : in STD_LOGIC_VECTOR(7 downto 0); 
        Sum_out : out STD_LOGIC_VECTOR(7 downto 0);
        Cout:  out STD_LOGIC
    );
end entity fulldesign;

architecture behavioral of fulldesign is
    signal sum_0, sum_1 : STD_LOGIC_VECTOR (7 downto 0); 
    signal carry_0, carry_1 : STD_LOGIC_VECTOR (7 downto 0);
    signal carry_out_0th_stage: STD_LOGIC := Cin; 
    signal first_stage_sum_mux : STD_LOGIC_VECTOR (7 downto 0);
    signal first_stage_carry_mux : STD_LOGIC_VECTOR (7 downto 0);
    
    -- declaration of component
    -- 0th FA instantiation
    component FA is 
        port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            C: out STD_LOGIC;
            S : out STD_LOGIC
        );
        end component;

    component mux is 
        port (
            sel : in STD_LOGIC; 
        A : in STD_LOGIC; 
        B : in STD_LOGIC; 
        mux_out : out STD_LOGIC
        );
    end component;
    
    component mux_2bit is 
      port (
        sel : in STD_LOGIC; 
        A : in STD_LOGIC_VECTOR(1 downto 0); 
        B : in STD_LOGIC_VECTOR(1 downto 0); 
        mux_out : out STD_LOGIC_VECTOR(1 downto 0) 
    );
    end component;

    component mux_4bit is 
        port (
            sel : in STD_LOGIC; 
        A : in STD_LOGIC_VECTOR(3 downto 0); 
        B : in STD_LOGIC_VECTOR(3 downto 0); 
        mux_out : out STD_LOGIC_VECTOR(3 downto 0)  
        );
    end component;

    component concat is 
        port (
            A : in STD_LOGIC; -- Input vector A
            B : in STD_LOGIC; -- Input vector B
            output : out STD_LOGIC_VECTOR(1 downto 0) -- Output concatenation of A and B
        );
    end component;

    component concat_4bit is 
        port (
            A : in STD_LOGIC_VECTOR(1 downto 0); -- Input vector A
            B : in STD_LOGIC_VECTOR(1 downto 0); -- Input vector B
            output : out STD_LOGIC_VECTOR(3 downto 0) -- Output concatenation of A and B
        );
    end component;

    component concat_8bit is 
        port (
            A : in STD_LOGIC_VECTOR(3 downto 0); -- Input vector A
            B : in STD_LOGIC_VECTOR(3 downto 0); -- Input vector B
            output : out STD_LOGIC_VECTOR(7 downto 0) -- Output concatenation of A and B
        );
    end component;

        begin 
            FA_0: FA 
                port map (
                    A => X(0),
                    B => Y(0),
                    Cin => Cin,
                    C => carry_out_0th_stage,
                    S => sum_0(0)
                );
                    -- full adder with carry in as 0 and 1
            FA_1_to_7_Cin_0: for i in 1 to 7 generate
                FA_inst: entity work.FA port map(
                    A => X(i downto i),
                    B => Y(i downto i),
                    Cin => "0",
                    C => carry_0(i downto i),
                    S => sum_0(i downto i)
                );
            end generate FA_1_to_7_Cin_0;
            
            FA_1_to_7_Cin_1: for i in 1 to 7 generate
                FA_inst: entity work.FA port map(
                    A => X(i downto i),
                    B => Y(i downto i),
                    Cin => "1",
                    C => carry_1(i downto i),
                    S => sum_1(i downto i)
                    );
                end generate FA_1_to_7_Cin_1;

            first_carry_mux: mux
                        port map( 
                            sel => carry_out_0th_stage,
                            A => carry_0(1),
                            B => carry_1(1),
                            mux_out => first_stage_carry_mux(1)
                        );
            
            first_sum_mux: mux
                        port map(
                            sel => carry_out_0th_stage,
                            A => sum_0(1),
                            B => sum_1(1),
                            mux_out => first_stage_sum_mux(1)
                        );

            second_carry_mux: mux
                        port map( 
                            sel => carry_0(2),
                            A => sum_0(3),
                            B => sum_1(3),
                            mux_out => first_stage_carry_mux(2)
                        );
            second_sum_mux: mux
                        port map( 
                            sel => carry_0(2),
                            A => sum_0(3),
                            B => sum_1(3),
                            mux_out => first_stage_sum_mux(2)
                        );

            third_carry_mux: mux
                        port map( 
                            sel => carry_1(2),
                            A => sum_0(3),
                            B => sum_1(3),
                            mux_out => first_stage_carry_mux(3)
                        );

            third_sum_mux: mux
                        port map( 
                            sel => carry_1(2),
                            A => sum_0(3),
                            B => sum_1(3),
                            mux_out => first_stage_sum_mux(3)
                        );

            fourth_carry_mux: mux
                        port map( 
                            sel => carry_0(4),
                            A => sum_0(5),
                            B => sum_1(5),
                            mux_out => first_stage_carry_mux(4)
                        );

            fourth_sum_mux: mux
                        port map( 
                            sel => carry_0(4),
                            A => sum_0(5),
                            B => sum_1(5),
                            mux_out => first_stage_sum_mux(4)
                        );

            fifth_carry_mux: mux
                        port map( 
                            sel => carry_1(4),
                            A => sum_0(5),
                            B => sum_1(5),
                            mux_out => first_stage_carry_mux(5)
                        );

            fifth_sum_mux: mux
                        port map( 
                            sel => carry_1(4),
                            A => sum_0(5),
                            B => sum_1(5),
                            mux_out => first_stage_sum_mux(5)
                        );

            sixth_carry_mux: mux
                        port map( 
                            sel => carry_0(6),
                            A => sum_0(7),
                            B => sum_1(7),
                            mux_out => first_stage_carry_mux(6)
                        );

            sixth_sum_mux: mux
                        port map( 
                            sel => carry_0(6),
                            A => sum_0(7),
                            B => sum_1(7),
                            mux_out => first_stage_sum_mux(6)
                        );




            
            

          
            

        

   
                end architecture behavioral;

    
