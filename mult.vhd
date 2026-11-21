-- MULTIPLIER
-- Two n-bit inputs make a 2n-bit product.
-- sel = 0 returns the lower half; sel = 1 returns the upper half.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
    generic (n : positive := 6);
    port (
        sel : in  std_logic;
        a   : in  std_logic_vector(n-1 downto 0);
        b   : in  std_logic_vector(n-1 downto 0);
        r   : out std_logic_vector(n-1 downto 0)
    );
end entity mult;

architecture dataflow of mult is
    -- For the lab n=6, so product is 12 bits wide.
    signal product : unsigned(2*n-1 downto 0);
begin
    product <= unsigned(a) * unsigned(b);

    -- Select either product(5 downto 0) or product(11 downto 6).
    r <= std_logic_vector(product(n-1 downto 0)) when sel = '0' else
         std_logic_vector(product(2*n-1 downto n));
end architecture dataflow;
