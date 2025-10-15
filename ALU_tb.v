// Testbench for the 8-bit ALU
// This testbench will cycle through all 8 operations of the ALU
// and display the results to verify correctness.

`timescale 1ns / 1ps

module alu_tb;

    // --- Inputs to the ALU ---
    reg  [7:0] a_in;
    reg  [7:0] b_in;
    reg  [2:0] alu_op_in;

    // --- Outputs from the ALU ---
    wire [7:0] result_out;
    wire       zero_flag_out;

    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a_in),
        .b(b_in),
        .alu_op(alu_op_in),
        .result(result_out),
        .zero_flag(zero_flag_out)
    );

    // --- Test Sequence ---
    initial begin
        $display("--- Starting ALU Testbench ---");

        // Test Case 1: NOT
        a_in = 8'hAA; // 10101010
        b_in = 8'h00; // Not used
        alu_op_in = 3'b000; // NOT
        #10; // Wait 10ns
        $display("NOT(0x%h) = 0x%h", a_in, result_out);

        // Test Case 2: ADD
        a_in = 8'd20;
        b_in = 8'd15;
        alu_op_in = 3'b001; // ADD
        #10;
        $display("%d + %d = %d", a_in, b_in, result_out);
        
        // Test Case 3: SUB and Zero Flag
        a_in = 8'd50;
        b_in = 8'd50;
        alu_op_in = 3'b010; // SUB
        #10;
        $display("%d - %d = %d, Zero Flag = %b", a_in, b_in, result_out, zero_flag_out);
        
        // Test Case 4: AND
        a_in = 8'b11001100;
        b_in = 8'b10101010;
        alu_op_in = 3'b011; // AND
        #10;
        $display("0b%b AND 0b%b = 0b%b", a_in, b_in, result_out);
        
        // Test Case 5: OR
        a_in = 8'b11001100;
        b_in = 8'b10101010;
        alu_op_in = 3'b100; // OR
        #10;
        $display("0b%b OR 0b%b = 0b%b", a_in, b_in, result_out);

        // Test Case 6: XOR
        a_in = 8'b11001100;
        b_in = 8'b10101010;
        alu_op_in = 3'b101; // XOR
        #10;
        $display("0b%b XOR 0b%b = 0b%b", a_in, b_in, result_out);

        // Test Case 7: INC
        a_in = 8'd99;
        b_in = 8'h00; // Not used
        alu_op_in = 3'b110; // INC
        #10;
        $display("INC(%d) = %d", a_in, result_out);
        
        // Test Case 8: DEC and Zero Flag
        a_in = 8'd1;
        b_in = 8'h00; // Not used
        alu_op_in = 3'b111; // DEC
        #10;
        $display("DEC(%d) = %d, Zero Flag = %b", a_in, result_out, zero_flag_out);

        $display("--- ALU Testbench Finished ---");
        $finish;
    end

endmodule
