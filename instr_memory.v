
`timescale 1ns / 1ns


module instr_memory(

	input [23:0] Address,        
	output reg [23:0] Instruction
);

always @(Address)
	begin
	case(Address)
	// R-Type : Cond(2) Op(5) SF(1) Rd(3) Rs(3) Rt(3) Unused(7)
		0:  Instruction = 24'b00_00000_0_000_000_000_0000000;		// NOOP	   
		1:  Instruction = 24'b00_00000_0_001_010_011_0000000;       // AND R1(Rd), R2(Rs), R3(Rt)
		2:  Instruction = 24'b00_00001_0_001_010_011_0000000;	    // CAS R1(Rd) = MAX [R2(Rs), R3(Rt)]
		3:  Instruction = 24'b00_00010_0_001_010_011_0000000;	    // LWS R1(Rd), R2(Rs), R3(Rt)
		4:  Instruction = 24'b00_00011_1_001_010_011_0000000;	    // ADD R1(Rd), R2(Rs), R3(Rt)
		5:  Instruction = 24'b00_00100_0_001_010_011_0000000;	    // SUB R1(Rd), R2(Rs), R3(Rt)
		6:  Instruction = 24'b00_00101_0_001_010_011_0000000;	    // CMP R1(Rd), R2(Rs), R3(Rt) ---> ero-flag = Reg(Rs) < Reg(Rt)
		7:  Instruction = 24'b00_00110_0_001_010_011_0000000;	    // JR R1(Rd) = R2(Rs)
		
		// I-Type : Cond(2) Op(5) SF(1) Rt(3) Rs(3) Immidiate(10)
		8:  Instruction = 24'b00_00000_0_000_000_0000000000;		// NOOP	   
		9:  Instruction = 24'b00_00111_0_001_010_0110110111;        // ANDI R1(Rt), R2(Rs),01101101111
	    10:  Instruction = 24'b00_01000_0_001_010_1100011011;       // ADDI R1(Rt), R2(Rs),1100011011
	    11:  Instruction = 24'b00_01001_0_001_010_0001000111;       // Lw R1(Rt), R2(Rs),0001000111
	    12:  Instruction = 24'b00_01010_0_001_010_1111101110;	    // Sw R1(Rt), R2(Rs), 1111101110
	    13:  Instruction = 24'b01_01011_0_001_010_0000000000;	    // BEQ R1(Rt), R2(Rs), 0000000000
	 
		// J-Type : Cond(2) Op(5) Immidiate(17)			 
	    14:  Instruction = 24'b00_00000_00000000000000000;          //NOOP
	    15:  Instruction = 24'b00_01100_11101111100010001;          //PC = PC + 11101111100010001
	    16:  Instruction = 24'b00_01101_00010001111101000;          //PC = PC + 00010001111101000, R7 = PC+1
	    17:  Instruction = 24'b00_01110_10101011000010001;          //R1 = 10101011000010001 << 4

		default: Instruction = 0; // NOOP
	endcase
end

endmodule