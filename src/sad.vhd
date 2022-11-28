library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity sad is
    generic (
        nPixel  :   positive:=16;   --total pixels of an image
        nBits   :   positive:=8;    --bits in each pixel
        -- The output of the sum is represented on nBits+1. I have to perform the sum for nPixel times
        outBits :   positive:= 144    --bits for the output
    );
    port(
        pixel_A		: in std_logic_vector(nBits-1 downto 0);	
		pixel_B	    : in std_logic_vector(nBits-1 downto 0);	
		clk		    : in std_logic;				
		rst		    : in std_logic;				
		enable		: in std_logic;				
		sad		    : out std_logic_vector(outBits-1 downto 0);	
		valid	    : out std_logic;	
        new_comp    : in std_logic		--signal to determine if a new computation is started	
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
            in_add : in  std_logic_vector(outBits-1 downto 0);
			out_add : out  std_logic_vector(outBits-1 downto 0);
            en      :   in std_logic;
            clk     :   in std_logic;
            rst     :   in  std_logic;
            cin:    in std_logic	
			
		);
	end component;
    component dff_n is
        generic(N:positive);
        port(
            clk : in std_logic;
            rst : in std_logic;
            en  : in std_logic;
            d  : in std_logic_vector(N-1 downto 0);
            q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    --constants
    constant FINISH  			: std_logic_vector(nPixel-1 downto 0) :=  (others => '1');

    -- signals
    signal PA_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal PB_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal out_sub:     std_logic_vector(nBits-1 downto 0);     --output signal of subtractor
    signal padding:     std_logic_vector(outBits - nBits-1 downto 0); --signal for padding
    signal in_phac:      std_logic_vector(outBits-1 downto 0);      -- input signal of phase_accumulator
    signal out_phac:     std_logic_vector(outBits-1 downto 0);      -- output signal of phase_accumulator
    signal out_mux:     std_logic_vector(outBits-1 downto 0);      -- out of the multiplexer
    signal last_out:    std_logic_vector(outBits-1 downto 0);        --last output
    signal counter_value:  std_logic_vector(nPixel-1 downto 0);      -- counter value
    signal old_valid:   std_logic;                                  --old valid value

    begin
        --sad_proc: process (clk, rst)
            --signal padding : std_logic_vector(outBits-nBits-1 downto 0);
            --signal pa_pad:  std_logic_vector(outBits-1 downto 0);
            --signal pb_pad:  std_logic_vector(outBits-1 downto 0);
            --signal value:   std_logic_vector(outBits-1 downto 0);   -- supported vector
            --signal res_add: std_logic_vector(outBits-1 downto 0);
        --begin
            -- Save pixel_A and pixel_B into registeristers
            valid <= '0' when (new_comp='1') else not valid <= '1'
            counter_value <= '0' when (new_comp='1') else not counter_value <= counter_value;
            PA_register: dff_n
                generic map (nBits)
                port map (
                    clk => clk, 
                    rst => rst, 
                    en => enable,
                    d => pixel_A,
                    q => PA_to_sub);
            PB_register: dff_n
                generic map (nBits)
                port map (
                    clk => clk, 
                    rst => rst, 
                    en => enable,
                    d => pixel_B,
                    q => PB_to_sub
                ); 
            --Subtractor  
            sub: subtractor
                generic map (nBits)
                port map (
                    a => PA_to_sub, 
                    b => PB_to_sub, 
                    res => out_sub
                );
            
            -- generate padding
            gen_padding: for i in 0 to outBits - nBits -1 generate
                padding(i) <='0';
            end generate gen_padding;

            in_phac <= padding & out_sub;

            add: phase_accumulator
                generic map(outBits)
                port map(
                    clk => clk, 
                    rst => rst, 
                    en => enable,
                    cin => '0',
                    in_add => in_phac,
                    out_add => out_phac
                );

                out_mux <= out_phac when (enable = '1') else not(last_out);

            last_reg : dff_n 
            generic map (outBits)
            port map (
                clk => clk, 
                rst => rst, 
                en => enable,
                d => out_mux,
                q => last_out);
            
            counter:  phase_accumulator
            generic map(nPixel)
            port map(
                clk => clk, 
                rst => rst, 
                en => enable,
                cin => '0',
                in_add => (nPixel-1 downto 1 => '0') & '1',
                out_add => counter_value
            );

            sad <= last_out;
            valid <= '1' when (counter_value = FINISH ) else not '0';
            old_valid <= valid;
            
     --end sad_proc;

    end rtl;