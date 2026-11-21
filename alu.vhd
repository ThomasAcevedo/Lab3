-- Six-bit unsigned ALU for Lab Assignment 3.
-- The four-bit select mapping follows Table 1 of Lab3.pdf.

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
    add_wide <= ('0' & unsigned(a)) + ('0' & unsigned(b));
    sub_wide <= ('0' & unsigned(a)) + ('0' & not b) + to_unsigned(1, n+1);

    with sel select
        r <= std_logic_vector(add_wide(n-1 downto 0)) when "00",
             std_logic_vector(to_unsigned(0, n-1) & add_wide(n)) when "01",
             std_logic_vector(sub_wide(n-1 downto 0)) when "10",
             std_logic_vector(to_unsigned(0, n-1) & not sub_wide(n)) when "11",
             (others => '0') when others;
end architecture dataflow;

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

library ieee;
use ieee.std_logic_1164.all;

entity logic_unit is
    generic (n : positive := 6);
    port (
        sel : in  std_logic_vector(1 downto 0);
        a   : in  std_logic_vector(n-1 downto 0);
        b   : in  std_logic_vector(n-1 downto 0);
        r   : out std_logic_vector(n-1 downto 0)
    );
end entity logic_unit;

architecture dataflow of logic_unit is
begin
    with sel select
        r <= not a     when "00",
             a and b   when "01",
             a or b    when "10",
             a xor b   when "11",
             (others => '0') when others;
end architecture dataflow;

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

library ieee;
use ieee.std_logic_1164.all;

entity alu is
    port (
        sel : in  std_logic_vector(3 downto 0);
        a   : in  std_logic_vector(5 downto 0);
        b   : in  std_logic_vector(5 downto 0);
        r   : out std_logic_vector(5 downto 0)
    );
end entity alu;

architecture structural of alu is
    signal add_result    : std_logic_vector(5 downto 0);
    signal mult_result   : std_logic_vector(5 downto 0);
    signal logic_result  : std_logic_vector(5 downto 0);
    signal shift_result  : std_logic_vector(5 downto 0);
    signal shift_amount  : std_logic_vector(2 downto 0);
begin
    shift_amount <= b(2 downto 0);

    add_block : entity work.adder(dataflow)
        generic map (n => 6)
        port map (sel => sel(1 downto 0), a => a, b => b, r => add_result);

    mult_block : entity work.mult(dataflow)
        generic map (n => 6)
        port map (sel => sel(0), a => a, b => b, r => mult_result);

    logic_block : entity work.logic_unit(dataflow)
        generic map (n => 6)
        port map (sel => sel(1 downto 0), a => a, b => b, r => logic_result);

    shifter_block : entity work.shifter(dataflow)
        generic map (n => 6, m => 3)
        port map (sel => sel(1 downto 0), a => a, b => shift_amount, r => shift_result);

    with sel(3 downto 2) select
        r <= add_result   when "00",
             mult_result  when "01",
             logic_result when "10",
             shift_result when "11",
             (others => '0') when others;
end architecture structural;
