module register_file (
    input        clk,
    input        n_reset,
    input        n_w,
    input  [3:0] rs,
    input  [3:0] rt,
    input  [3:0] rd,
    input  [7:0] data_in,
    output [7:0] rs_data_out,
    output [7:0] rt_data_out
);
    reg [7:0] registers[15:0];

    assign rs_data_out = registers[rs];
    assign rt_data_out = registers[rt];

    always @(posedge clk) begin
        if (!n_reset)
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 8'b0;
            end 
        else if (!n_w)
            registers[rd] <= data_in;
    
        registers[0] <= 8'b0;
    end
    
endmodule