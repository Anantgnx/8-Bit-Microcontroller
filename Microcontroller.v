// Top-level structural module for the 8-bit microcontroller.
// This file connects all the individual components (CU, ALU, registers, memory)
// to form the complete datapath and processor core.

module mcu_top(
    input wire clk,
    input wire reset
    // Note: External I/O pins will be added later.
);

    // --- Wires for connecting modules ---

    // Data and Address Buses
    wire [11:0] pc_out_bus;
    wire [7:0]  rom_data_out_bus;
    wire [11:0] ir_operand_bus;
    wire [3:0]  ir_opcode_bus;
    wire [11:0] main_address_bus;
    wire [7:0]  ram_data_out_bus;
    wire [7:0]  acc_data_out_bus;
    wire [7:0]  acc_data_in_bus;
    wire [7:0]  alu_result_bus;

    // Control Signals from CU
    wire        pc_inc;
    wire        pc_write_enable;
    wire        ir_high_write_enable;
    wire        ir_low_write_enable;
    wire        acc_write_enable;
    wire        ram_read_enable;
    wire        ram_write_enable;
    wire        z_flag_write_enable;
    wire [2:0]  alu_op;
    wire        addr_bus_select;
    wire [1:0]  acc_input_select;
    wire        pc_input_select;
    wire        data_bus_select;

    // Status Flags
    wire        alu_zero_flag_out;
    wire        zfr_zero_flag_out;


    // --- 1. Instantiate the Control Unit (CU) ---
    control_unit uut_cu (
        .clk(clk),
        .reset(reset),
        .opcode(ir_opcode_bus),
        .zero_flag(zfr_zero_flag_out),
        // Control Outputs
        .pc_write_enable(pc_write_enable),
        .pc_inc(pc_inc),
        .ir_high_write_enable(ir_high_write_enable),
        .ir_low_write_enable(ir_low_write_enable),
        .acc_write_enable(acc_write_enable),
        .ram_read_enable(ram_read_enable),
        .ram_write_enable(ram_write_enable),
        .z_flag_write_enable(z_flag_write_enable),
        .alu_op(alu_op),
        .addr_bus_select(addr_bus_select),
        .acc_input_select(acc_input_select),
        .pc_input_select(pc_input_select),
        .data_bus_select(data_bus_select)
    );

    // --- 2. Instantiate the ALU ---
    alu uut_alu (
        .a(acc_data_out_bus),
        .b(ram_data_out_bus), // ALU's B input comes from RAM/IO
        .alu_op(alu_op),
        .result(alu_result_bus),
        .zero_flag(alu_zero_flag_out)
    );

    // --- 3. Instantiate Memory ---
    rom uut_rom (
        .clk(clk),
        .address(pc_out_bus),
        .data_out(rom_data_out_bus)
    );

    ram uut_ram (
        .clk(clk),
        .write_enable(ram_write_enable),
        .address(main_address_bus),
        .data_in(acc_data_out_bus), // Data to be written comes from ACC
        .data_out(ram_data_out_bus)
    );

    // --- 4. Instantiate Registers ---
    program_counter uut_pc (
        .clk(clk),
        .reset(reset),
        .pc_inc(pc_inc),
        .pc_write_enable(pc_write_enable),
        .pc_in(ir_operand_bus), // Jump address comes from IR
        .pc_out(pc_out_bus)
    );

    instruction_register uut_ir (
        .clk(clk),
        .reset(reset),
        .ir_high_write_enable(ir_high_write_enable),
        .ir_low_write_enable(ir_low_write_enable),
        .data_in(rom_data_out_bus),
        .opcode_out(ir_opcode_bus),
        .operand_out(ir_operand_bus)
    );

    accumulator uut_acc (
        .clk(clk),
        .reset(reset),
        .acc_write_enable(acc_write_enable),
        .data_in(acc_data_in_bus),
        .data_out(acc_data_out_bus)
    );

    zero_flag_register uut_zfr (
        .clk(clk),
        .reset(reset),
        .z_flag_write_enable(z_flag_write_enable),
        .z_flag_in(alu_zero_flag_out),
        .z_flag_out(zfr_zero_flag_out)
    );

    // --- 5. Datapath Logic (Multiplexers and Bus assignments) ---

    // The main address bus is sourced from the IR's operand
    assign main_address_bus = ir_operand_bus;

    // The accumulator's input is controlled by a MUX
    reg [7:0] acc_in_mux_out;
    always @(*) begin
        case (acc_input_select)
            2'b00:  acc_in_mux_out = alu_result_bus;     // Source: ALU result
            2'b01:  acc_in_mux_out = ram_data_out_bus;    // Source: RAM/IO data
            2'b10:  acc_in_mux_out = {4'b0000, ir_operand_bus[7:0]}; // Source: Immediate from IR (lower 8 bits)
            default: acc_in_mux_out = 8'h00;
        endcase
    end
    assign acc_data_in_bus = acc_in_mux_out;

endmodule