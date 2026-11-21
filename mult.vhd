-- Unsigned multiplier. sel=0 returns the low half; sel=1 returns the high half.
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
    signal product : unsigned(2*n-1 downto 0);
begin
    product <= unsigned(a) * unsigned(b);
    r <= std_logic_vector(product(n-1 downto 0)) when sel = '0' else
         std_logic_vector(product(2*n-1 downto n));
end architecture dataflow;
