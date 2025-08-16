//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: wrptr_full
// Description: Code for write pointer (wr_ptr) increment and full condition checking
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps
module wrptr_full #(parameter DEPTH=32)(
    input wr_clk,wr_rst_n,wr_en,
    input [$clog2(DEPTH):0]rd_ptr_wclk,
    
    output reg full,
    output reg [$clog2(DEPTH):0]wr_ptr
    
);

    localparam addr_depth=$clog2(DEPTH);
    
    wire[addr_depth:0]wr_ptr_int;
    wire wr_full;
    
    //procedural block - for full, wr_ptr 
    always@(posedge wr_clk or negedge wr_rst_n)begin
    
        if(!wr_rst_n)begin
            full<=0;
            wr_ptr<=0;
        end
            
        else begin
            full<=wr_full;
            wr_ptr<=wr_ptr_int;
        end
    end
    
    assign wr_ptr_int=wr_ptr + (wr_en & ~full); 
    
    //full logic
    assign wr_full=(wr_ptr[addr_depth-1:0]==rd_ptr_wclk[addr_depth-1:0]) && (wr_ptr[addr_depth]!=rd_ptr_wclk[addr_depth]);
    
endmodule
