//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: fifo_mem
// Description: Parameterized Dual Port FIFO memory
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module fifo_mem #(parameter WIDTH=8, DEPTH=32) (
    input wr_clk,wr_en,rd_en,full,empty,rd_clk,
    input [$clog2(DEPTH):0]wr_ptr,rd_ptr,
    input [WIDTH-1:0]wr_data,
    output reg [WIDTH-1:0]rd_data
    );
    
    //address
    wire [$clog2(DEPTH)-1:0]wr_addr, rd_addr;
    
    //ebable 
    wire wr_en_mem,rd_en_mem;
    
    //assigning address 
    assign wr_addr=wr_ptr[$clog2(DEPTH)-1:0];
    assign rd_addr=rd_ptr[$clog2(DEPTH)-1:0];
    
    //enable logic
    assign wr_en_mem=(wr_en)&(~full);
    assign rd_en_mem=(rd_en)&(~empty);
    
    //FIFO memory
    reg [WIDTH-1:0]mem[0:DEPTH-1];
    
    //accessing the data stored in fifo memory 
    
    //assign rd_data=mem[rd_addr]; --- this type of asynchronus construct is used in sunburst paper-2 for simulation and explanation..
    //But here I've used synchronous construct for read and write both 
    
    //writing in the fifo memory
    always@(posedge wr_clk)begin
        if(wr_en_mem==1'b1)begin
            mem[wr_addr]<=wr_data;
        end
    end
    
    
    //reading from the memory
    always@(posedge rd_clk)begin
        if(rd_en_mem==1'b1)begin
            rd_data<=mem[rd_addr];
        end
    end
    
    //Also asynchronus read can be modeled..
    //assign rd_data=mem[rd_addr];
endmodule


