`timescale 1ns/1ns

module control_unit_tb;
    reg [3:0] opCode;
    wire n_reg_w;
    wire n_mem_rw;
    wire n_mem_cs;
    wire n_mem_oe;

    // Instantiate the control_unit
    control_unit uut (
        .opCode(opCode),
        .n_reg_w(n_reg_w),
        .n_mem_rw(n_mem_rw),
        .n_mem_cs(n_mem_cs),
        .n_mem_oe(n_mem_oe)
    );

    // Array of opcodes in Gray code order
    reg [3:0] op_codes [0:15];
    integer i;

    initial begin
        // Set up waveform dump
        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);

        // Initialize Gray code sequence and names
        op_codes[0]  = 4'b0000;
        op_codes[1]  = 4'b0001;
        op_codes[2]  = 4'b0011;
        op_codes[3]  = 4'b0010;
        op_codes[4]  = 4'b0110;
        op_codes[5]  = 4'b0111;
        op_codes[6]  = 4'b0101;
        op_codes[7]  = 4'b0100;
        op_codes[8]  = 4'b1100;
        op_codes[9]  = 4'b1101;
        op_codes[10] = 4'b1111;
        op_codes[11] = 4'b1110;
        op_codes[12] = 4'b1010;
        op_codes[13] = 4'b1011;
        op_codes[14] = 4'b1001;
        op_codes[15] = 4'b1000;

        // Cycle through the op_codes
        for (i = 0; i < 16; i = i + 1) begin
            opCode = op_codes[i];
            #10;
        end

        #10 $finish;
    end
endmodule