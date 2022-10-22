library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library WORK;
use WORK.my_package.all;

-- register
entity register is
    generic (N: positive:=8);
    port(
        clk:    in std_logic;
        rst : in std_logic;
        d   : in std_logic_vector(N-1 downto 0);
        q   : out std_logic_vector(N-1 downto 0)
    );
end register;

architecture rtl of register is
    -- register uses a D-Flip Flop
    component dff_n
        port(
            clk:    in std_logic;
            rst : in std_logic;
            d   : in std_logic;
            q   : out std_logic
        );
    end component dff_n;

    begin
        register: for i in 0 to N-1 generate
            dff_n_i: dff_n
            port map (
                clk => clk, 
                rst => rst, 
                d => d(i),
                q => q(i));
        end  generate register;
end rtl;