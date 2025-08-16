//////////////////////////////////////////////////////////////////////////////////
// Design Name: Asynchronous FIFO
// Module Name: bg_converter
// Description: Convert pointer value(Binary code format)  to Gray Code Format.. 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps
module bg_converter #(parameter WIDTH=6)(
    input [WIDTH-1:0]binary,
    output reg [WIDTH-1:0]gray
    
);

    //procedural block
    always@(*)begin
    
        gray[WIDTH-1]=binary[WIDTH-1];
        gray[WIDTH-2:0]=binary[WIDTH-1:1]^binary[WIDTH-2:0];
    end
    
    //another style-- use assign statement
endmodule
