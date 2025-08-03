module single_port_sync_ram(
    input clk,
    input n_rw,
    input n_cs,
    input n_oe,
    input [7:0] addr,
    inout [7:0] data
);
    reg [7:0] mem [255:0];
    reg [7:0] data_out;

    always @(posedge clk) begin : READ
        if (!n_cs & !n_rw)
            data_out <= mem[addr];
    end

    always @(posedge clk) begin : WRITE
        if (!n_cs & n_rw )
            mem[addr] <= data;
    end
    
    assign data = (!n_cs & !n_oe & !n_rw) ? data_out : 8'bz;

endmodule