`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 08:49:19 AM
// Design Name: 
// Module Name: Register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

/*******************************************************************
*
* Module: DFlipFlop.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: d flip flop
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////
module DFlipFlop 
 (input clk, input rst, input D, output reg Q);
 

 always @ (posedge clk or posedge rst)
 if (rst) begin
 Q <= 1'b0;
 end else begin
 Q <= D;
 end
 
 
endmodule 



