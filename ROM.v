// Read-Only Memory (ROM) for the 8-bit Microcontroller
// This module stores the program instructions. It is written to at the
// start of the simulation and is read-only during normal operation.

module rom #(
    // Parameters for memory size
    parameter ADDR_WIDTH = 12, // 2^12 = 4096 locations
    parameter DATA_WIDTH = 8   // 8-bit instructions
) (
    // --- Inputs ---
    input wire                  clk,       // System clock
    input wire [ADDR_WIDTH-1:0] address,   // Address from the Program Counter

    // --- Outputs ---
    output reg [DATA_WIDTH-1:0] data_out   // 8-bit instruction output
);

    // --- Internal Logic ---

    // 1. Declare the memory array
    // This creates a 2D array to hold the program instructions.
    // It has 2^ADDR_WIDTH locations, each DATA_WIDTH bits wide.
    localparam DEPTH = 1 << ADDR_WIDTH; // Calculate depth (4096)
    reg [DATA_WIDTH-1:0] memory_array [DEPTH-1:0];

    // 2. Initialize the memory from a file (for simulation)
    // This block is executed only once at the beginning of the simulation.
    // It reads the hexadecimal values from "program.mem" into the array.
    initial begin
        $readmemh("program.mem", memory_array);
    end

    // 3. Synchronous Read Logic
    // On every rising edge of the clock, output the data from the
    // memory location specified by the current address.
    always @(posedge clk) begin
        data_out <= memory_array[address];
    end

endmodule