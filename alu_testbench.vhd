-- Self-checking ALU testbench: all 16 select values for the three required
-- operand pairs from Lab3.pdf. Run alu_testbench as the simulation top.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_testbench is
end entity alu_testbench;

architecture test of alu_testbench is
    subtype word_t is std_logic_vector(5 downto 0);
    type word_array_t is array (natural range <>) of word_t;

    constant operand_a : word_array_t := ("000100", "110001", "111111");
    constant operand_b : word_array_t := ("000010", "110010", "111111");

    signal sel : std_logic_vector(3 downto 0) := (others => '0');
    signal a   : word_t := (others => '0');
    signal b   : word_t := (others => '0');
    signal r   : word_t;

    function expected_result(
        operation : std_logic_vector(3 downto 0);
        left_arg  : word_t;
        right_arg : word_t
    ) return word_t is
        variable wide_sum     : unsigned(6 downto 0);
        variable wide_product : unsigned(11 downto 0);
        variable shift_count  : natural;
        variable signed_left  : signed(5 downto 0);
    begin
        case operation is
            when "0000" =>
                wide_sum := unsigned('0' & left_arg) + unsigned('0' & right_arg);
                return std_logic_vector(wide_sum(5 downto 0));
            when "0001" =>
                wide_sum := unsigned('0' & left_arg) + unsigned('0' & right_arg);
                return "00000" & std_logic(wide_sum(6));
            when "0010" =>
                return std_logic_vector(unsigned(left_arg) - unsigned(right_arg));
            when "0011" =>
                if unsigned(left_arg) < unsigned(right_arg) then
                    return "000001";
                else
                    return "000000";
                end if;
            when "0100" | "0110" =>
                wide_product := unsigned(left_arg) * unsigned(right_arg);
                return std_logic_vector(wide_product(5 downto 0));
            when "0101" | "0111" =>
                wide_product := unsigned(left_arg) * unsigned(right_arg);
                return std_logic_vector(wide_product(11 downto 6));
            when "1000" => return not left_arg;
            when "1001" => return left_arg and right_arg;
            when "1010" => return left_arg or right_arg;
            when "1011" => return left_arg xor right_arg;
            when "1100" | "1101" =>
                shift_count := to_integer(unsigned(right_arg(2 downto 0)));
                return std_logic_vector(shift_left(unsigned(left_arg), shift_count));
            when "1110" =>
                shift_count := to_integer(unsigned(right_arg(2 downto 0)));
                return std_logic_vector(shift_right(unsigned(left_arg), shift_count));
            when "1111" =>
                shift_count := to_integer(unsigned(right_arg(2 downto 0)));
                signed_left := signed(left_arg);
                return std_logic_vector(shift_right(signed_left, shift_count));
            when others => return (others => '0');
        end case;
    end function;
begin
    dut : entity work.alu(structural)
        port map (sel => sel, a => a, b => b, r => r);

    stimulus : process
        variable expected : word_t;
    begin
        for vector_index in operand_a'range loop
            a <= operand_a(vector_index);
            b <= operand_b(vector_index);
            wait for 1 ns;

            for operation in 0 to 15 loop
                sel <= std_logic_vector(to_unsigned(operation, sel'length));
                wait for 1 ns;
                expected := expected_result(sel, a, b);
                assert r = expected
                    report "ALU mismatch for vector " & integer'image(vector_index) &
                           ", select " & integer'image(operation)
                    severity error;
            end loop;
        end loop;

        report "All ALU test vectors passed." severity note;
        wait;
    end process;
end architecture test;
