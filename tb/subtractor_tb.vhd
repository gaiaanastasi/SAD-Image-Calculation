library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor_tb is
end entity;

architecture beh of subtractor_tb is
    constant N: integer := 8;
    constant CLK_PERIOD : time := 100 ns;

    component subtractor 
        generic (nBits : positive:=8);
        port (
            a : in  std_logic_vector(nBits-1 downto 0);
            b : in  std_logic_vector(nBits-1 downto 0);
            res : out std_logic_vector(nBits-1 downto 0) 
        );
    end component;

    signal clk : std_logic := '0';
    signal a_ext:   std_logic_vector (N-1 downto 0) := (others => '0');
    signal b_ext : std_logic_vector (N-1 downto 0) := (others => '0');
    signal res_ext:  std_logic_vector (N-1 downto 0);
    signal testing : boolean := true;

begin
    clk <=  not clk after clk_period/2 when testing else '0';

    SUB: subtractor
    generic map (nBits => N)
    port map(
        a => a_ext,
        b => b_ext,
        res => res_ext
    );

    stimulus : process 
        begin
        a_ext <= (others => '0');
        b_ext <= (others => '0');
        --c_in_ext <= '0';
        wait for 200 ns;
        a_ext <= "00000110";
        b_ext <= "00100110";
        --c_in_ext <= '0';
        wait until rising_edge(clk);
        a_ext <= x"76";
        b_ext <= x"19";
        --c_in_ext <= '1';
        wait until rising_edge(clk);
        a_ext <= (others => '0');
        b_ext <= (others => '0');
        --c_in_ext <= '0';
        wait until rising_edge(clk);
        a_ext <= "00000000";
        b_ext <= "11111111";
        --c_in_ext <= '0';
        wait for 1008 ns;
        a_ext <= "11111111";
        b_ext <= "11111111";
        --c_in_ext <= '0';
        wait for 500 ns;
        testing <= false;
    end process;
end architecture;