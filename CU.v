// 8-bit Microcontroller Control Unit
// Handles the Fetch-Decode-Execute cycle using a Finite State Machine.
// Updated for a 16-instruction set with a 16-bit instruction length.

module control_unit(
    // --- Inputs ---
    input wire clk,
    input wire reset,
    input wire [3:0] opcode, // Opcode is now 4 bits wide
    input wire zero_flag,

    // --- Outputs (Control Signals) ---
    // Program Counter Controls
    output reg pc_write_enable,
    output reg pc_inc,

    // Instruction Register Controls
    output reg ir_high_write_enable,
    output reg ir_low_write_enable,

    // Accumulator Controls
    output reg acc_write_enable,

    // Memory Controls
    output reg ram_read_enable,
    output reg ram_write_enable,
    
    // Status Flag Controls
    output reg z_flag_write_enable, // New signal

    // ALU Controls
    output reg [2:0] alu_op,

    // Bus and MUX Select Controls
    output reg addr_bus_select,
    output reg [1:0] acc_input_select,
    output reg pc_input_select,
    output reg data_bus_select
);

    // --- 1. FSM State Definitions ---
    // ... (rest of the file is unchanged from the last complete version) ...
    // --- 5. Output Logic (Combinational) ---
    always @(*) begin
        // Default all signals to 'off' (0)
        pc_write_enable = 1'b0;
        pc_inc = 1'b0;
        ir_high_write_enable = 1'b0;
        ir_low_write_enable = 1'b0;
        acc_write_enable = 1'b0;
        ram_read_enable = 1'b0;
        ram_write_enable = 1'b0;
        z_flag_write_enable = 1'b0; // Default to off
        alu_op = 3'b000;
        addr_bus_select = 1'b0;
        acc_input_select = 2'b00;
        pc_input_select = 1'b0;
        data_bus_select = 1'b0;

        // Assert signals based on the current FSM state
        case (current_state)
            // ... (Fetch and other execute states are unchanged) ...
            EXECUTE_ALU_OP: begin // For ADD, SUB, AND, OR, XOR
                z_flag_write_enable = 1'b1; // Update the zero flag
                // ... (rest of the logic for this state is unchanged) ...
            end
            EXECUTE_INC_DEC: begin // For INC, DEC
                z_flag_write_enable = 1'b1; // Update the zero flag
                // ... (rest of the logic for this state is unchanged) ...
            end
            EXECUTE_NOT: begin // For NOT
                z_flag_write_enable = 1'b1; // Update the zero flag
                // ... (rest of the logic for this state is unchanged) ...
            end
            // ... (rest of the case statement is unchanged) ...
        endcase
    end

endmodule

