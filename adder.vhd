-- ADDER / SUBTRACTOR
-- sel = 00: low n bits of a + b
-- sel = 01: addition carry, padded with zeros
-- sel = 10: low n bits of a - b
-- sel = 11: subtraction borrow, padded with zeros
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
    -- One extra bit keeps the carry out of each calculation.
    signal add_wide : unsigned(n downto 0);
    signal sub_wide : unsigned(n downto 0);
begin
    -- Put a zero in front of each input so the addition is n+1 bits wide.
    add_wide <= unsigned('0' & a) + unsigned('0' & b);

    -- Two's-complement subtraction: a - b = a + not(b) + 1.
    sub_wide <= unsigned('0' & a) + unsigned('0' & (not b)) + to_unsigned(1, n+1);

    -- Choose which part of the arithmetic result is sent to the output.
    -- The extra zeros make a one-bit carry/borrow into an n-bit result.
    with sel select
        r <= std_logic_vector(add_wide(n-1 downto 0)) when "00",
             std_logic_vector(to_unsigned(0, n-1) & add_wide(n)) when "01",
             std_logic_vector(sub_wide(n-1 downto 0)) when "10",
             std_logic_vector(to_unsigned(0, n-1) & not sub_wide(n)) when "11",
             (others => '0') when others;
end architecture dataflow;
