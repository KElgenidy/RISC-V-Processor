`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2022 09:08:18 AM
// Design Name: 
// Module Name: forwardingUnit
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
* Module: forwardingUnit.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: forwarding unit
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module forwardingUnit(
input [4:0] ID_EX_RegisterRs1,
input [4:0]ID_EX_RegisterRs2,
input [4:0]EX_MEM_RegisterRd,
input [4:0]MEM_WB_RegisterRd,
input EX_MEM_RegWrite, 
input MEM_WB_RegWrite,
output reg [1:0] FA, FB
    );
    
    
always @(*) begin
  if ( EX_MEM_RegWrite == 1'b1 && (EX_MEM_RegisterRd != 0)&& (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) FA = 2'b10;


else if ( MEM_WB_RegWrite  == 1'b1 && (MEM_WB_RegisterRd != 0)
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs1) &&  !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) )
FA = 2'b01;

else FA = 2'b00;
 end



 always @(*) begin 
  if ( EX_MEM_RegWrite  == 1'b1 && (EX_MEM_RegisterRd != 0)&& (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) FB = 2'b10;
  else if ( MEM_WB_RegWrite == 1'b1  && (MEM_WB_RegisterRd != 0)
&& (MEM_WB_RegisterRd == ID_EX_RegisterRs2) &&  !(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) )
FB = 2'b01;

else FB = 2'b00;
  end
endmodule
