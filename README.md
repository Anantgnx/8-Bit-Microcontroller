# 8-bit Microcontroller in Verilog

## 1. Project Overview

This project is a complete 8-bit microcontroller designed from the ground up in Verilog. It serves as an educational exercise in computer architecture, digital logic design, and hardware description languages. The design is a classic **Harvard architecture** with separate buses for instructions and data, built around a simple but functional accumulator-based CPU core.

The entire system, from the control unit's state machine to the individual registers, is described behaviorally and then connected structurally in a top-level module, simulating a real-world System-on-a-Chip (SoC) design process.




## 2. Architecture & Features

* **8-bit Datapath**: The ALU, accumulator, and all data buses operate on 8-bit data.
* **Accumulator-Based**: A single 8-bit accumulator (ACC) serves as the primary working register for all arithmetic and logical operations.
* **16-bit Instructions**: A custom 16-instruction ISA with a fixed-length 16-bit format (`[4-bit Opcode | 12-bit Operand]`).
* **12-bit Address Space**: Allows for up to 4096 bytes of Program ROM and 4096 bytes of Data RAM / I/O.
* **Memory-Mapped I/O (MMIO)**: I/O ports are accessed using the same instructions (`LOAD`/`STORE`) and address space as Data RAM, simplifying the Control Unit design.
* **Multi-Cycle Execution**: Instructions take between 3 to 5 clock cycles to complete, based on their complexity (e.g., memory access vs. register-only operations).
* **Modular Design**: Each component (CU, ALU, registers, memory) is designed in its own Verilog file for clarity and testability.

### Block Diagram

## 3. Instruction Set Architecture (ISA)

The microcontroller implements a custom 16-instruction set.

| Opcode (Hex) | Mnemonic | Description                                               | Cycles |
| :----------- | :------- | :-------------------------------------------------------- | :----: |
| `0x0`        | `LDI`    | **Load Immediate**: Load an 8-bit constant into the ACC.  |   4    |
| `0x1`        | `LOAD`   | **Load**: Load a value from a RAM address into the ACC.   |   5    |
| `0x2`        | `STORE`  | **Store**: Store the ACC value into a RAM address.        |   5    |
| `0x3`        | `MOV`    | **(Reserved)** Acts as a No-Operation (`NOP`).            |   3    |
| `0x4`        | `ADD`    | **Add**: Add a value from RAM to the ACC.                 |   5    |
| `0x5`        | `SUB`    | **Subtract**: Subtract a value from RAM from the ACC.     |   5    |
| `0x6`        | `INC`    | **Increment**: Add 1 to the ACC.                          |   4    |
| `0x7`        | `DEC`    | **Decrement**: Subtract 1 from the ACC.                   |   4    |
| `0x8`        | `AND`    | **Logical AND**: Bitwise AND a value from RAM with the ACC. |   5    |
| `0x9`        | `OR`     | **Logical OR**: Bitwise OR a value from RAM with the ACC.  |   5    |
| `0xA`        | `XOR`    | **Logical XOR**: Bitwise XOR a value from RAM with the ACC.|   5    |
| `0xB`        | `NOT`    | **Logical NOT**: Invert all bits of the ACC.              |   4    |
| `0xC`        | `JMP`    | **Jump**: Unconditionally jump to a program address.      |   4    |
| `0xD`        | `JZ`     | **Jump if Zero**: Jump if the Zero Flag is set.           |   4    |
| `0xE`        | `IN`     | **Input**: Read from an I/O port into the ACC.            |   5    |
| `0xF`        | `OUT`    | **Output**: Write the ACC value to an I/O port.           |   5    |

## 4. Project Files

### Verilog Source Files (`.v`)
* `Top_level.v`: The top-level structural file that connects all modules.
* `CU.v`: The FSM-based Control Unit; the brain of the CPU.
* `ALU.v`: The 8-bit Arithmetic Logic Unit.
* `Registers.v`: Contains the Program Counter, Instruction Register, Accumulator, and Zero Flag Register.
* `ROM.v`: The behavioral model for the Program ROM.
* `RAM.v`: The behavioral model for the Data RAM.