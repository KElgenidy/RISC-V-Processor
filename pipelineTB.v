`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2022 10:41:41 AM
// Design Name: 
// Module Name: pipelineTB
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
* Module: pipelineTB.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: Test bench for the top module pipeline.v
*

**********************************************************************/
//////////////////////////////////////////////////////////////////////////////////


module pipelineTB(
    );
    
    reg clk;
    reg rst;
 pipeline imp(
 clk,
 rst
);

initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin

rst = 1'b1;
#15
rst = 1'b0;
#5000
$finish;
end

endmodule

