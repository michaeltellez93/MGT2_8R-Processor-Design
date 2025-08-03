module soc_top();
    reg          clk;
    wire [255:0] pc;
    wire         n_mem_rw;
    wire         n_mem_cs;
    wire         n_mem_oe;
    wire [7:0]   mem_addr;
    wire [7:0]   mem_data;
    wire [15:0]  instruction;

    single_port_sync_ram ram(
        .clk(clk),
        .n_rw(n_mem_rw),
        .n_cs(n_mem_cs),
        .n_oe(n_mem_oe),
        .addr(mem_addr),
        .data(mem_data)
    );

    MGT2_8R processor(
        .clk(clk),
        .instruction(instruction),
        .mem_data(mem_data),
        .n_mem_rw(n_mem_rw),
        .n_mem_cs(n_mem_cs),
        .n_mem_oe(n_mem_oe),
        .mem_addr(mem_addr),
        .pc(pc)
    );
    instruction_memory rom(
        .addr(pc),
        .instruction(instruction)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 10ns clock period
    end

endmodule