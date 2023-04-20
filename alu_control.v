`timescale 1ns / 1ns
module alu_control(opcode, ALUOp, aluSel);
	input [4:0] opcode; //5 bit 
	input [1:0] ALUOp;
	output reg[3:0] aluSel; //reg 

always @(opcode, ALUOp)
begin
	case(ALUOp)
		2'd0: aluSel <= 3; //  lw, sw  -->ADD
		2'd1: aluSel <= 4; //  branch --> SUB 
		2'd2: 
			begin
				case(opcode)
				5'bxxxxx: aluSel <= 0;  // NOOP
				5'b00000: aluSel <= 1;  // AND //R
				5'b00001: aluSel <= 2;  // CAS //R //sub
				5'b00010: aluSel <= 3;  // LWS //R //ADD
				5'b00011: aluSel <= 3;  // ADD //R
				5'b00100: aluSel <= 4;  // SUB //R
				5'b00101: aluSel <= 5;  // CMP //R
				//5'b00110: aluSel <= 2;  // JR /R
				5'b00111: aluSel <= 1;  // ANDI
				5'b01000: aluSel <= 3;  // ADDI
				5'b01001: aluSel <= 3;  // LW
				5'b01011: aluSel <= 3;  // SW
				5'b01011: aluSel <= 4;  // BEQ
				5'b01110: aluSel <= 6;  // LUI
				default:   aluSel <= 0;  // shouldn't get used			
				endcase
			end
	endcase
end
endmodule
