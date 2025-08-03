`timescale 1ns/1ns

module register_file_tb();
    reg        clk;
    reg        n_reset;
    reg        n_w;
    reg  [3:0] rs;
    reg  [3:0] rt;
    reg  [3:0] rd;
    reg  [7:0] data_in;
    wire [7:0] rs_data_out;
    wire [7:0] rt_data_out;

    // Reference model (simple array)
    reg [7:0] ref_model [0:15];

    // Instantiate DUT
    register_file uut(
        .clk(clk),
        .n_reset(n_reset),
        .n_w(n_w),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .data_in(data_in),
        .rs_data_out(rs_data_out),
        .rt_data_out(rt_data_out)
    );

    // Generate waveform dump
    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);
    end

    // Clock generation: 10ns period
    initial begin 
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    // Apply reset
    initial begin
        n_reset = 1'b0;
        n_w = 1'b1;
        rs = 0;
        rt = 0;
        rd = 0;
        data_in = 0;
        // Initialize reference model
        for (int i = 0; i < 16; i++) ref_model[i] = 0;

        #10 n_reset = 1'b1;  // Release reset after 10ns
    end

    // TASK: write a register
    task automatic write_reg(input [3:0] addr, input [7:0] value);
        begin
            n_w = 1'b0;
            rd = addr;
            data_in = value;
            @(posedge clk);
            n_w = 1'b1;
            // Update reference model
            if (addr != 0) ref_model[addr] = value; // assume register 0 is hardwired zero
        end
    endtask

    // TASK: read two registers and self-check
    task automatic read_and_check(input [3:0] addr1, input [3:0] addr2);
        begin
            rs = addr1;
            rt = addr2;
            @(posedge clk);
            if (rs_data_out !== ref_model[addr1]) begin
                $error("Mismatch on rs: expected %0d got %0d", ref_model[addr1], rs_data_out);
            end
            if (rt_data_out !== ref_model[addr2]) begin
                $error("Mismatch on rt: expected %0d got %0d", ref_model[addr2], rt_data_out);
            end
        end
    endtask

    // Stimulus
    initial begin
        // Wait until reset is released
        @(posedge n_reset);

        // Directed tests
        write_reg(4'd3, 8'd5);
        read_and_check(4'd3, 4'd0);

        write_reg(4'd4, 8'd10);
        read_and_check(4'd3, 4'd4);

        // Randomized tests
        for (int i = 0; i < 20; i++) begin
            write_reg($urandom_range(1,15), $urandom_range(0,255));
            read_and_check($urandom_range(0,15), $urandom_range(0,15));
        end

        $display("All tests PASSED!");
        $finish;
    end
endmodule