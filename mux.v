`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 09:04:00 AM
// Design Name: 
// Module Name: mux
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
* Module: mux.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: 2 x 1 mux
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module mux #(parameter n = 8)(
input [n-1:0] A,
input[n-1:0] B,
input s,
output[n-1:0] C
    );
    
 assign C = s? B:A;
endmodule
