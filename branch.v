`timescale 1ns / 1ps
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module branch(
input  wire branch, 
input wire cf,
input wire zeroflag, 
input wire vf, 
input wire sf,
input [1:0] new,
output reg [1:0] PCsel
    );
    
    always@(*)
    begin
    //beq
    if(zeroflag == 0 && branch == 1) PCsel = 2'b01;
    //bne
    else if(zeroflag != 0 && branch == 1) PCsel = 2'b01;
    //blt
    else if(sf != vf && branch == 1) PCsel = 2'b01;
    //bge
    else if(sf == vf && branch == 1) PCsel = 2'b01; 
   
    //bltu
    else if(cf == 0 && branch == 1) PCsel = 2'b01;
    //bgeu
    else if(cf == 1 && branch == 1) PCsel = 2'b01;
    //jal and auipc
    else if(new == 2'b01 && branch == 1) PCsel = 2'b01;
    //jalr
    else if(new == 2'b01 && branch == 0) PCsel = 2'b10;
    
   else if(new == 2'b11 && branch == 1) PCsel = 2'b11;
    
    else PCsel = 2'b00;
    end
 
endmodule

