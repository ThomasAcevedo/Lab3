-- Structural top-level ALU. Add submodule source files before this file.
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
    signal add_result   : std_logic_vector(5 downto 0);
    signal mult_result  : std_logic_vector(5 downto 0);
    signal logic_result : std_logic_vector(5 downto 0);
    signal shift_result : std_logic_vector(5 downto 0);
    signal shift_amount : std_logic_vector(2 downto 0);
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
