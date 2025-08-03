module instruction_memory (
    input  [255:0]  addr,        // Program Counter address
    output [15:0] instruction  // Output instruction (16 bits wide)
);
    reg [15:0] rom [255:0];    // 256 x 16-bit ROM

    // ROM initialization (using a memory file or inline)
    initial begin
        $readmemh("program.hex", rom);  // Load from external file
    end

    assign instruction = rom[addr];     // Combinational read

endmodule