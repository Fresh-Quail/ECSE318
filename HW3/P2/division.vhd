library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity division is 
    generic (
        N : integer := 4
    );
    port (
        M, D  : in std_logic_vector(N-1 downto 0);
        Q, R : out std_logic_vector(N-1 downto 0)
    );
end division;

architecture subtraction of division is
    type twoD is array (0 to 4) of std_logic_vector(N-1 downto 0);
    
    signal inp : twoD := ((others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
    signal outp : twoD := ((others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'));
    signal interim_Q : std_logic_vector(0 to 4) := "00001";
    signal Cin : std_logic := '1';
begin
    -- interim_Q <= "00001"; -- Initialize the Q values which are read
    -- Cin <= '1';     -- Initial Carry in for initial subtraction
    inp(0) <= "000" & D(3);    -- Initialize the input to the division module
    
    stages: for i in 0 to 3 generate
        inp(i) <= outp(i)(2 downto 0) & D(3-i);    -- Initialize the input to the division module

        cas: entity work.CAS
            generic map( N => 4 )
            port map(
                control => interim_Q(i),
                A => inp(i),
                B => M,
                C => interim_Q(i + 1),
                S => outp(i + 1)
            );
    end generate;

    Q <= interim_Q(1 to 4);
    remain: entity work.remainder
        port map(
            control => outp(4)(3),
            A => outp(4),
            B => M,
            Cin => '0',
            S => R
        );
end subtraction;

-- cas cas1[N-1:0](
--     1'b1, 
--     {3'b0, D[3]}, 
--     M, 
--     1'b1, 
--     Q[3], 
--     S1);

-- wire [N-2:0] C2;
-- wire [N-1:0] S2;
-- cas cas2[N-1:0](
--     Q[3], 
--     {S1[2:0], D[2]}, 
--     M, 
--     Q[3], 
--     Q[2], 
--     S2);