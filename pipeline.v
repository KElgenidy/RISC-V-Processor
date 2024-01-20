`timescale 1ns / 1ps
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

/*******************************************************************
*
* Module: pipeline.v
* Project: RV32
* Author: Farah Kabesh , Karim el Genidy , Omar fayed
* Description: top module for the pipeline implementaion
*

**********************************************************************/
//0000000000-00000-00000-000-00000-0000000
module pipeline(
input clk,
//input SSDclk,
input rst
//input [1:0] ledsel,
//input [3:0] ssdSel,
//output reg [12:0] SDDout,
//output reg [15:0] ledout

);

wire [31:0] instmemout;
//mux output - instruction fetched & provided to IF/ID register
wire [31:0] instr_out; 

//Control
wire branch, memread,memtoreg, memwrite,alusrc,regwrite;
wire [1:0] new;
wire [1:0] aluop;
//mux output - control signals to be stored in ID/EX
wire [9:0] hazardout; 
//mux output - control signals to be stored in EX/MEM
wire [6:0] hazardout2; 


//RF
wire [31:0] writeData;
wire [31:0] writeData2;

wire [31:0] data1, data2;

//ImmGen
wire [31:0] immediate;

////Shift-BEQ
//wire [31:0] shifted;

//Mux-ALU
wire [31:0] aluInput;

//ALUOP sel
wire [4:0] alusel;

//ALU output
wire zeroflag, cf, vf, sf;
wire [31:0]ALUout;

//DataMem output
//wire [31:0] DMout;


//forwarding unit
wire [1:0] FA, FB;
wire [31:0] aluin1,aluin2;
  
 
 //PC 
wire[31:0] PCin;
wire [31:0] PCout;

wire [31:0] add1out;
reg [31:0] addition;
wire [31:0] add2out;
wire [31:0] newPC;
wire [1:0] PCsel;

//new
wire [31:0] MEMaddr;
wire sclk;

 //IF Stage

 clock_divider cd(
 clk,
 sclk
    );
  



  reg load;
  reg reset;
  wire [31:0] PCreset;
  initial begin
  load = 1'b1;
  reset = 1'b0;
  end
//ebreak I want the load to be zero
always @(*)
begin
if(instmemout == 32'b000000000001_00000_000_00000_1110011)  load = 1'b0;
else if(load == 1'b0 && instmemout !=  32'b000000000001_00000_000_00000_1110011) load = 1'b0;
else if (load == 1'b1 && instmemout != 32'b000000000001_00000_000_00000_1110011) load = 1'b1;
end

nbitreg #(32) PC(sclk, rst,  PCin,load, PCout);
assign PCin  = newPC;




//InstMEM inst(PCout2[7:2], instmemout);

//select the which will enter the memory, PC fetch the inst or Ex_MEM_ALU out
 mux #(32) PCMEM(EX_MEM_ALU_out, PCout, sclk, MEMaddr);
 //
newDM n2(sclk, EX_MEM_Ctrl[1], EX_MEM_Ctrl[0], MEMaddr, EX_MEM_RegR2, EX_MEM_Func, instmemout);

//add1out will be needed in case of jal and jalr so it will be taken to final stage of writeback in the register
rca #(32) add(PCout, 32'd4, 1'b0, add1out);

//branch hazard flush IF
//mux #(32) nop(instmemout, 32'd0, PCsel, instr_out); 
//mux #(32) nop(instmemout, 32'd0, PCsel, instr_out); 
assign  instr_out= instmemout;
//IF/ID Register
wire[31:0] IF_ID_ADD1out, IF_ID_PC, IF_ID_Inst;
    nbitreg #(96) IF_ID (~sclk,rst,{add1out, PCout, instr_out}  ,1'b1, {IF_ID_ADD1out, IF_ID_PC, IF_ID_Inst} );
//


//ID Stage 
//control unit is partially done except for the first four instruction and last three
controlUnit CU(IF_ID_Inst[6:0], branch, memread,memtoreg, memwrite,alusrc,regwrite, new, aluop);
Register_File #(32) RF(~sclk, rst, MEM_WB_Ctrl[3], IF_ID_Inst[19:15],IF_ID_Inst[24:20], MEM_WB_Rd, writeData2, data1, data2); 
rv32ImmGen immgen(IF_ID_Inst, immediate);

//  ID EX is the only is needed to be flushed
//branch hazard flush ID
//mux #(10) mhu({regwrite, memtoreg, new, branch, memread, memwrite, alusrc, aluop} , 10'd0, PCsel, hazardout);
//the 4th one will be used for ecall and efence
mux4to1 #(32) mhu( {regwrite, memtoreg, new, branch, memread, memwrite, alusrc, aluop},  10'd0,  10'd0,{regwrite, memtoreg, new, branch, memread, memwrite, alusrc, aluop}, PCsel, hazardout);
     
//ID_EX register
wire [31:0] ID_EX_ADD1out,ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
wire [9:0] ID_EX_Ctrl;
wire [4:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
wire [6:0] ID_EX_Opcode;
    
 nbitreg #(197) ID_EX ( sclk, rst,
 {
 hazardout, IF_ID_ADD1out, IF_ID_PC, data1, data2 , immediate, 
 {IF_ID_Inst[25], IF_ID_Inst[30], IF_ID_Inst[14:12]}, IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7], IF_ID_Inst[6:0]},
 
  1'b1,
 {ID_EX_Ctrl, ID_EX_ADD1out, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Func, ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_Opcode} );
//

//EX Stage
alucontrol alu(ID_EX_Func[2:0] , ID_EX_Func[3], ID_EX_Func[4], alusel, ID_EX_Ctrl[1:0]);

//forwarding
mux4to1 #(32) frwdA(ID_EX_RegR1, writeData2, EX_MEM_ALU_out , 32'b0, FA, aluin1);
mux4to1 #(32) frwdB(ID_EX_RegR2, writeData2, EX_MEM_ALU_out , 32'b0, FB, aluin2);

//mux #(32) m22(ID_EX_RegR2, ID_EX_Imm, ID_EX_Ctrl[2], aluInput);

mux #(32) aluMux(aluin2, ID_EX_Imm, ID_EX_Ctrl[2], aluInput);

//prv32_ALU ALU(ID_EX_RegR1, aluInput, ID_EX_Rs2, ALUout,cf, zeroflag, vf, sf,alusel);

prv32_ALU ALU(aluin1, aluInput, ID_EX_Opcode, ID_EX_Rs2, ALUout,cf, zeroflag, vf, sf,alusel);

rca #(32) add1(ID_EX_PC, ID_EX_Imm, 1'b0, add2out);

//branch hazard EX flush
//mux #(7) mflush2(ID_EX_Ctrl[9:3], 7'd0, PCsel, hazardout2); 

assign hazardout2 =  ID_EX_Ctrl[9:3];

//regwrite, memtoreg, new, branch, memread, memwrite, alusrc, aluop
//EX_MEM Register
//EX_MEM_BranchAddOut will be used for auipc also
//EX_MEM_ADD1out will be used for JAL/JALR
//EX_MEM_ALU
    wire [31:0] EX_MEM_ADD1out, EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [6:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [2:0] EX_MEM_Func; //assigned to it the first the 3 bits
    wire EX_MEM_Zero, EX_MEM_CF, EX_MEM_VF, EX_MEM_SF;
    
     nbitreg #(147) EX_MEM ( ~sclk, rst,
     {hazardout2,ID_EX_ADD1out, add2out, zeroflag, cf, vf, sf, ALUout, aluin2 ,ID_EX_Rd, ID_EX_Func[2:0]} ,1'b1,
     
     {EX_MEM_Ctrl, EX_MEM_ADD1out, EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_CF, EX_MEM_VF, EX_MEM_SF, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_Func} );

//

//MEM Stage
//regwrite, memtoreg, new, branch, memread, memwrite
branch b(EX_MEM_Ctrl[2], EX_MEM_CF, EX_MEM_Zero, EX_MEM_VF, EX_MEM_SF, EX_MEM_Ctrl[4:3], PCsel); 

mux4to1 #(32) m3(add1out, EX_MEM_BranchAddOut, EX_MEM_ALU_out, 32'b0, PCsel, newPC);

  
 //MEMWB Register
wire [31:0] MEM_WB_ADD1out, MEM_WB_BranchAddOut, MEM_WB_Mem_out, MEM_WB_ALU_out;
wire [3:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;


 nbitreg #(137) MEM_WB (sclk,rst,
 {EX_MEM_Ctrl[6:3],instmemout, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_BranchAddOut, EX_MEM_ADD1out },
 
 1'b1, 
 
 {MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd, MEM_WB_BranchAddOut, MEM_WB_ADD1out  } );
//

 //regwrite, memtoreg, new
 
 //WB Stage
 mux #(32) m2(MEM_WB_ALU_out, MEM_WB_Mem_out, MEM_WB_Ctrl[2], writeData);
 mux4to1 #(32) m4(MEM_WB_BranchAddOut, MEM_WB_ADD1out, writeData , 32'bXX, MEM_WB_Ctrl[1:0], writeData2);
  
forwardingUnit fu(ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Ctrl[6], MEM_WB_Ctrl[3], FA, FB); 


// always @(*) begin
// case(ledsel) 
//    2'b00 : ledout = instmemout[15:0];
//    2'b01 : ledout = instmemout[31:16];
//   2'b10 : ledout = {2'b0 , aluop, alusel,zeroflag , branch & zeroflag};
//    default: ledout = 16'd0;
//    endcase
  
// case(ssdSel) 
//    4'b0000 : SDDout = PCout2[12:0];
//    4'b0001 : SDDout = add1out[12:0];
//     4'b0010 : SDDout = add2out[12:0];
//      4'b0011 : SDDout = PCin[12:0];
//     4'b0100 : SDDout = data1[12:0];
//      4'b0101 : SDDout = data2[12:0];
//       4'b0110 : SDDout = writeData[12:0];
//        4'b0111 : SDDout = immediate[12:0];
  
        
//    default: SDDout = 13'd0;
// endcase
 //end
 


endmodule
