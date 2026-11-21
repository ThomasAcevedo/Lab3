# Lab 3: Six-Bit ALU (Vivado / VHDL)

This repository contains the supplied Lab 3 assignment and starter materials. The authoritative assignment brief here is `Lab3.pdf`, titled **Design of Digital Systems: Lab Assignment 3**. It specifies a six-bit ALU in VHDL. The other supplied PDF, `Lab 3.pdf`, was an unrelated earthquake-data assignment and is not part of this repository.

## Assignment requirements

Build these units and a top-level `alu` wrapper:

1. **Adder (`adder`)**: six-bit `a`, `b`, two-bit `sel`, six-bit `r`.
2. **Multiplier (`mult`)**: six-bit inputs, one-bit `sel`, six-bit output. Compute the full 12-bit product internally and select its low or high six bits.
3. **Logic unit (`logic_unit`)**: bitwise NOT, AND, OR, XOR.
4. **Shifter (`shifter`)**: six-bit value `a`, three-bit shift amount `b`, two-bit `sel`.
5. **ALU wrapper (`alu`)**: four-bit top-level select and six-bit operands/result. Instantiate the four units and select the output. The PDF says a separate mux unit is not needed.
6. **Testbench**: test all 16 top-level select values for all three operand pairs listed below.
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

## What `sim.vhd` already contains

`sim.vhd` is **not a completed ALU**. It includes declarations for the five design units and example simulation benches for each submodule and for `alu`. The design architectures are placeholders; the components still need implementations and the wrapper still needs its internal signals, instances, and select mux.

The benches are stimulus examples, not self-checking tests: they do not contain assertions that automatically flag an incorrect output. The supplied `alu_sim` does iterate over all 16 select values for the three required operand pairs. Its stimulus uses the legacy `ieee.std_logic_arith` package for integer-to-vector conversion; use the course-approved packages consistently if Vivado reports a package conflict. The standalone shifter bench does not fully represent the assignment (its selector/input coverage differs), so use the required top-level `alu_sim` vectors as the final coverage checklist.

## Vivado step by step

1. Create a new **RTL Project** in Vivado. Select the FPGA board/device required by your course. The PDF's final page maps logical I/O to switches and LEDs, but does not provide FPGA package pin names.
2. Add `sim.vhd` as a VHDL **Design Source**. It contains all design entities/architectures and the benches in one file. You may instead split each design unit and testbench into separate `.vhd` files; keep each entity with its architecture and add dependencies before the wrapper.
3. Implement and simulate one submodule at a time: adder, multiplier, logic unit, then shifter. Use simple `ieee.numeric_std` arithmetic and explicit vector widths. The template already gives the intended interfaces. For shifts, `shift_left`, `shift_right(unsigned(...))`, and `shift_right(signed(...))` express the required behavior directly.
4. In the structural `alu`, instantiate each submodule and decode the four-bit `sel` according to the table above. The most significant two select bits choose the unit; the lower bits select the operation within it. For multiplier, `sel[1]` is the don't-care bit and `sel[0]` selects product half. For left shift, `sel[0]` is a don't-care bit.
5. Add the benches to **Simulation Sources** (or keep them in the combined file), choose a simulation top such as `adder_sim`, and run **Run Behavioral Simulation**. Inspect the waveform against hand-calculated cases and the assignment table. Then run `alu_sim` and verify every select for all three required operand pairs. Because the benches have no assertions, record/check outputs in the waveform yourself or add simple assertions.
6. For hardware demonstration, connect the top-level ports as the PDF specifies: `sel` to switches 15–12, `a` to switches 11–6, `b` to switches 5–0, and `r` to LEDs 5–0.
7. Create an `.xdc` using the master constraints file for the exact board/revision. Assign the switch and LED logical ports to their actual FPGA package pins and set the board-required I/O standards. The PDF does not identify the board or list package pin names, so those assignments cannot safely be filled in from the provided files alone.
8. Synthesize/program the board for the demo. The assignment explicitly says **not** to collect timing results.

Keep the implementation at the level of the course examples: one-bit carry signals, widened unsigned arithmetic, `case`/`with-select` muxes, simple bitwise operations, and the built-in shift operations. No advanced arithmetic architecture is needed.

## Included files

- `Lab3.pdf` — correct five-page ALU assignment brief.
- `Lab3_Notes-1-1.txt` — notes on the required units and arithmetic/shifting.
- `design template.txt` — supplied VHDL interfaces and architecture placeholders.
- `sim.vhd` — supplied placeholders and simulation benches.
- `lab3_example_for_adder.txt` — worked adder/subtractor example.
