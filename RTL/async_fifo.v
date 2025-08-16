//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: async_fifo_top
// Project Name: Asynchronous FIFO
// Description : 8 bit wide and 32 deep asynchronous fifo.. This a parameterized design
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module async_fifo_top #(parameter WIDTH=8,DEPTH=32)(
    //write 
    input [WIDTH-1:0] wr_data,
    input wr_en,wr_clk,wr_rst_n,
    output full,
    
    output [WIDTH-1:0]rd_data,
    input rd_en,rd_clk,rd_rst_n,
    output empty, 
    output reg [$clog2(DEPTH):0]ptr_w, ptr_r
    );
    
    localparam pointer=$clog2(DEPTH);
    
    wire [pointer:0]rd_ptr_wclk_gb,wr_ptr_rclk_gb;
    
    wire [pointer:0]wr_ptr_gray, rd_ptr_gray;
    
    wire [pointer:0] ff2_w, ff2_r,rd_ptr,wr_ptr ;
    //module instantiation
    
    
    wrptr_full write(.wr_clk(wr_clk),.wr_rst_n(wr_rst_n),.wr_en(wr_en),.rd_ptr_wclk(rd_ptr_wclk_gb),.full(full),.wr_ptr(wr_ptr));
    
    rdptr_empty read(.rd_clk(rd_clk),.rd_rst_n(rd_rst_n),.rd_en(rd_en),.wr_ptr_clk(wr_ptr_rclk_gb),.rd_ptr(rd_ptr),.empty(empty));
    
    fifo_mem mem(.wr_clk(wr_clk),.rd_clk(rd_clk),.wr_en(wr_en),.rd_en(rd_en),.full(full),.empty(empty),.wr_ptr(wr_ptr),
                .rd_ptr(rd_ptr),.wr_data(wr_data),.rd_data(rd_data));
    
    //To see pointer value in output waveform use ptr_w and ptr_r pin
    always@(*)begin
        ptr_w=wr_ptr;
        ptr_r=rd_ptr;
    end
    
    //binary to gray in write side
    bg_converter bgw (.binary(wr_ptr),.gray(wr_ptr_gray));
    
    //binary to gray converter in read side
    bg_converter bgr (.binary(rd_ptr),.gray(rd_ptr_gray));
    
    //gray to binary converter in write side
    gb_converter gbw (.gray(ff2_w),.binary(rd_ptr_wclk_gb));
    
    //gray to binary converter in read side
    gb_converter gbr (.gray(ff2_r),.binary(wr_ptr_rclk_gb));
    
    //ff2 synchronizer write side
    ff2_sync ff2_wside (.clk(wr_clk),.rst_n(wr_rst_n),.din(rd_ptr_gray),.q(ff2_w));
    
    //ff2 synchronizer read side
    ff2_sync ff2_rside (.clk(rd_clk),.rst_n(rd_rst_n),.din(wr_ptr_gray),.q(ff2_r));
    
endmodule
