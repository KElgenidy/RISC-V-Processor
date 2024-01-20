`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2022 12:50:12 PM
// Design Name: 
// Module Name: RCA
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
* Module: adder.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: nbit adder
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module rca #(parameter n = 8) (
input [n-1:0] A,
input [n-1:0] B,
input cin,
output [n-1:0] C
);

assign C =  A + B + cin;

endmodule
