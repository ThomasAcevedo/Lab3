-- Six-bit adder/subtractor. sel: 00=sum, 01=addition carry,
-- 10=difference, 11=unsigned borrow.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    generic (n : positive := 6);
    port (
        sel : in  std_logic_vector(1 downto 0);
        a   : in  std_logic_vector(n-1 downto 0);
        b   : in  std_logic_vector(n-1 downto 0);
        r   : out std_logic_vector(n-1 downto 0)
    );
end entity adder;

architecture dataflow of adder is
    signal add_wide : unsigned(n downto 0);
    signal sub_wide : unsigned(n downto 0);
begin
    add_wide <= unsigned('0' & a) + unsigned('0' & b);
    -- a + not(b) + 1 is two's-complement subtraction. Its top bit is
    -- the no-borrow carry, so the requested borrow output is its inverse.
    sub_wide <= unsigned('0' & a) + unsigned('0' & (not b)) + to_unsigned(1, n+1);

    with sel select
        r <= std_logic_vector(add_wide(n-1 downto 0)) when "00",
             std_logic_vector(to_unsigned(0, n-1) & add_wide(n)) when "01",
             std_logic_vector(sub_wide(n-1 downto 0)) when "10",
             std_logic_vector(to_unsigned(0, n-1) & not sub_wide(n)) when "11",
             (others => '0') when others;
end architecture dataflow;
