library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity sad is
    generic (
        nPixel  :   positive:=5;--16;   --total pixels of an image
        nBits   :   positive:=8;    --bits in each pixel
        -- I have doubled the output size to prevent overflow
        outBits :   positive:= 16     --bits for the output 
    );
    port(
        pixel_A		: in std_logic_vector(nBits-1 downto 0);	
		pixel_B	    : in std_logic_vector(nBits-1 downto 0);	
		clk		    : in std_logic;				
		rst		    : in std_logic;				
		enable		: in std_logic;				
		sad		    : out std_logic_vector(outBits-1 downto 0);	
		valid	    : out std_logic;	
        new_comp    : in std_logic;		--signal to determine if a new computation is started	
        count       : out std_logic_vector (nPixel-1 downto 0)
	);

end sad;

architecture rtl of sad is
    -- components
    component subtractor is
		generic (nBits : positive);
		port (
			a : in  std_logic_vector(nBits-1 downto 0);
			b : in  std_logic_vector(nBits-1 downto 0);
			res : out std_logic_vector(nBits-1 downto 0) 
		);
	end component;
    component counter is
		generic (N : positive);
		port (
            input : in  std_logic_vector(N-1 downto 0);
			output : out  std_logic_vector(N-1 downto 0);
            en      :   in std_logic;
            clk     :   in std_logic;
            resetn     :   in  std_logic;
            cin:    in std_logic	
			
		);
	end component;
    component dff_n is
        generic(N:positive);
        port(
            clk : in std_logic;
            resetn : in std_logic;
            en  : in std_logic;
            di  : in std_logic_vector(N-1 downto 0);
            do  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    --constants
    constant FINISH  			: positive := 2**(nPixel-1)+1;
    
    -- signals
    signal PA_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal PB_to_sub:   std_logic_vector(nBits-1 downto 0);     --connection from the registerister on pixel_A and subtractor
    signal out_sub:     std_logic_vector(nBits-1 downto 0);     --output signal of subtractor
    signal padding:     std_logic_vector(outBits - nBits-1 downto 0); --signal for padding
    signal in_phac:      std_logic_vector(outBits-1 downto 0);      -- input signal of counter
    signal out_phac:     std_logic_vector(outBits-1 downto 0);      -- output signal of counter
    --signal out_mux:     std_logic_vector(outBits-1 downto 0);      -- out of the multiplexer
    --signal last_out:    std_logic_vector(outBits-1 downto 0);        --last output
    signal sub_reg_to_padd: std_logic_vector(nBits-1 downto 0);      -- from register after the subtractor to padding
    signal counter_value:  std_logic_vector(nPixel-1 downto 0);      -- counter value
    signal old_valid:   std_logic;                                  --old valid value
    signal new_comp_rst: std_logic;

    begin
        --sad_proc: process (clk, rst)
            --signal padding : std_logic_vector(outBits-nBits-1 downto 0);
            --signal pa_pad:  std_logic_vector(outBits-1 downto 0);
            --signal pb_pad:  std_logic_vector(outBits-1 downto 0);
            --signal value:   std_logic_vector(outBits-1 downto 0);   -- supported vector
            --signal res_add: std_logic_vector(outBits-1 downto 0);
        --begin
            --If a new computation is started I reset valid and counter
            --old_valid <= '0' when (new_comp='1') else not '1';
            --valid <= old_valid;

            new_comp_rst <= '0' when (new_comp='1') else rst;
                      
            -- Save pixel_A and pixel_B into registeristers
            PA_register: dff_n
                generic map (N => nBits)
                port map (
                    clk => clk, 
                    resetn => rst, 
                    en => enable,
                    di => pixel_A,
                    do=> PA_to_sub);
            PB_register: dff_n
                generic map (N => nBits)
                port map (
                    clk => clk, 
                    resetn => rst, 
                    en => enable,
                    di=> pixel_B,
                    do=> PB_to_sub
                ); 
            --Subtractor  
            sub: subtractor
                generic map (nBits => nBits)
                port map (
                    a => PA_to_sub, 
                    b => PB_to_sub, 
                    res => out_sub
                );

            -- Register for wrapping
            SUB_REG:dff_n
                generic map (N => nBits)
                port map (
                    clk => clk, 
                    resetn => new_comp_rst, 
                    en => enable,
                    di=> out_sub,
                    do=> sub_reg_to_padd
                ); 
            
            -- generate padding to avoid computational overflow
            --gen_padding: for i in 0 to outBits - nBits -1 generate
              --padding(i) <='0';
            --end generate gen_padding;
            padding <= (others => '0');
            in_phac <= padding & sub_reg_to_padd;

            
            -- Perform the sum of absolute difference values
            add: counter
                generic map(N=> outBits)
                port map(
                    clk => clk, 
                    resetn => new_comp_rst, 
                    en => enable,
                    cin => '0',
                    input => in_phac,
                    output => out_phac
                );

            --out_mux <= out_phac when (enable = '1') else not(last_out);
            

            -- Secondo me non serve??? ***PAY ATTENTION HEREEE!****
            --last_reg : dff_n 
            --generic map (N=>outBits)
            --port map (
              --  clk => clk, 
               -- resetn => rst, 
                --en => enable,
                --di => out_mux,
                --do=> last_out);
            -- ************************************************************
            
            -- Counter to know when we have to set valid signal
            counter1:  counter
            generic map(N=> nPixel)
            port map(
                clk => clk, 
                resetn => new_comp_rst, 
                en => enable,
                cin => '0',
                input => (nPixel-1 downto 1 => '0') & '1',
                output => counter_value
            );

            -- Set sad and valid
            sad <= out_phac;
            old_valid <= '1' when (unsigned(counter_value)=FINISH) else '0';
            valid <= old_valid;
            count <=  counter_value; --(others => '0') when (new_comp='1') else counter_value;
            --valid <= '0';
     --end sad_proc;

    end rtl;