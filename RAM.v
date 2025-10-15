// Data RAM for the 8-bit Microcontroller
// This module provides read/write memory for storing variables and data.

module ram #(
    // Parameters for memory size
    parameter ADDR_WIDTH = 12, // 2^12 = 4096 locations
    parameter DATA_WIDTH = 8   // 8-bit data words
) (
    // --- Inputs ---
    input wire                  clk,          // System clock
    input wire                  write_enable, // From Control Unit (ram_write_enable)
    input wire [ADDR_WIDTH-1:0] address,      // Address from CU/IR
    input wire [DATA_WIDTH-1:0] data_in,      // Data to be written, from Main Data Bus

    // --- Outputs ---
    output reg [DATA_WIDTH-1:0] data_out      // Data being read, to Main Data Bus
);

    // --- Internal Logic ---

    // 1. Declare the memory array
    // This creates a 2D array to hold the data.
    // It has 2^ADDR_WIDTH locations, each DATA_WIDTH bits wide.
    localparam DEPTH = 1 << ADDR_WIDTH; // Calculate depth (4096)
    reg [DATA_WIDTH-1:0] memory_array [DEPTH-1:0];

    // 2. Initialize the memory to all zeros (for simulation)
    // This block is executed only once at the beginning of the simulation.
    // A for loop is used to write zero to every location in RAM.
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            memory_array[i] = 0;
        end
    end

    // 3. Synchronous Read/Write Logic
    always @(posedge clk) begin
        // Write operation (occurs if write_enable is high)
        if (write_enable) begin
            memory_array[address] <= data_in;
        end

        // Read operation (always occurs)
        // The output will reflect the data at the current address on the next clock cycle.
        // If a write occurs at the same address, the new data will be read out.
        data_out <= memory_array[address];
    end

endmodule