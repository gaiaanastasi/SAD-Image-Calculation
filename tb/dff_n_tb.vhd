library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dff_n_tb is
end entity;

architecture beh of dff_n_tb is
    
    constant N : integer := 8;
    constant CLK_PERIOD : time := 100 ns;
    
    component dff_n port(
        di      :   in std_logic_vector(N-1 downto 0);
        en      :   in std_logic;
        clk     :   in std_logic;
        resetn  :   in  std_logic;
        do      :   out std_logic_vector(N-1 downto 0)
    );
    end component;

    signal clk      : std_logic := '0';
    signal en_ext   : std_logic :='0';
    signal di_ext   : std_logic_vector (N-1 downto 0) := (others => '0');
    signal do_ext   : std_logic_vector(N-1 downto 0);
    signal resetn   : std_logic := '0';
    signal testing  : boolean := true;

    begin
        clk <=  not clk after clk_period/2 when testing else '0';

        dut: dff_n 
        generic map (
			N => N
			)
        port map(
            di => di_ext,
            en => en_ext,
            clk => clk,
            resetn => resetn,
            do => do_ext
        );

        stimulus: process 
        begin
            di_ext <= "11111111";
            en_ext <= '1';
            resetn <= '1';
            wait until rising_edge (clk);
            di_ext <= "10101000";
            en_ext <= '1';
            resetn<='1';
            wait until rising_edge (clk);
            di_ext <= "10101001";
            en_ext <= '0';
            resetn <= '1';
            wait until rising_edge (clk);
            di_ext <= "10101001";
            en_ext <= '0';
            resetn <= '1';
            wait until rising_edge (clk);
            resetn <= '0';
            wait for 500 ns;
            testing <= false;


        end process;



    end beh;