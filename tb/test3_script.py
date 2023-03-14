import math
import random
from random import seed
from random import randint

seed(1)
nPixel = 5
nBits = 8
outBits = 16
fname = "sad_tb_2.vhd"
finish = 2**(nPixel-1)+8
stop = 2**(nBits) -1
NUM_TEST = 2

def pixel():
    # Variable to store the
    # string
    key1 = ""

    # Loop to find the string
    # of desired length
    for i in range(nBits):
        # randint function to generate
        # 0, 1 randomly and converting
        # the result into str
        temp = str(random.randint(0, 1))

        # Concatenation the random 0, 1
        # to the final result
        key1 += temp

    return (key1)


# start to write the file
out_file = open(fname, "w")

out_file.write("library IEEE;\n")
out_file.write("  use IEEE.std_logic_1164.all;\n")
out_file.write("  use IEEE.numeric_std.all;\n")
out_file.write("\n")
out_file.write("entity sad_tb_2 is\n")
out_file.write("end entity;\n")
out_file.write("architecture beh of sad_tb_2 is\n")
out_file.write("constant nPixel : positive :=" + str(nPixel) + ";\n")
out_file.write("constant nBits : positive :=" + str(nBits) + ";\n")
out_file.write("constant outBits : positive :=" + str(outBits) + ";\n")
out_file.write("constant CLK_PERIOD : time :=" + str(100) + " ns;\n")
out_file.write("constant FINISH : positive := 2**(nPixel-1)+2;\n")


out_file.write("component sad\n")
out_file.write("generic(\n")
out_file.write("nPixel : positive :=nPixel;\n")
out_file.write("nBits : positive :=nBits;\n")
out_file.write("outBits : positive :=outBits\n")
out_file.write(");\n")
out_file.write("  port (\n")
out_file.write("    pixel_A		: in std_logic_vector(nBits-1 downto 0);\n")
out_file.write("    pixel_B	    : in std_logic_vector(nBits-1 downto 0);\n")
out_file.write("    clk		    : in std_logic;\n")
out_file.write("    rst		    : in std_logic;\n")
out_file.write("    enable		: in std_logic;	\n")
out_file.write("    sad		    : out std_logic_vector(outBits-1 downto 0);\n")
out_file.write("    valid	    : out std_logic	;\n")
out_file.write("    new_comp    : in std_logic;\n")
out_file.write("    count       : out std_logic_vector(nPixel-1 downto 0)\n")
out_file.write("  );\n")
out_file.write("end component;\n")

out_file.write("signal clk : std_logic := '0';\n")
out_file.write("signal rst:  std_logic := '0';\n")
out_file.write("signal en : std_logic := '1';\n")
out_file.write("signal pixel_A_ext : std_logic_vector (nBits-1 downto 0) := (others => '0');\n")
out_file.write("signal pixel_B_ext : std_logic_vector (nBits-1 downto 0) := (others => '0');\n")
out_file.write("signal valid_ext : std_logic;\n")
out_file.write("signal sad_ext : std_logic_vector (outBits-1 downto 0);\n")
out_file.write("signal testing : boolean := true;\n")
out_file.write("signal new_comp_ext: std_logic:= '1';\n")
out_file.write("signal count_ext : std_logic_vector(nPixel-1 downto 0);\n")

out_file.write("begin\n")
out_file.write("clk <=  not clk after clk_period/2 when testing else '0';\n")

out_file.write("SAD1:sad\n")
out_file.write("generic map(\n")
out_file.write("    nPixel =>nPixel,\n")
out_file.write("    nBits =>nBits,\n")
out_file.write("    outBits =>outBits\n")
out_file.write(")\n")
out_file.write("port map(\n")
out_file.write("    clk => clk,\n")
out_file.write("    rst => rst,\n")
out_file.write("    enable => en,\n")
out_file.write("    pixel_A => pixel_A_ext,\n")
out_file.write("    pixel_B => pixel_B_ext,\n")
out_file.write("    sad => sad_ext,\n")
out_file.write("    valid => valid_ext,\n")
out_file.write("    new_comp => new_comp_ext,\n")
out_file.write("    count => count_ext\n")
out_file.write("    );\n")
out_file.write("    stimulus : process\n")
out_file.write("begin\n")

out_file.write("rst <= '1';\n")
for a in range(finish*NUM_TEST):
    if a % finish == 0:
        out_file.write("    new_comp_ext <= '1';\n")
    else:
        out_file.write("    new_comp_ext <= '0';\n")

    pixelA = pixel()
    pixelB = pixel()
    out_file.write("    pixel_A_ext <= \"" +pixelA + "\"; \n" )
    out_file.write("    pixel_B_ext <= \"" +pixelB + "\"; \n" )
    out_file.write("wait until rising_edge(clk);\n")

out_file.write("wait for 200 ns; \n")
out_file.write("testing <= false;\n")    
    
out_file.write("end process;\n")
out_file.write("end architecture;\n")

out_file.close()