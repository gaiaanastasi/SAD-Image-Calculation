library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity sad_tb_2 is
end entity;
architecture beh of sad_tb_2 is
constant nPixel : positive :=5;
constant nBits : positive :=8;
constant outBits : positive :=16;
constant CLK_PERIOD : time :=100 ns;
constant FINISH : positive := 2**(nPixel-1)+2;
component sad
generic(
nPixel : positive :=nPixel;
nBits : positive :=nBits;
outBits : positive :=outBits
);
  port (
    pixel_A		: in std_logic_vector(nBits-1 downto 0);
    pixel_B	    : in std_logic_vector(nBits-1 downto 0);
    clk		    : in std_logic;
    rst		    : in std_logic;
    enable		: in std_logic;	
    sad		    : out std_logic_vector(outBits-1 downto 0);
    valid	    : out std_logic	;
    new_comp    : in std_logic;
    count       : out std_logic_vector(nPixel-1 downto 0)
  );
end component;
signal clk : std_logic := '0';
signal rst:  std_logic := '0';
signal en : std_logic := '1';
signal pixel_A_ext : std_logic_vector (nBits-1 downto 0) := (others => '0');
signal pixel_B_ext : std_logic_vector (nBits-1 downto 0) := (others => '0');
signal valid_ext : std_logic;
signal sad_ext : std_logic_vector (outBits-1 downto 0);
signal testing : boolean := true;
signal new_comp_ext: std_logic:= '1';
signal count_ext : std_logic_vector(nPixel-1 downto 0);
begin
clk <=  not clk after clk_period/2 when testing else '0';
SAD1:sad
generic map(
    nPixel =>nPixel,
    nBits =>nBits,
    outBits =>outBits
)
port map(
    clk => clk,
    rst => rst,
    enable => en,
    pixel_A => pixel_A_ext,
    pixel_B => pixel_B_ext,
    sad => sad_ext,
    valid => valid_ext,
    new_comp => new_comp_ext,
    count => count_ext
    );
    stimulus : process
begin
rst <= '1';
    new_comp_ext <= '1';
    pixel_A_ext <= "00101111"; 
    pixel_B_ext <= "00101101"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10010000"; 
    pixel_B_ext <= "10100110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10011010"; 
    pixel_B_ext <= "01011011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11010110"; 
    pixel_B_ext <= "11010011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10101100"; 
    pixel_B_ext <= "00001111"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10100101"; 
    pixel_B_ext <= "10111110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11000001"; 
    pixel_B_ext <= "00001010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10011000"; 
    pixel_B_ext <= "10111111"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00111101"; 
    pixel_B_ext <= "01010001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00011010"; 
    pixel_B_ext <= "01110100"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01001101"; 
    pixel_B_ext <= "10000100"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10100101"; 
    pixel_B_ext <= "01110111"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00010110"; 
    pixel_B_ext <= "10111000"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00000111"; 
    pixel_B_ext <= "11101010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01010100"; 
    pixel_B_ext <= "10100011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10110010"; 
    pixel_B_ext <= "00100001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00100001"; 
    pixel_B_ext <= "11111001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00011111"; 
    pixel_B_ext <= "10011010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11100100"; 
    pixel_B_ext <= "10101010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11010110"; 
    pixel_B_ext <= "10000001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01000011"; 
    pixel_B_ext <= "11001000"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00110100"; 
    pixel_B_ext <= "00100110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00101111"; 
    pixel_B_ext <= "10110110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10010001"; 
    pixel_B_ext <= "11100010"; 
wait until rising_edge(clk);
    new_comp_ext <= '1';
    pixel_A_ext <= "01100111"; 
    pixel_B_ext <= "01110001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00111101"; 
    pixel_B_ext <= "00100110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01111000"; 
    pixel_B_ext <= "10100010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11101101"; 
    pixel_B_ext <= "00110110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10010001"; 
    pixel_B_ext <= "00100111"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10111001"; 
    pixel_B_ext <= "01000010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01111100"; 
    pixel_B_ext <= "11111110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11001011"; 
    pixel_B_ext <= "10101011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11010101"; 
    pixel_B_ext <= "01100011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11011101"; 
    pixel_B_ext <= "01010101"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00001110"; 
    pixel_B_ext <= "00110011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00111011"; 
    pixel_B_ext <= "01110100"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11101000"; 
    pixel_B_ext <= "10110001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11100010"; 
    pixel_B_ext <= "00111000"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00001111"; 
    pixel_B_ext <= "00001011"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10001110"; 
    pixel_B_ext <= "11110000"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "00111101"; 
    pixel_B_ext <= "00001001"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10011000"; 
    pixel_B_ext <= "00101000"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10101111"; 
    pixel_B_ext <= "10000110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11010101"; 
    pixel_B_ext <= "00000100"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01101000"; 
    pixel_B_ext <= "10110101"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "10101011"; 
    pixel_B_ext <= "01101010"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "01111001"; 
    pixel_B_ext <= "01001110"; 
wait until rising_edge(clk);
    new_comp_ext <= '0';
    pixel_A_ext <= "11000111"; 
    pixel_B_ext <= "11111000"; 
wait until rising_edge(clk);
wait for 200 ns; 
testing <= false;
end process;
end architecture;
