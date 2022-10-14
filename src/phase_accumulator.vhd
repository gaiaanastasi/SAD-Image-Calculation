library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library WORK;
use WORK.my_package.all;

entity phase_accumulator is
    generic (outBits : positive:=16);
    port  (
        clk : in std_logic;
        rst : in std_logic;
        in_phac   : in std_logic_vector(N-1 downto 0);
        out_phac   : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of phase_accumulator is
    component register is
        generic(N:positive);
        port(
            clk : in std_logic;
            rst : in std_logic;
            d  : in std_logic_vector(N-1 downto 0);
            q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component ripple_carry_adder is
        generic(N:positive)
        port(
            a   : in  std_logic_vector(N -1 downto 0);
			b   : in  std_logic_vector(N -1 downto 0);
			cin  : in  std_logic;
			s   : out std_logic_vector(N -1 downto 0);
			cout  : out std_logic

        );
    end component;

    --signals
    signal feedback:    std_logic_vector(N-1 downto 0)  -- feedback loop between registerister and ripple_carry_adder input
    signal out_rca:     std_logic_vector(N-1 downto 0)  -- output signal of ripple_carry_adder
    
    begin
        rca: ripple_carry_adder 
            generic map(N)
            port map(
               a => in_phac;
               b => feedback;
               cin => '0';
               s => out_rca;
               cout => open
            );
        
        register: register
            generic map(N)
            port map(
                clk => clk;
                rst => rst;
                d => out_rca;
                q => feedback
            );

        out_phac <= feedback;

    end rtl;