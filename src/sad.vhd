library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity sad is
    generic (
        nPixel  :   positive:=16;   --total pixels of image
        nBits   :   positive:=8;    --bits in each pixel
        outBits :   positive:=16    --bits for the output
    );
    port(
        pixel_A		: in std_logic_vector(nBits-1 downto 0);	
		pixel_B	: in std_logic_vector(nBits-1 downto 0);	
		clk		: in std_logic;				
		rst		: in std_logic;				
		enable		: in std_logic;				
		sad		: out std_logic_vector(outBits-1 downto 0);	
		valid	: out std_logic				
	);

end sad;

architecture rtl of sad is
    component subtractor is
		generic (outBits : positive);
		port (
			a : in  std_logic_vector(outBits-1 downto 0);
			b : in  std_logic_vector(outBits-1 downto 0);
			res : out std_logic_vector(outBits-1 downto 0) 
		);
	end component;
    component adder is
		generic (outBits : positive);
		port (
			a : in  std_logic_vector(outBits-1 downto 0);
			b : in  std_logic_vector(outBits-1 downto 0);
			res : out std_logic_vector(outBits-1 downto 0) 
		);
	end component;
    begin
        sad_proc: process (clk, rst)
            signal padding : std_logic_vector(outBits-nBits-1 downto 0);
            signal pa_pad:  std_logic_vector(outBits-1 downto 0);
            signal pb_pad:  std_logic_vector(outBits-1 downto 0);
            signal value:   std_logic_vector(outBits-1 downto 0);   -- supported vector
            signal res_add: std_logic_vector(outBits-1 downto 0);
        begin
            variable count := 0;
             
            
            for i in 0 to outBits-nBits-1 loop
                padding(i) := '0'
            end loop;

            pa_pad := padding & pixel_A;
            pb_pad := padding & pixel_B;

            if (rst = '1') then
                valid <= '0';
                count := 0

            elsif (count = nPixel) then
                count := 0;
                valid <= 1
                
            
            elsif(clk'event and clk = '1') then
                if (enable = '1') then
                    sub: subtractor
                        generic map (outBits)
                        port map (
                            a => pa_pad, 
                            b => pb_pad, 
                            res => sub);

                    sum: adder
                        generic map(outBits)
                        port map(
                            a => sub,
                            b => value,
                            res => add_res
                        );
                    sad <= add_res;
                    count := count +1;
                end if;

            end if;
        end sad_proc;

    end rtl;