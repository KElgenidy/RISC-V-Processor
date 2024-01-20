`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 09:56:53 AM
// Design Name: 
// Module Name: Register_File
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
//////////////////////////////////////////////////////////////////////////////////


module Register_File #(parameter n = 32)(
input clk,
input  rst,
input  regWrite,
input [4:0] rs1,
input [4:0] rs2,
input   [4:0] rd,
input [n-1:0] writeData,
output [n-1:0] data1,
output [n-1:0] data2
);

//wire [n-1:0] D [31:0];
wire [n-1:0] Q [31:0];
reg [n-1:0] load;
wire index;


always@(*) begin
load = 32'd0;
if(rd==0)begin
load[rd] = 0;
end
else
begin
 load[rd] = regWrite;
end
end

//write data
genvar i;
generate
for (i=0;i<32;i=i+1)begin
 nbitreg #(n) register2(clk, rst, writeData, load[i], Q[i]);
 end
 endgenerate
//read
assign data1 = Q[rs1];
assign data2 = Q[rs2];
   
endmodule
