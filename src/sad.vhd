library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

library WORK;
use WORK.my_package.all;

entity sad is
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

end sad;

architecture rtl of sad is
    -- components
    component subtractor is
		generic (outBits : positive);
		port (
			a : in  std_logic_vector(outBits-1 downto 0);
			b : in  std_logic_vector(outBits-1 downto 0);
			res : out std_logic_vector(outBits-1 downto 0) 
		);
	end component;
    component phase_accumulator is
		generic (outBits : positive);
		port (
            clk : in std_logic;
            rst : in std_logic;
			in_phac : in  std_logic_vector(outBits-1 downto 0);
			out_phac : out  std_logic_vector(outBits-1 downto 0)
			
		);
	end component;
    component register is
        generic(N:positive);
        port(
            clk : in std_logic;
            rst : in std_logic;
            d  : in std_logic_vector(N-1 downto 0);
            q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- signals
    signal PA_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal PB_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal out_sub:     std_logic_vector(nBits-1 downto 0);     --output signal of subtractor
    signal padding:     std_logic_vector(outBits - nBits-1 downto o) --signal for padding
    signal in_phac:      std_logic_vector(outBits downto 0)      -- input signal of phase_accumulator
    signal out_phac:     std_logic_vector(outBits downto 0)      -- output signal of phase_accumulator

    begin
        sad_proc: process (clk, rst)
            --signal padding : std_logic_vector(outBits-nBits-1 downto 0);
            --signal pa_pad:  std_logic_vector(outBits-1 downto 0);
            --signal pb_pad:  std_logic_vector(outBits-1 downto 0);
            --signal value:   std_logic_vector(outBits-1 downto 0);   -- supported vector
            --signal res_add: std_logic_vector(outBits-1 downto 0);
        begin
            -- Save pixel_A and pixel_B into registeristers
            PA_register: register
                generic map (nBits)
                port map (
                    clk => clk, 
                    rst => rst, 
                    d => pixel_A,
                    q => PA_to_sub);
            PA_register: register
                generic map (nBits)
                port map (
                    clk => clk, 
                    rst => rst, 
                    d => pixel_B,
                    q => PB_to_sub); 
            --Subtractor  
            sub: subtractor
                generic map (nBits)
                port map (
                    a => PA_to_sub, 
                    b => PB_to_sub, 
                    res => out_sub);
            
            -- generate padding
            gen_padding: for i in 0 to outBits - nBits -1 generate
                padding(i) <='0';
            end generate gen_padding;

            id_phac <= padding & out_sub;

            add: phase_accumulator
                generic map(outBits)
                port map(
                    clk => clk, 
                    rst => rst, 
                    in_add => in_phac,
                    out_add => out_phac
                );
     end sad_proc;

    end rtl;