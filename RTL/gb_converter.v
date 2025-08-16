//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: gb_converter
// Description: Convert pointer value(Gray code format)  to Binary Format.. 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module gb_converter #(parameter WIDTH=6)(
    input [WIDTH-1:0]gray,
    output reg[WIDTH-1:0]binary
    );
    
    integer i;
    //procedural block
    always@(*)begin
        binary[WIDTH-1]=gray[WIDTH-1];
        for(i=WIDTH-2;i>=0;i=i-1)begin
            binary[i]=binary[i+1]^gray[i];
        end
    end
    
    //another style -- assign statement can be used   
endmodule
