//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: rdptr_empty
// Description: Code for read pointer (rd_ptr) increment and empty condition checking
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps
module rdptr_empty #(parameter DEPTH=32)(
    input rd_clk,rd_rst_n,rd_en,
    input [$clog2(DEPTH):0]wr_ptr_clk,
    
    output  reg [$clog2(DEPTH):0]rd_ptr,
    output reg empty    
);

    localparam addr_depth=$clog2(DEPTH);
    
    
    wire [addr_depth:0]rd_ptr_int;  //internal pointer register
    wire rd_empty;    //internal empty flag
    
    assign rd_ptr_int = rd_ptr + (rd_en & ~ empty);
    
    assign rd_empty = (wr_ptr_clk==rd_ptr);
    
    
    //procedural block
    always@(posedge rd_clk or negedge rd_rst_n)begin
        if(!rd_rst_n)begin
            empty<=1'b1;
            rd_ptr<=0;
        end
        else begin
            empty<=rd_empty;
            rd_ptr<=rd_ptr_int;
        end
    end
    
endmodule
