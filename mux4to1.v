`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2022 04:29:18 PM
// Design Name: 
// Module Name: 3x1mux
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
* Module: mux4to1.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: 4 x 1 mux
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module mux4to1 #(parameter n = 32) (
input [n-1:0] a, b, c, d,
input [1:0] sel,
output [n-1:0] out
    );
    
    assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
endmodule
