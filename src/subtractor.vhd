library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

-- Subtractor
entity subtractor is
    generic (nBits : positive:=8);
    port (
        a : in  std_logic_vector(nBits-1 downto 0);
        b : in  std_logic_vector(nBits-1 downto 0);
        res : out std_logic_vector(nBits-1 downto 0) 
    );
end entity;

architecture rtl of subtractor is
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

    signal min: std_logic_vector(nBits-1 downto 0);
    signal sottr: std_logic_vector (nBits-1 downto 0);
    signal out_rca: std_logic_vector(nBits-1 downto 0);
    signal zero : std_logic_vector (nBits-1 downto 0);

    begin
        -- Check if a is greater than b
        min <= a when (to_integer(unsigned(a)) > to_integer(unsigned(b))) else b;
        sottr <= not b when (to_integer(unsigned(a)) > to_integer(unsigned(b))) else not a;
        SUB: ripple_carry_adder 
        generic map(N => nBits)
        port map(
            A => min,
            B => sottr,
            cin => '1',
            cout => open,
            F => out_rca
        ); 
        
        res <= out_rca; --when (out_rca >) else not out_rca;
        
    end rtl;