`timescale 1ns / 1ns
`include "control.v"
`include "DMem.v"
`include "Instruction_register.v"
`include "mux2_3.v"
`include "mux2.v"
`include "mux3_3.v"
`include "mux3.v"
`include "mux4.v"
`include "alu_control.v"
`include "reg_pc.v"
`include "instr_memory.v"
`include "signextender.v"
`include "zeroextender.v"
`include "regFile.v"
`include "second_block.v"
`include "ALU.v"
`include "shiftleft17.v"
`include "ALUOut_register.v"
`include "MemoryData_register.v"
`include "first_block.v"
`include "mux2_2.v"

module CPU(
input clk, rst,
output [23:0] pc_out, ALU_OUT
);
 

reg [23:0] Zero_constant = 23'd0, One_constant = 23'd1;

// Datapath connections
wire        pc_on, Zero, not_Zero, And_to_Or_wire, Zero_mux_out, PCWriteCond, PCWrite,
	         MemWrite, MemtoReg, IRWrite, RegWrite, RegSelect1 ,sf_1;
wire [1:0]  RegSelect2, ALUSrcA, ALUSrcB, PCSource, ALUOp;
wire [3:0]  ALUSelect;
wire [2:0]  r1, r2, r3, MuxtoReadReg1, MuxtoReadReg2;
wire [4:0]  opc; 
wire [16:0] Truncate_to_IMem, immediate, DMem_Address_Truncated;
wire [23:0] Instruction_to_IR, Read_data_to_A, Read_data_to_B,   // pc_out goes to A_mux and Concat box also
				A_to_MuxA, B_to_MuxB, SE_Immediate, ZE_Immediate,
				MuxA_to_ALU, MuxB_to_ALU, ALUResult_to_ALUReg,
				JumpAddress_wire, Final_mux_to_pc_in, ALU_Final_Result,
				MemData_wire, MemDataReg_out, mux_to_Reg_WriteData;


assign And_to_Or_wire = PCWriteCond && Zero;
assign pc_on = PCWrite || And_to_Or_wire;
assign ALU_OUT = ALU_Final_Result;



control
Main_Control_State_Machine
(
	.opcode(opc),
	.clock(clk),
	.reset(rst),
	.PCWriteCond(PCWriteCond),
	.PCWrite(PCWrite),
	.MemWrite(MemWrite),
	.MemtoReg(MemtoReg),
	.IRWrite(IRWrite),
	.RegWrite(RegWrite),
	.RegSelect1(RegSelect1),
	.PCSource(PCSource),
	.ALUOp(ALUOp),   
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.RegSelect2(RegSelect2)
);

alu_control
ALU_State_Machine
(
	.opcode(opc),
	.ALUOp(ALUOp),
	.aluSel(ALUSelect)
);


reg_pc
Program_Counter
(
	.clock(clk),
	.reset(rst),
	.PC_on(pc_on),
	.PC_in(Final_mux_to_pc_in),
	.PC_out(pc_out)
);

instr_memory
Instruction_Memory
(
	.Address(pc_out),
	.Instruction(Instruction_to_IR)
);

wire [9:0] Iim_1;
wire  [6:0] unused_1;
wire  [16:0] jim_1;
wire [1:0] cond_1;


Instruction_register
IR
(
	.clock(clk),
	.IRWrite(IRWrite),
	.Instr_in(Instruction_to_IR),
	.opcode(opc),
	.cond(cond_1),
	.rd(r1), 
	.rs(r2), 
	.rt(r3), 
	.Iimm(Iim_1),
    .Jimm(jim_1),
	.sf(sf_1),
	.unused(unused_1)
);

mux2_3
ReadReg1Mux
(
	.sel(RegSelect1),
	.a(r1),
	.b(r2),
	.y(MuxtoReadReg1)
);

mux3_3

ReadReg2Mux
(
	.sel(RegSelect2),
	.in0(r2),
	.in1(r3),
	.in2(r1),
	.out(MuxtoReadReg2)
);

signextender
Sign_Extend_Immediate
(
	.in(jim_1),
	.out(SE_Immediate)
);

zeroextender
Zero_Extend_Immediate
(
	.in(jim_1),
	.out(ZE_Immediate)
);

regFile
Registers
(
	.clk(clk),
	.RegWrite(RegWrite),
	.read_sel_1(MuxtoReadReg1),
	.read_sel_2(MuxtoReadReg2),
	.read_data_1(Read_data_to_A),
	.read_data_2(Read_data_to_B),
	.write_address(r1),
	.write_data(mux_to_Reg_WriteData)
);

first_block
A
(
	.clock(clk),
	.a_in(Read_data_to_A),
	.a_out(A_to_MuxA)
);

second_block
B
(
	.clock(clk),
	.b_in(Read_data_to_B),
	.b_out(B_to_MuxB)
);

mux3
Mux_to_ALU_A
(
	.sel(ALUSrcA),
	.in0(pc_out),
	.in1(A_to_MuxA),
	.in2(Zero_constant),
	.out(MuxA_to_ALU)
);

mux4
Mux_to_ALU_B
(
	.sel(ALUSrcB),
	.in0(B_to_MuxB),
	.in1(One_constant),
	.in2(SE_Immediate),
	.in3(ZE_Immediate),
	.out(MuxB_to_ALU)
);

ALU
alu_result_and_zero
(
	.aluSel(ALUSelect),
	.a(MuxA_to_ALU),
	.b(MuxB_to_ALU),
	.result(ALUResult_to_ALUReg),
	.cond(cond_1),
	.SF(SF_1),
	.zero(Zero)
);

ALUOut_register
ALU_Output_Register
(
	.clock(clk),
	.ALUOut_in(ALUResult_to_ALUReg),
	.ALUOut_out(ALU_Final_Result)
);

// mux2_2
// Zero_Mux
// (
// 	.sel(Instr26),
// 	.a(Zero),
// 	.b(not_Zero),
// 	.y(Zero_mux_out)
// );

shiftleft17
concat_PC31to28_00_Instr25to0
(
	.PC(pc_out[23:20]),
	.R1(r1),
	.R2(r2),
	.Immediate(jim_1),
	.JumpAddress_out(JumpAddress_wire)
);

mux3
Mux_to_PC_in
(
	.sel(PCSource),
	.in0(ALUResult_to_ALUReg),
	.in1(ALU_Final_Result),
	.in2(JumpAddress_wire),
	.out(Final_mux_to_pc_in)
);


DMem
Data_Memory
(
	.WriteData(B_to_MuxB),
	.MemData(MemData_wire),
	.Address(ALU_Final_Result),
	.MemWrite(MemWrite),
	.Clk(clk)
);

MemoryData_register
Datfirst_block
(
	.clock(clk),
	.data_in(MemData_wire),
	.data_out(MemDataReg_out)
);

mux2
DMemReg_to_WriteData_mux
(	
	.sel(MemtoReg),
	.a(ALU_Final_Result),
	.b(MemDataReg_out),
	.y(mux_to_Reg_WriteData)
);




endmodule