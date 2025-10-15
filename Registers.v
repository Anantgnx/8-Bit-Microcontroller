// This file contains the core registers for the 8-bit microcontroller.

// --- 1. Program Counter (PC) ---
// A 12-bit register that holds the address of the next instruction to be fetched.
// It supports synchronous reset, parallel load (for jumps), and incrementing.
module program_counter #(
    parameter ADDR_WIDTH = 12
)(
    // --- Inputs ---
    input wire                  clk,
    input wire                  reset,
    input wire                  pc_inc,          // From CU: Increment PC
    input wire                  pc_write_enable, // From CU: Load a new address
    input wire [ADDR_WIDTH-1:0] pc_in,           // From IR: New address for jumps

    // --- Outputs ---
    output reg [ADDR_WIDTH-1:0] pc_out         // To ROM: Current instruction address
);

    // Synchronous logic for PC operations
    // Assignments are made directly to the output register.
    always @(posedge clk) begin
        if (reset) begin
            // On reset, force the PC to address 0
            pc_out <= 0;
        end
        else if (pc_write_enable) begin
            // For jumps, load the address from the pc_in bus
            pc_out <= pc_in;
        end
        else if (pc_inc) begin
            // For normal instruction fetching, increment the PC
            pc_out <= pc_out + 1;
        end
        // If no control signal is active, the pc_out register holds its value implicitly.
    end

endmodule


// --- 2. Instruction Register (IR) ---
// A 16-bit register that holds the full instruction being executed.
// It is loaded in two 8-bit chunks.
module instruction_register #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 4,
    parameter OPERAND_WIDTH = 12
)(
    // --- Inputs ---
    input wire                  clk,
    input wire                  reset,
    input wire                  ir_high_write_enable, // From CU: Load upper byte
    input wire                  ir_low_write_enable,  // From CU: Load lower byte
    input wire [DATA_WIDTH-1:0] data_in,          // From ROM: 8-bit instruction byte

    // --- Outputs ---
    output wire [OPCODE_WIDTH-1:0]  opcode_out,   // To CU: 4-bit opcode
    output wire [OPERAND_WIDTH-1:0] operand_out   // To datapath: 12-bit operand/address
);

    // Internal 16-bit register to store the full instruction
    reg [15:0] ir_reg;

    // Synchronous logic for loading the IR
    always @(posedge clk) begin
        if (reset) begin
            ir_reg <= 16'h0000; // Reset the entire register to zero
        end else begin
            // Load the upper byte (Opcode + upper 4 bits of operand)
            if (ir_high_write_enable) begin
                ir_reg[15:8] <= data_in;
            end
            // Load the lower byte (lower 8 bits of operand)
            if (ir_low_write_enable) begin
                ir_reg[7:0] <= data_in;
            end
        end
    end

    // Continuous assignment of outputs from the internal register
    // The outputs always reflect the current state of ir_reg.
    assign opcode_out = ir_reg[15:12];
    assign operand_out = ir_reg[11:0];

endmodule


// --- 3. Accumulator (ACC) ---
// An 8-bit register that serves as the primary working register for the CPU.
module accumulator #(
    parameter DATA_WIDTH = 8
)(
    // --- Inputs ---
    input wire                  clk,
    input wire                  reset,
    input wire                  acc_write_enable, // From CU: Load a new value
    input wire [DATA_WIDTH-1:0] data_in,          // From a MUX: Value to be loaded

    // --- Outputs ---
    output reg [DATA_WIDTH-1:0] data_out          // To ALU and Main Data Bus
);

    // Synchronous logic for the accumulator
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 0; // Reset to zero
        end
        else if (acc_write_enable) begin
            data_out <= data_in; // Load new value
        end
        // If write_enable is low, the register holds its value.
    end

endmodule


// --- 4. Zero Flag (Z) Register ---
// A 1-bit register (flip-flop) to store the zero flag from the ALU.
module zero_flag_register (
    // --- Inputs ---
    input wire clk,
    input wire reset,
    input wire z_flag_write_enable, // From CU: Update the flag
    input wire z_flag_in,           // From ALU: New flag value

    // --- Outputs ---
    output reg z_flag_out           // To CU: Current flag value
);

    // Synchronous logic for the zero flag
    always @(posedge clk) begin
        if (reset) begin
            z_flag_out <= 1'b0; // Reset to 0
        end
        else if (z_flag_write_enable) begin
            z_flag_out <= z_flag_in; // Load new value from ALU
        end
        // If write_enable is low, the flag holds its value.
    end

endmodule