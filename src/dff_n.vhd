library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dff_n is 
    generic (N: positive :=8);
    port (
        di      :   in std_logic_vector(N-1 downto 0);
        en      :   in std_logic;
        clk     :   in std_logic;
        resetn  :   in  std_logic;
        do      :   out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture beh of dff_n is
    signal di_s : std_logic_vector(N-1 downto 0);
    signal do_s:   std_logic_vector(N-1 downto 0);
begin
    dff_proc: process(resetn, clk)
    begin
        if resetn = '0' then
            do_s <= ( others => '0');
        elsif (clk='1' and clk'event) then
            do_s <= di_s;
        end if;
    end process;
    di_s <= di when en='1' else do_s;
    do <= do_s;    

end beh;
