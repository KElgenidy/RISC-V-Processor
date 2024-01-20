`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 10:22:30 AM
// Design Name: 
// Module Name: TOP
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
* Module: TOP.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: This is the top module for the fpga
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module TOP(
input clk,
input rst,
input [1:0] ledsel,
input [3:0] ssdSel,
input SSDclk,
output [15:0] ledout,

output [3:0] Anode,
output [6:0] LED_out
    );
    wire [12:0] SDDout;
pipeline  pi( clk,
 SSDclk,
 rst,
ledsel,
  ssdSel,
SDDout,
ledout);
    
   FSDD S(
    SSDclk,
 SDDout,
  Anode,
  LED_out
 );
endmodule
