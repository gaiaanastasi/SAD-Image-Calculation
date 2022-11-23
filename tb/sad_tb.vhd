library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sad_tb is
end entity;

architecture beh of sad_tb is
    constant nPixel : positive := 16 ;
    constant nBits : positive := 8;
    constant outBits : positive := 16;
    constant CLK_PERIOD : time := 100 ns;

    component sad 
    generic (
        nPixel  :   positive:=16;   --total pixels of image
        nBits   :   positive:=8;    --bits in each pixel
        outBits :   positive:=16    --bits for the output
    );
    port(
        pixel_A		: in std_logic_vector(nBits-1 downto 0);	
		pixel_B	    : in std_logic_vector(nBits-1 downto 0);	
		clk		    : in std_logic;				
		rst		    : in std_logic;				
		enable		: in std_logic;				
		sad		    : out std_logic_vector(outBits-1 downto 0);	
		valid	    : out std_logic				
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

    begin
        clk <=  not clk after clk_period/2 when testing else '0';

        SAD1: sad
        generic map (
            nPixel => nPixel,
            nBits => nBits,
            outBits => outBits
        )
        port map (
            clk => clk,
            rst => rst,
            enable => en,
            pixel_A => pixel_A_ext,
            pixel_B => pixel_B_ext,
            sad => sad_ext,
            valid => valid_ext
        );

        stimulus : process
    begin
        
        wait for 500 ns;
        testing <= false;
    
    end process;    
end architecture;