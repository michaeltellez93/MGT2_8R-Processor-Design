module ALU(
    input [7:0] a,
    input [7:0] b,
    input [3:0] opCode,
    output reg [7:0] result,
    output reg zero,
    output reg carry,
    output reg overflow
);
    reg [8:0] temp_sum;

    always @(*) begin
        case(opCode)
            4'b0000: begin // ADD
                temp_sum = a + b; 
                result   = temp_sum[7:0];
                
                // Status
                carry    = temp_sum[8];
                zero     = (temp_sum[7:0] == 8'b0);
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end
            4'b0001: begin // SUB
                result   = a - b;
                
                // Status
                carry    = (a >= b);
                zero     = (result == 8'b0);
                overflow = (a[7] != b[7]) && (result[7] != a[7]);
            end
            4'b0011: begin // INC
                result = a + 8'b0000_0001;

                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b0010: begin // DEC
                result = a - 8'b0000_0001;

                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b0110: begin // NEG
                result = ~a + 1;

                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b0111: begin // NOT
                result   = ~a;
                
                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b0101: begin // AND
                result = a & b;

                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b1000: begin // OR
                result = a | b;
                
                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            4'b1100: begin // XOR
                result = a ^ b;

                // Status
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            default: begin 
                result = 8'b0;
                
                // Status
                carry = 1'b0;
                zero = 1'b1;
                overflow = 1'b0;
            end
        endcase
    end    
endmodule

// GT
    // LT
    // 1's COMP
    // 2'S COMP

    // case(opCode):
    //     4'b000: result = a & b; // AND 
    //     4'b001: result = a | b; // OR
    //     4'b010: result = a ^ b; // XOR
    //     4'b011: result = a + b; // ADD
    //     4'b100: result = a - b; // SUB
    //     4'b101: result = (a < b) ? 8'b1 : 8'b0 // SLT
    //     4'b101: result = (a == b) ? 8'b1 : 8'b0 // EQ
    // endcase