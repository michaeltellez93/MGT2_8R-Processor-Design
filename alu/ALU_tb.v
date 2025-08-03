`timescale 1ps/1ps

module ALU_tb;
    reg [7:0] a, b;
    reg [2:0] opCode;
    wire [7:0] result;
    wire zero;
    wire carry;
    wire overflow;

    ALU uut (
        .a(a),
        .b(b),
        .opCode(opCode),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ALU_tb);

        // *********************ADD Operation Tests*********************
        opCode = 3'b000;

        // Nominal addition: Basic operation, in-range
        a = 8'd1;
        b = 8'd2;
        #10;

        // Addition -> zero: Edge case for zero
        a = 8'd0;
        b = 8'd0;
        #10;

        // Max unsigned (255 + 0): Edge of range, no wrap
        a = 8'd255;
        b = 8'd0;
        #10;

        // Unsigned overflow: Carry-out without signed overflow
        a = 8'd255;
        b = 8'd1;
        #10;

        // Signed overflow (+127 + 1): 01111111 + 00000001 = 10000000
        a = 8'd127;
        b = 8'd1;
        #10;

        // Signed overflow (-64 + -64): 11000000 + 11000000 = 10000000
        a = 8'd192;
        b = 8'd192;
        #10;

        // Postive + Negative: Mixed sign, no overflow
        a = 8'd50;
        b = 8'd206;
        #10;
                
        // Negative + Positive: Mixed sign, no overflow
        a = 8'd200;
        b = 8'd60;
        #10;        
        
        //*********************SUB Operation Tests*********************
        opCode = 3'b001;

        // Nominal subtraction: Basic operation, in-range
        a = 8'd10;
        b = 8'd3;    
        #10;
    
        // Subtraction -> zero: a - a = 0
        a = 8'd77;
        b = 8'd77;
        #10;

        // Unsigned borrow: a < b → wrap
        a = 8'd5;
        b = 8'd10;
        #10;

        // Signed underflow: -128 - 1 → overflow
        a = 8'd128; // -128
        b = 8'd1;
        #10;

        // Signed overflow: 127 - (-1) → wraps negative
        a = 8'd127;
        b = 8'd255; // -1 in two's comp
        #10;

        // Positive - Negative: large positive result, no overflow
        a = 8'd100;
        b = 8'd200; // -56 in signed
        #10;

        // Negative - Positive: large negative result
        a = 8'd200; // -56 in signed
        b = 8'd100;
        #10;
        
        // Subtract - edge: 0 - 255 = 1 (since -(-1) = 1)
        a = 8'd0;
        b = 8'd255;
        #10;
             
        $finish;
    end

endmodule