library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

-- Subtractor
entity subtractor is
    generic (nBits : positive:=8);
    port (
        a : in  std_logic_vector(nBits-1 downto 0);
        b : in  std_logic_vector(nBits-1 downto 0);
        res : out std_logic_vector(nBits-1 downto 0) 
    );
end entity;

architecture rtl of subtractor is
    begin
        sub_proc: process(a,b)
        begin
            -- calculation overflow check
            if unsigned(a) >= unsigned(b) then
                res <= std_logic_vector(unsigned(a)-unsigned(b));
            else
                res <= std_logic_vector(unsigned(a)-unsigned(b));
            end if;
        end process;
    end rtl;