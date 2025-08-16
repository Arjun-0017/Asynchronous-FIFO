//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: ff2_sync
// Description: Two staged Flip Flop Synchronizer
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps
module ff2_sync #(parameter WIDTH=6)(
    input clk,rst_n,
    input [WIDTH-1:0]din,
    output reg[WIDTH-1:0]q
);
    //internal reg -- FF
    reg [WIDTH-1:0]qin;
    
    always@(posedge clk or negedge rst_n)begin
    
        if(!rst_n)
            q<=0;
        else begin
            qin<=din;
            q<=qin;
        end
    end

endmodule
