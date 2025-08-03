`timescale 1ns/1ns

module single_port_sync_ram_tb;
    reg clk;
    reg n_rw;
    reg n_cs;
    reg n_oe;
    reg [7:0] addr;
    wire [7:0] data;

    // Internal reg to drive the data bus
    reg [7:0] data_drive;
    reg drive_enable; // controls direction of data bus

    // Reference model
    reg [7:0] ref_model [0:255];

    // Drive data bus
    assign data = drive_enable ? data_drive : 8'bz;

    // Instantiate DUT
    single_port_sync_ram uut(
        .clk(clk),
        .n_rw(n_rw),
        .n_cs(n_cs),
        .n_oe(n_oe),
        .addr(addr),
        .data(data)
    );

    // Waveform dump
    initial begin
        $dumpfile("single_port_sync_ram.vcd");
        $dumpvars(0, single_port_sync_ram_tb);
    end

    // Clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // TASK: write data
    task automatic write_ram(input [7:0] address, input [7:0] value);
        begin
            addr = address;
            data_drive = value;
            drive_enable = 1'b1;  // drive the bus

            n_cs = 1'b0;
            n_rw = 1'b1; // write mode
            n_oe = 1'b1; // disable output during write

            @(posedge clk); // perform write
            n_cs = 1'b1; // deselect
            drive_enable = 1'b0; // release bus

            // update reference model
            ref_model[address] = value;
        end
    endtask

    // TASK: read data and self-check
    task automatic read_ram(input [7:0] address);
        reg [7:0] observed;
        begin
            addr = address;
            drive_enable = 1'b0; // release bus so DUT can drive it

            n_cs = 1'b0;
            n_rw = 1'b0; // read mode
            n_oe = 1'b0; // enable output

            @(posedge clk);
            observed = data;

            n_cs = 1'b1;
            n_oe = 1'b1;

            // check against reference
            if (observed !== ref_model[address]) begin
                $error("Read mismatch at address %0d: expected %0d got %0d", 
                       address, ref_model[address], observed);
            end
        end
    endtask

    // Stimulus
    initial begin
        // Initialize control signals
        n_cs = 1'b1;
        n_rw = 1'b1;
        n_oe = 1'b1;
        addr = 0;
        drive_enable = 1'b0;

        // Initialize reference model
        for (int i = 0; i < 256; i++) ref_model[i] = 0;

        // Wait a little before starting
        #20;

        // Directed write and read
        write_ram(8'd10, 8'hA5);
        read_ram(8'd10);

        write_ram(8'd20, 8'h5A);
        read_ram(8'd20);

        // Randomized tests
        for (int i = 0; i < 20; i++) begin
            byte addr_r = $urandom_range(0,255);
            byte data_r = $urandom_range(0,255);
            write_ram(addr_r, data_r);
            read_ram(addr_r);
        end

        $display("All RAM tests PASSED!");
        $finish;
    end
endmodule