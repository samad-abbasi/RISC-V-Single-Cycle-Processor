# RISC-V Single-Cycle Processor (Verilog)

A 32-bit RISC-V (RV32I subset) single-cycle processor written in Verilog and simulated in Xilinx Vivado 2018. Every instruction completes in one clock cycle: fetch, decode, execute, memory access and write-back all happen in the same cycle.

## Supported instructions
| Type | Instructions |
|---|---|
| R-type | `add`, `sub`, `and`, `or` |
| Load / Store | `lw`, `sw` |
| Branch | `beq` |
| Jump | `jal` |

## Architecture
- **PC + adders**: `pc_32bit.v`, `adder.v` (PC+4 and branch/jump target)
- **Instruction memory**: `INST_MEM.v` (byte-addressable, program preloaded)
- **Register file**: `REG_FILE.v` (32 × 32-bit, x0 hard-wired to 0)
- **Immediate generator**: `Imm_Gen.v` (I, S, B, J formats)
- **ALU**: `ALU.v`
- **Data memory**: `data_mem.v`
- **Control unit**: `control_unit.v` = main decoder + ALU decoder
- **Muxes**: `mux_2x1.v` (2:1 and 3:1)
- **Top level**: `top_module.v`

## Repository structure
```
rtl/    Verilog design sources
tb/     Unit testbenches for each block + top-level testbench (tb_top_module.v)
docs/   Full report: datapath, control signals, simulation results
```

## How to simulate
1. Create a Vivado project and add all files in `rtl/` as design sources.
2. Add `tb/tb_top_module.v` as the simulation source and set it as top.
3. Run behavioral simulation and watch the PC, instruction, register file and ALU result.

Each block also has its own testbench in `tb/` (ALU, register file, immediate generator, decoders, memories).

## Report
See [`docs/Single_Cycle_Report.pdf`](docs/Single_Cycle_Report.pdf) for the datapath, control-unit analysis and waveforms.

---
Built as part of the Computer Architecture module, Chip Design & Verification program, GIKI.
Reference: Harris & Harris, *Digital Design and Computer Architecture: RISC-V Edition*.
