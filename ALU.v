// 8-bit Arithmetic Logic Unit (ALU)
// This is a purely combinational module that performs arithmetic and
// logical operations based on the alu_op command.

module alu(
    // --- Inputs ---
    input  wire [7:0] a,         // First operand (typically from Accumulator)
    input  wire [7:0] b,         // Second operand (typically from Data Bus)
    input  wire [2:0] alu_op,    // 3-bit operation code from Control Unit

    // --- Outputs ---
    output reg  [7:0] result,    // 8-bit result of the operation
    output reg        zero_flag  // 1-bit flag, high if result is zero
);

    // --- Internal Logic ---

    // This combinational block calculates the result based on the alu_op code.
    always @(*) begin
        case (alu_op)
            3'b000: result = ~a;       // NOT
            3'b001: result = a + b;    // ADD
            3'b010: result = a - b;    // SUB
            3'b011: result = a & b;    // AND
            3'b100: result = a | b;    // OR
            3'b101: result = a ^ b;    // XOR
            3'b110: result = a + 1;    // INC
            3'b111: result = a - 1;    // DEC
            default: result = 8'h00;   // Default case for safety
        endcase
    end

    // This block combinationally sets the zero flag based on the calculated result.
    // It runs in parallel with the calculation logic above.
    always @(*) begin
        if (result == 8'h00) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
    end

endmodule