--Adder Simulation Bench
library ieee;
use ieee.std_logic_1164.all;

entity adder_sim is
end adder_sim;

architecture test_bench of adder_sim is
    constant period:time:=10ns;
    constant n:integer:= 6;
 -- Adder Definition
    component adder is
      Generic(n: integer := 6);
      Port (sel : in std_logic_vector(1 downto 0);
            a   : in std_logic_vector(n-1 downto 0);
            b   : in std_logic_vector(n-1 downto 0);
            r   : out std_logic_vector(n-1 downto 0));
    end component;
-- test bench signals
    signal sel_tb: std_logic_vector(1 downto 0);
    signal a_tb  : std_logic_vector(n-1 downto 0);
    signal b_tb  : std_logic_vector(n-1 downto 0);
    signal r_tb  : std_logic_vector(n-1 downto 0);
begin
    
    process
    begin
    sel_tb <= "00";
        a_tb <= "100011"; b_tb <= "111111"; wait for period;
    sel_tb <= "01";
        a_tb <= "111000"; b_tb <= "111111"; wait for period;
    sel_tb <= "10";
        a_tb <= "010111"; b_tb <= "111111"; wait for period;
    sel_tb <= "11"; 
        a_tb <= "000001"; b_tb <= "111111"; wait for period; 
    wait;
    end process;
    
    uut:adder generic map(n => n)
    port map(sel => sel_tb, a => a_tb, b => b_tb, r => r_tb);
    
end test_bench;
---
---
--Multiplier Simulation Bench
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_sim is

end mult_sim;

architecture mult_tb of mult_sim is

    component mult is
    generic(n : integer := 6);
    port(sel: in std_logic;
         a:in std_logic_vector(n-1 downto 0);
         b:in std_logic_vector(n-1 downto 0);
         r:out std_logic_vector(n-1 downto 0));
    end component;
    
    constant period : time := 10 ns;
    constant n : integer := 6;
    signal sel_tb : std_logic;
    signal a_tb, b_tb, r_tb: std_logic_vector(n-1 downto 0);
    
begin
--sel 0 then r = low 6 bits of a*b
--sel 1 then r = hi  6 bits of a*b
    uut: mult 
    generic map(n => n)
    port    map(sel => sel_tb,
                a => a_tb, 
                b => b_tb, 
                r => r_tb);
    
    tb: process begin
        sel_tb <= '1';
            a_tb <= "001111"; b_tb <= "000010"; wait for period;
            a_tb <= "100000"; b_tb <= "000010"; wait for period;
        sel_tb <= '0';
            a_tb <= "001111"; b_tb <= "000010"; wait for period;
            a_tb <= "100000"; b_tb <= "000010"; wait for period;    
    end process tb;
    
end mult_tb;
---
---
--Logic Unit Simulation Bench
library ieee;
use ieee.std_logic_1164.all;

entity logic_unit_sim is
end logic_unit_sim;

architecture logic_unit_tb of logic_unit_sim is
    component logic_unit is
        generic(n: integer := 6);
        port(sel: in std_logic_vector(1 downto 0);
             a,b: in std_logic_vector(n-1 downto 0);
               r: out std_logic_vector(n-1 downto 0));
    end component logic_unit;
    constant n : integer := 6;
    constant period : time := 10 ns;
    signal sel_tb : std_logic_vector(1 downto 0);
    signal a_tb, b_tb, r_tb : std_logic_vector(n-1 downto 0);

begin
    --sel = 00 then r = not(a)
    --sel = 01 then r = a and b
    --sel = 10 then r = a or b
    --sel = 11 then r = a xor b
    uut: logic_unit
        generic map(n => n)
        port    map(sel => sel_tb,
                      a => a_tb,
                      b => b_tb,
                      r => r_tb);
                 
   tb: process begin
        a_tb <= "010101"; b_tb <= "111111";
        sel_tb <= "00"; wait for period;
        sel_tb <= "01"; wait for period;
        sel_tb <= "10"; wait for period;
        sel_tb <= "11"; wait for period;
   end process tb;
end logic_unit_tb;
---
---
---Shifter Simulation Bench
library ieee;
use ieee.std_logic_1164.all;

entity shifter_sim is
end shifter_sim;

architecture shifter_tb of shifter_sim is
        
    constant n : integer := 6;
    constant m : integer := 3;
    constant period: time := 10ns;
    
    component shifter is
    generic(n : integer:= 6;
            m : integer:= 3);
    port(sel:in std_logic_vector(1 downto 0);
         a  :in std_logic_vector(n-1 downto 0);
         b  :in std_logic_vector(m-1 downto 0);
         r  :out std_logic_vector(n-1 downto 0));
    end component;
    
    signal sel_tb     : std_logic_vector(1 downto 0);
    signal a_tb, r_tb : std_logic_vector(n-1 downto 0);
    signal b_tb       : std_logic_vector(m-1 downto 0);
    
begin
    uut: shifter 
        generic map(n => n, m => m)
        port map(sel => sel_tb, a => a_tb, b => b_tb, r => r_tb);
    process begin
    sel_tb <= "00";
        a_tb <= "000001"; b_tb <= "000"; wait for period;
        a_tb <= "000001"; b_tb <= "001"; wait for period;
        a_tb <= "000001"; b_tb <= "010"; wait for period;
        a_tb <= "000001"; b_tb <= "011"; wait for period;
        a_tb <= "000001"; b_tb <= "100"; wait for period;
        a_tb <= "000001"; b_tb <= "101"; wait for period;
        a_tb <= "000001"; b_tb <= "110"; wait for period;
        a_tb <= "000001"; b_tb <= "111"; wait for period;
    sel_tb <= "10";
        a_tb <= "100000"; b_tb <= "000"; wait for period;
        a_tb <= "100000"; b_tb <= "001"; wait for period;
        a_tb <= "100000"; b_tb <= "010"; wait for period;
        a_tb <= "100000"; b_tb <= "011"; wait for period;
        a_tb <= "100000"; b_tb <= "100"; wait for period;
        a_tb <= "100000"; b_tb <= "101"; wait for period;
        a_tb <= "100000"; b_tb <= "110"; wait for period;
        a_tb <= "100000"; b_tb <= "111"; wait for period;
    sel_tb <= "11";
        a_tb <= "100000"; b_tb <= "000"; wait for period;
        a_tb <= "100000"; b_tb <= "001"; wait for period;
        a_tb <= "100000"; b_tb <= "010"; wait for period;
        a_tb <= "100000"; b_tb <= "011"; wait for period;
        a_tb <= "100000"; b_tb <= "100"; wait for period;
        a_tb <= "100000"; b_tb <= "101"; wait for period;
        a_tb <= "100000"; b_tb <= "110"; wait for period;
        a_tb <= "100000"; b_tb <= "111"; wait for period;
     sel_tb <= "11";
        a_tb <= "010000"; b_tb <= "000"; wait for period;
        a_tb <= "010000"; b_tb <= "001"; wait for period;
        a_tb <= "010000"; b_tb <= "010"; wait for period;
        a_tb <= "010000"; b_tb <= "011"; wait for period;
        a_tb <= "010000"; b_tb <= "100"; wait for period;
        a_tb <= "010000"; b_tb <= "101"; wait for period;
        a_tb <= "010000"; b_tb <= "110"; wait for period;
        a_tb <= "010000"; b_tb <= "111"; wait for period;
   end process;
    
    
end shifter_tb;
---
---
---ALU Simulation Bench
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity alu_sim is
end alu_sim;

architecture alu_tb of alu_sim is
    component alu is
    port(sel: in  std_logic_vector(3 downto 0);
         a,b: in  std_logic_vector(5 downto 0);
           r: out std_logic_vector(5 downto 0));  
    end component alu;
    
    constant period : time := 10 ns;
    signal sel_tb : std_logic_vector(3 downto 0);
    signal a_tb, b_tb, r_tb : std_logic_vector(5 downto 0);
    
begin
    uut: alu port map(sel => sel_tb, a => a_tb, b => b_tb, r => r_tb);
    tb: process begin
    a_tb <= "000100"; b_tb <= "000010"; --a = 4,  b = 2
        for i in 0 to 15 loop
            sel_tb <= conv_std_logic_vector(i,4); wait for period;
        end loop;
        
    a_tb <= "110001"; b_tb <= "110010"; --a = 49, b = 50
        for i in 0 to 15 loop
            sel_tb <= conv_std_logic_vector(i,4); wait for period;
        end loop;
        
    a_tb <= "111111"; b_tb <= "111111"; --a = 63, b = 63
         for i in 0 to 15 loop
                sel_tb <= conv_std_logic_vector(i,4); wait for period;
            end loop;
    end process tb;
end alu_tb;