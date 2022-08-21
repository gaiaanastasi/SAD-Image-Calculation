library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity adder is
    generic (outBits : positive);
    port (
        a : in  std_logic_vector(outBits-1 downto 0);
        b : in  std_logic_vector(outBits-1 downto 0);
        res : out std_logic_vector(outBits-1 downto 0) 
    );
end entity;

architecture rtl of adder is
    begin
        sub_proc: process(a,b)
        begin
            -- calculation overflow check
            
        end process;
    end rtl;