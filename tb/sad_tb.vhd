library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sad_tb is
end entity;

architecture beh of sad_tb is
    constant nPixel  :   positive:=5;--16;   --total pixels of image
    constant nBits   :   positive:=8;    --bits in each pixel
    constant outBits :   positive:=36;
    --constant nPixel : positive := 4; --16 ;
    --constant nBits : positive := 8;
    --constant outBits : positive := 36; --16;
    constant CLK_PERIOD : time := 100 ns;
    --constant FINISH  			: std_logic_vector(nPixel-1 downto 0) :=  (others => '1');
    constant FINISH : positive := 2**(nPixel-1)+1;

    component sad 
    generic (
        nPixel  :   positive:=5;--16;   --total pixels of image
        nBits   :   positive:=8;    --bits in each pixel
        outBits :   positive:=36 --144    --bits for the output
    );
    port(
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
            valid => valid_ext,
            new_comp => new_comp_ext,
            count => count_ext
        );

        stimulus : process
    begin
        pixel_A_ext <= "00000001"; --(others => '0')&'1';
		pixel_B_ext <= (others => '0');
        rst <= '1';
        new_comp_ext<= '1';
		
        wait until rising_edge(clk);
        new_comp_ext <= '0';

        wait for FINISH*CLK_PERIOD;
        wait for 200 ns;
        new_comp_ext <= '1';
        wait until rising_edge(clk);
        new_comp_ext <= '0';
        
        wait for FINISH*CLK_PERIOD;
        testing <= false;
    
    end process;    
end architecture;