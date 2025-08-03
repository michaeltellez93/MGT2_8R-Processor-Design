`timescale 1ns/1ns

module counter_tb;
    reg clk;
    reg reset;
    wire [3:0] count;

    // Instantiate counter
    counter uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation: toggle every 5 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Enable waveform dump
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);

        // Apply reset
        reset = 1;
        #10;
        reset = 0;

        // Run for some cycles
        #100;

        // Finish simulation
        $finish;
    end
endmodule