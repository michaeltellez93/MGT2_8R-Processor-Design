module status_logic(
    input [7:0] a,
    input [7:0] b,
    input [2:0] opCode,
    input reg [7:0] result,
    output reg zero,
    output reg carry,
    output reg overflow
);
    always @(*) begin
        case(opCode)
            3'b000: begin // ADD
                carry = temp_sum[8];
                zero = (temp_sum[7:0] == 8'b0);
                overflow = (~a[7] & ~b[7] & result[7]) | (a[7] & b[7] & ~result[7]);
            end
            3'b001: begin // SUB
                carry    = (a >= b);
                zero     = (result == 8'b0);
                overflow = (a[7] != b[7]) && (result[7] != a[7]);
            end
            3'b010: begin // INC
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            3'b011: begin // DEC
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            3'b100: begin // NEG
                carry    = 8'b0;
                zero     = 8'b0;
                overflow = 8'b0;
            end
            default: begin 
                // Status
                carry = 1'b0;
                zero = 1'b1;
                overflow = 1'b0;
            end
        endcase
    end
endmodule