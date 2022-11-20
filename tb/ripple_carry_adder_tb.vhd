library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity ripple_carry_adder_tb is
end ripple_carry_adder_tb;

architecture beh of ripple_carry_adder_tb is
    constant CLK_PERIOD : time := 100 ns;
    constant N          : integer:=8;

    component ripple_carry_adder
    port(
        A       : in std_logic_vector (N-1 downto 0);
        B       : in std_logic_vector (N-1 downto 0);
        cin     : in std_logic;
        cout    : out std_logic;
        F       : out std_logic_vector(N-1 downto 0)
    );
    end component;

    signal clk	: std_logic := '0';
	signal a_ext	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal b_ext	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal c_in_ext : std_logic := '0';
	signal f_ext	: std_logic_vector(N-1 downto 0);
	signal c_out_ext: std_logic;
	signal testing  : boolean := true;
	
	begin
	clk <=  not clk after clk_period/2 when testing else '0';

	dut: ripple_carry_adder 
		generic map (
			Nbit => N
			)
		port map(
			a	=> a_ext,	
			b	=> b_ext,	
			cin	=> c_in_ext,	
			f	=> f_ext,	
			cout	=> c_out_ext
			);
		
		stimulus : process 
			begin
			a_ext <= (others => '0');
			b_ext <= (others => '0');
			c_in_ext <= '0';
			wait for 200 ns;
			a_ext <= "00000110";
			b_ext <= "00100110";
			c_in_ext <= '0';
			wait until rising_edge(clk);
			a_ext <= x"76";
			b_ext <= x"19";
			c_in_ext <= '1';
			wait until rising_edge(clk);
			a_ext <= (others => '0');
			b_ext <= (others => '0');
			c_in_ext <= '0';
			wait until rising_edge(clk);
			a_ext <= "00000000";
			b_ext <= "11111111";
			c_in_ext <= '0';
			wait for 1008 ns;
			a_ext <= "11111111";
			b_ext <= "11111111";
			c_in_ext <= '0';
			wait for 500 ns;
			testing <= false;
		end process;
end beh;
	