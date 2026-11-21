# Lab 3: Six-Bit ALU (Vivado / VHDL)

This repository contains the supplied Lab 3 assignment and starter materials. The authoritative assignment brief here is `Lab3.pdf`, titled **Design of Digital Systems: Lab Assignment 3**. It specifies a six-bit ALU in VHDL. The other supplied PDF, `Lab 3.pdf`, was an unrelated earthquake-data assignment and is not part of this repository.

## Assignment requirements

The implementation and a self-checking simulation bench are now included:

1. **Adder (`adder`)**: six-bit `a`, `b`, two-bit `sel`, six-bit `r`.
2. **Multiplier (`mult`)**: six-bit inputs, one-bit `sel`, six-bit output. It computes the full 12-bit product internally and selects its low or high six bits.
3. **Logic unit (`logic_unit`)**: bitwise NOT, AND, OR, XOR.
4. **Shifter (`shifter`)**: six-bit value `a`, three-bit shift amount `b`, two-bit `sel`.
5. **ALU wrapper (`alu`)**: four-bit top-level select and six-bit operands/result. It instantiates the four units and selects the output. The PDF says a separate mux unit is not needed.
6. **Testbench**: `alu_testbench.vhd` checks all 16 top-level select values for all three operand pairs listed below.
7. **FPGA demo**: demonstrate the testbench scenarios. Do not collect timing results.

### Select table

| ALU `sel` | Result |
| --- | --- |
| `0000` | `a + b`, low six bits |
| `0001` | Addition carry, zero-extended to six bits |
| `0010` | `a - b`, low six bits |
| `0011` | Subtraction borrow, zero-extended to six bits |
| `0100` / `0110` | Product low six bits (`01X0`) |
| `0101` / `0111` | Product high six bits (`01X1`) |
| `1000` | Bitwise NOT `a` |
| `1001` | `a AND b` |
| `1010` | `a OR b` |
| `1011` | `a XOR b` |
| `1100` / `1101` | Logical left shift `a` by `b` (`110X`); zeros shift in |
| `1110` | Logical right shift; zeros shift in |
| `1111` | Arithmetic right shift; copies `a(5)` into shifted positions |

The submodule selectors for left shift are both specified to perform the same operation.

### Required top-level test vectors

Test every `sel` value from `0000` through `1111` for each pair:

| `a` | `b` | Decimal values |
| --- | --- | --- |
| `000100` | `000010` | 4, 2 |
| `110001` | `110010` | 49, 50 |
| `111111` | `111111` | 63, 63 |

For add/subtract, the assignment treats operands as six-bit unsigned values. Implement subtraction as `a + not(b) + 1`; the subtraction borrow is the inverse of the carry-out from that two's-complement addition. This matches the PDF's terminology and its required zero-extended one-bit borrow output.

## What the VHDL files contain

`sim.vhd` is the supplied **starter template**, not a completed ALU. It preserves the original placeholder architectures and example benches. The completed design is split into one module per file: `adder.vhd`, `shifter.vhd`, `mult.vhd`, and `logicunit.vhd`. `alu.vhd` contains only the wrapper. `alu_testbench.vhd` checks every select value for each required operand pair and raises an assertion error if an output differs from the expected result.

Add the split design files to Vivado, not `sim.vhd`; the starter file redeclares the same design units. Keep `sim.vhd` as a reference for the original interface and stimulus examples. The self-checking testbench covers unsigned subtraction borrow and signed arithmetic right shift as specified in the PDF.

## Vivado step by step

1. Create a new **RTL Project** in Vivado. Select the FPGA board/device required by your course. The PDF's final page maps logical I/O to switches and LEDs, but does not provide FPGA package pin names.
2. Add `adder.vhd` as a **Design Source**. Read its short comments and trace the widened sum and two's-complement subtraction to understand how it produces result, carry, and borrow.
3. Add `shifter.vhd` and simulate/inspect the three shift modes. It uses the low three bits of the top-level `b` operand as the shift amount.
4. Add `mult.vhd` and `logicunit.vhd`, then inspect their `sel` behavior against the select table above.
5. Add `alu.vhd` last. It instantiates those four units and routes the result based on `sel(3 downto 2)`. Vivado can resolve the direct entity instantiations once all five design files are in the project.
6. Add `alu_testbench.vhd` under **Simulation Sources** and set `alu_testbench` as the simulation top. Run **Run Behavioral Simulation**. Each of the 48 select/vector cases is checked with an assertion; a mismatch is reported as an error, and a passing run reports that all vectors passed. The original separate benches are in `sim.vhd` for reference, but do not add that combined starter file because it redeclares the design entities.
7. For hardware demonstration, connect the top-level ports as the PDF specifies: `sel` to switches 15–12, `a` to switches 11–6, `b` to switches 5–0, and `r` to LEDs 5–0.
8. Create an `.xdc` using the master constraints file for the exact board/revision. Assign the switch and LED logical ports to their actual FPGA package pins and set the board-required I/O standards. The PDF does not identify the board or list package pin names, so those assignments cannot safely be filled in from the provided files alone.
9. Synthesize/program the board for the demo. The assignment explicitly says **not** to collect timing results.

Keep the implementation at the level of the course examples: one-bit carry signals, widened unsigned arithmetic, `case`/`with-select` muxes, simple bitwise operations, and the built-in shift operations. No advanced arithmetic architecture is needed.

## Included files

- `Lab3.pdf` — correct five-page ALU assignment brief.
- `Lab3_Notes-1-1.txt` — notes on the required units and arithmetic/shifting.
- `design template.txt` — supplied VHDL interfaces and architecture placeholders.
- `sim.vhd` — supplied placeholders and original simulation benches.
- `adder.vhd` — adder and subtractor.
- `shifter.vhd` — logical/arithmetic shifter.
- `mult.vhd` — low/high six-bit multiplier.
- `logicunit.vhd` — bitwise logic unit.
- `alu.vhd` — structural top-level wrapper.
- `alu_testbench.vhd` — self-checking testbench for all required inputs and operations.
- `lab3_example_for_adder.txt` — worked adder/subtractor example.
