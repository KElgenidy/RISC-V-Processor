`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 09:16:17 AM
// Design Name: 
// Module Name: nbitreg
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
* Module: nbitreg.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: nbit register
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module nbitreg #(parameter N = 8)(
input clk, input rst, input [N-1:0]D, input load, output  [N-1:0]Q
    );
    
wire [N-1 : 0]out;
 
 genvar i;
 generate 
 for(i=N-1 ; i>=0 ; i= i-1)
    begin 
            DFlipFlop  flip ( clk,rst, out[i],  Q[i]);
            mux m( Q[i], D[i] , load , out[i]);
       end
  endgenerate
endmodule
