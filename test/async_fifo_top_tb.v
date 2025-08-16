//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: async_fifo_top_tb
// Description: Test Bench for Asynchronous FIFO read, write, empty and full condition checking
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps
module async_fifo_top_tb;

    localparam WIDTH = 8;
    localparam DEPTH = 32;

    reg  [WIDTH-1:0] wr_data;
    reg  wr_en, wr_clk, wr_rst_n;
    wire full;

    wire [WIDTH-1:0] rd_data;
    reg  rd_en, rd_clk, rd_rst_n;
    wire empty;
    wire [$clog2(DEPTH):0]ptr_w,ptr_r;
    integer i;
    integer seed = 1;

    // Instantiate DUT
    async_fifo_top #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .wr_data(wr_data),
        .wr_en(wr_en),
        .wr_clk(wr_clk),
        .wr_rst_n(wr_rst_n),
        .full(full),
        .rd_data(rd_data),
        .rd_en(rd_en),
        .rd_clk(rd_clk),
        .rd_rst_n(rd_rst_n),
        .empty(empty),
        .ptr_w(ptr_w),
        .ptr_r(ptr_r)
    );

    // Clock generation
    always #5  wr_clk = ~wr_clk;   // Write clock (100 MHz)
    always #15 rd_clk = ~rd_clk;   // Read clock (~33.33 MHz)

    initial begin
        // Init signals
        wr_clk = 0;
        rd_clk = 0;
        wr_rst_n = 0;
        rd_rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Reset pulse (both domains)
        #20;
        wr_rst_n = 1;
        rd_rst_n = 1;

        // Wait some cycles for reset release
        repeat (5) @(posedge wr_clk);
        repeat (5) @(posedge rd_clk);

        // Write data to FIFO
       for (i = 0; i <=DEPTH; i = i + 1) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en <= 1;
                wr_data <= $random(seed) & 8'hFF;
                $display("[%0t] WRITE: Data = %0h, wr_ptr = %0d, full = %b", $time, wr_data, ptr_w, full);
            end else begin
                wr_en <= 0;
                $display("[%0t] WRITE: FIFO FULL, wr_ptr = %0d", $time, ptr_w);
            end
        end
        wr_en <= 0; // stop writing

        // Wait for FIFO to fill and stabilize
        repeat (10) @(posedge wr_clk);

        // Read data from FIFO
        //rd_en=1;
        repeat (2) @(posedge rd_clk);
        for (i = 0; i <=DEPTH; i = i + 1) begin
            @(posedge rd_clk);
            if (!empty) begin
                rd_en <= 1;
                $display("[%0t] READ: Data = %0h, rd_ptr = %0d, empty = %b", $time, rd_data, ptr_r, empty);
            end else begin
                rd_en <= 0;
                $display("[%0t] READ: FIFO EMPTY, rd_ptr = %0d", $time, ptr_r);
            end
        end
        rd_en <= 0;

        // Wait some cycles before finishing*/
        repeat (50) @(posedge rd_clk);



        //------------Write and read one after another----------//

        for(i=0;i<=DEPTH;i=i+1)begin
            @(posedge wr_clk);
            rd_en<=1;
            if(!full)begin
                wr_en<=1;
                wr_data<=$random(seed) & 8'hFF;
            end else begin
                wr_en<=0;
            end
        end
        wr_en<=0;
        rd_en<=0;
       
        /////
        repeat(100)@(posedge rd_clk);
        repeat(100)@(posedge wr_clk);

        $finish;
    end

endmodule
