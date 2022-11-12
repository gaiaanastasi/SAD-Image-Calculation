library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ripple_carry_adder is
    generic (N: positive :=8);
    port (
        A:      in std_logic_vector(N-1 downto 0);
        B:      in std_logic_vector(N-1 downto 0);
        cin:    in std_logic;
        cout:   out std_logic;
        F:      out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture beh of ripple_carry_adder is
    component full_adder
        port(
            a:      in std_logic;
            b:      in std_logic;
            cin:    in std_logic;
            cout:   out std_logic;
            s:      out std_logic

        );
    end component full_adder;

    signal carry: std_logic_vector(N-1 downto 0);

begin
    GEN: for i in 0 to N-1 generate
            FIRST: if i = 0 generate
            FA_1: full_adder 
                port map (
                    a    => A(i),
                    b    => B(i),
                    cin  => cin,
                    s    => f(i),
                    cout => carry(i)		
                );
        end generate FIRST;

        SECONDS: if i > 0 and i < N generate
            FA_M: full_adder 
                port map (
                    a    => A(i),
                    b    => B(i),
                    cin  => carry(i-1),
                    s    => f(i),
                    cout => carry(i)		
                );			
        end generate SECONDS;	
    end generate GEN; 

    cout <= carry(N-1);

end beh;
