library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (N: positive := 8);
    port(
        input:  in std_logic_vector(N-1 downto 0);
        output: out std_logic_vector(N-1 downto 0);
        -- dff inputs
        en      :   in std_logic;
        clk     :   in std_logic;
        resetn  :   in  std_logic;
        -- RCA inputs
        cin:    in std_logic
    );
end entity;

architecture beh of counter is
    component ripple_carry_adder 
    generic (N: positive :=8);
    port (
        A:      in std_logic_vector(N-1 downto 0);
        B:      in std_logic_vector(N-1 downto 0);
        cin:    in std_logic;
        cout:   out std_logic;
        F:      out std_logic_vector(N-1 downto 0)
    );
    end component; 

    component dff_n
        generic (N: positive :=8);
        port (
            di      :   in std_logic_vector(N-1 downto 0);
            en      :   in std_logic;
            clk     :   in std_logic;
            resetn  :   in  std_logic;
            do      :   out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal sum_dff : std_logic_vector(N-1 downto 0);
    signal dff_out: std_logic_vector(N-1 downto 0);
    signal carry: std_logic;

    begin

        RCA: ripple_carry_adder 
        generic map(N => N)
        port map(
            A => input,
            B => dff_out,
            cin => cin,
            cout => open,
            F => sum_dff
        );

        DFF: dff_n 
        generic map(N => N)
        port map(
            di => sum_dff,
            do => dff_out,
            clk => clk,
            en => en,
            resetn => resetn
        );

        
        output <= dff_out;


end beh;