-- Six-bit shifter. b supplies the three-bit shift amount.
-- sel=00/01 left, sel=10 logical right, sel=11 arithmetic right.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
    generic (
        n : positive := 6;
        m : positive := 3
    );
    port (
        sel : in  std_logic_vector(1 downto 0);
        a   : in  std_logic_vector(n-1 downto 0);
        b   : in  std_logic_vector(m-1 downto 0);
        r   : out std_logic_vector(n-1 downto 0)
    );
end entity shifter;

architecture dataflow of shifter is
    signal amount : natural range 0 to 2**m-1;
begin
    amount <= to_integer(unsigned(b));

    with sel select
        r <= std_logic_vector(shift_left(unsigned(a), amount))  when "00",
             std_logic_vector(shift_left(unsigned(a), amount))  when "01",
             std_logic_vector(shift_right(unsigned(a), amount)) when "10",
             std_logic_vector(shift_right(signed(a), amount))   when "11",
             (others => '0') when others;
end architecture dataflow;
