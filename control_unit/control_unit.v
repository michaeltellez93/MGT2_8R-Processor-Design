module control_unit(
    input [3:0] opCode,
    output reg n_reg_w,
    output reg n_mem_rw,
    output reg n_mem_cs,
    output reg n_mem_oe
);
    localparam OP_LD   = 4'b0000;
    localparam OP_LDI  = 4'b0001;
    localparam OP_ST   = 4'b0011;
    localparam OP_ADD  = 4'b0010;
    localparam OP_SUB  = 4'b0110;
    localparam OP_AND  = 4'b0111;
    localparam OP_OR   = 4'b0101;
    localparam OP_XOR  = 4'b0100;
    localparam OP_NOT  = 4'b1100;
    localparam OP_SLL  = 4'b1101;
    localparam OP_SRL  = 4'b1111;
    localparam OP_SRA  = 4'b1110;
    localparam OP_BEQ  = 4'b1010;
    localparam OP_BNE  = 4'b1011;
    localparam OP_JMP  = 4'b1001;
    localparam OP_JAL  = 4'b1000;

    always @(*) begin
        n_reg_w  = 1'b1;
        n_mem_rw = 1'b1;
        n_mem_cs = 1'b1;
        n_mem_oe = 1'b1;

        case(opCode)
            OP_LD: begin // LD
                n_mem_cs = 1'b0;
                n_mem_oe = 1'b0;
                n_mem_rw = 1'b0;
                n_reg_w  = 1'b0;
            end
            OP_LDI: begin // LDI
                n_reg_w = 1'b0;
            end
            OP_ST: begin // ST
                n_mem_cs = 1'b0;
                n_mem_rw = 1'b1;
            end
            OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, 
            OP_NOT, OP_SLL, OP_SRL, OP_SRA: begin
                n_reg_w = 1'b0;
            end
            OP_BEQ, OP_BNE, OP_JMP: begin // BEQ, BNE, JMP
                // Only update PC, no reg writes
            end
            OP_JAL: begin // JAL
                n_reg_w = 1'b0;
            end
            default: ;
        endcase
    end
endmodule