`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 10:24:54 AM
// Design Name: 
// Module Name: controlUnit
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
* Module: controlUnit.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: control unit
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


//module controlUnit(
//input [4:0]inst,
//output reg branch,memread,memtoreg, memwrite,alusrc,regwrite,
//output reg [1:0] aluop
//    );
    
//  //add the immediate control signals
// always @(*)
// begin
// case (inst)
// 5'b01100:begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b10 ; memwrite = 0; alusrc = 0; regwrite=1; end
// 5'b00000: begin branch = 1'b0 ; memread = 1'b1; memtoreg = 1'b1 ; aluop = 2'b00 ; memwrite = 0; alusrc = 1; regwrite=1; end
// 5'b01000: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00 ; memwrite = 1; alusrc = 1; regwrite=0; end
// 5'b11000: begin branch = 1'b1 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b01 ; memwrite = 0; alusrc = 0; regwrite=0; end
// default: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00 ; memwrite = 0; alusrc = 0; regwrite=0; end
// endcase
// end
//endmodule

module controlUnit(
input [6:0]inst,
output reg branch,memread,memtoreg, memwrite,alusrc,regwrite,
//new mux
output reg  [1:0]new,
output reg [1:0] aluop
    );
    
  //add the immediate control signals
  //00 01 10 11
 always @(*)
 begin
 case (inst)
 // R-FORMAT
 7'b0110011:begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b10 ; memwrite = 0; alusrc = 0; regwrite=1; new = 2'b10; end
//Loads
 7'b0000011: begin branch = 1'b0 ; memread = 1'b1; memtoreg = 1'b1 ; aluop = 2'b00 ; memwrite = 0; alusrc = 1; regwrite=1; new = 2'b10; end
//Store
 7'b0100011: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00 ; memwrite = 1; alusrc = 1; regwrite=0;  new = 2'bXX; end
 //Branch
 7'b1100011: begin branch = 1'b1 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b01 ; memwrite = 0; alusrc = 0; regwrite=0;  new = 2'bXX;end
 //Immediates
 7'b0010011: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b11 ; memwrite = 0; alusrc = 1; regwrite=1;  new = 2'b10;end
 //LUI - work on alu control
 7'b0110111: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'bXX ; memwrite = 0; alusrc = 1; regwrite=1;  new = 2'b10;end
 //AUIPC
 7'b0010111: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'bXX ; memwrite = 0; alusrc = 1; regwrite=1;  new = 2'b00;end
 //JAL
 7'b1101111: begin branch = 1'b1 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'bXX ; memwrite = 0; alusrc = 1; regwrite=1;  new = 2'b01;end
 //JALR
  7'b1100111: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00; memwrite = 0; alusrc = 1; regwrite=1;  new = 2'b01;end
 //ECALL EBREAK
  7'b1110011: begin branch = 1'b1 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00; memwrite = 0; alusrc = 1; regwrite=0;  new = 2'b11;end
//FENCE
  7'b0001111: begin branch = 1'b1 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00; memwrite = 0; alusrc = 1; regwrite=0;  new = 2'b11;end

//RV32IM Set
  7'b0110011: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b10; memwrite = 0; alusrc = 0; regwrite=1;  new = 2'b10;end
  
 //NO CASE
 default: begin branch = 1'b0 ; memread = 1'b0; memtoreg = 1'b0 ; aluop = 2'b00 ; memwrite = 0; alusrc = 0; regwrite=0; end
 
 endcase
 end
endmodule