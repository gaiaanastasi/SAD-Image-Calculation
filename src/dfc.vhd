library STD;
use STD.standard.all;
use STD.textio.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
use IEEE.match_real.all;
use IEEE.math_complex.all;
use IEEE.std_logic_textio.all;

library WORK;
use WORK.my_package.all;

-- D-Flip Flop
entity dfc is
    port(
        clk     : in std_logic;
        resetn  : in std_logic;
        d       : in std_logic;
        q       : out std_logic
    );
end dfc;

architecture rtl of dfc is
    begin
        dfc_p: process(resetn, clk)
        begin
            -- asynchronous reset
            if resetn='0' then
                q<= '0' ;
            elsif (clk'event and clk='1') then
                q <= d;
            end if;
            --synchronous reset
            -- if (clk'event and clk='1') then
                --if(resetn='0') then q<=0;
                --else q<=d
                --end if;
            -- end if;
        end process dfc_p;
end rtl;
