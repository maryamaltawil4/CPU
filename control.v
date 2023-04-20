`timescale 1ns / 1ns


module control(opcode, clock, reset, PCWriteCond, PCWrite, MemWrite, MemtoReg, IRWrite,
			  PCSource, ALUOp, ALUSrcA, ALUSrcB, RegWrite, RegSelect1, RegSelect2);
	//??instr--size
	input [4:0] opcode;
	input clock, reset;

    //one bit 
	output reg PCWriteCond, PCWrite, MemWrite, MemtoReg, IRWrite, RegWrite,
				   RegSelect1;
    //two bit 
	output reg [1:0] PCSource, ALUOp, ALUSrcA, ALUSrcB, RegSelect2;
	
	reg [4:0] state;
	reg [4:0] next_state;
		
	// Opcode reference
	parameter    NOOP = 5'bxxxxx , AND = 5'b00000,
	             CAS = 5'b00001 , LWS = 5'b00010,
	             ADD = 5'b00011 , SUB = 5'b00100,
				 CMP = 5'b00101 , JR= 5'b00110,
				 ANDI = 5'b00111, ADDI = 5'b01000, 
				 SW = 5'b01010, LW = 5'b01001,
				 BEQ = 5'b01011,J = 5'b01100,
				 JAL = 5'b01101, 
				 SWI = 6'b111100,
				 LUI = 5'b01110 ;
	
	// Initialize states
	initial
	begin
		state <= 5'd0;
		next_state <= 5'd0;
	end
	
	// State -> next_state
	always @(posedge clock)
		state <= next_state;
	
	// Output assignments
	always @(state)
	begin
		case(state)

		    //fetch
			5'd0:  begin ALUSrcA = 0; ALUSrcB = 1; ALUOp = 0; PCSource = 0; PCWrite = 1; IRWrite = 1; 
							 RegSelect1 = 1; RegSelect2 = 1; RegWrite = 0; PCWriteCond = 0; MemWrite = 0;
							  MemtoReg = 0; end
			//decode
			5'd1:  begin ALUSrcB = 2; PCWrite = 0; IRWrite = 0; end	
            //alu ---r type 
			5'd2:  begin ALUSrcA = 1; ALUSrcB = 0; ALUOp = 2; end			
			5'd3:  begin ALUSrcA = 1; ALUSrcB = 3; ALUOp = 2; end	
			5'd4:  begin ALUSrcA = 1; ALUSrcB = 2; ALUOp = 2; end			
			5'd5:  begin RegSelect1 = 0; RegSelect2 = 0; end			
			5'd6:  begin PCWrite = 1; PCSource = 2; end				 
			5'd7:  begin RegSelect1 = 1; RegSelect2 = 1; ALUOp = 0; ALUSrcA = 1; ALUSrcB = 3; end							 
			//LWS
			5'd12:  begin ALUSrcA = 1; ALUSrcB = 0; ALUOp = 2; end	

			5'd8:  begin  ALUOp = 2; ALUSrcA = 1; ALUSrcB = 0; end			
			5'd9:  begin RegSelect1 = 1; RegSelect2 = 2; ALUOp = 0; ALUSrcA = 1; ALUSrcB = 3; end			
			5'd10: begin RegSelect1 = 1; RegSelect2 = 2; ALUOp = 0; ALUSrcA = 2; ALUSrcB = 3; end
			//memory ==r type 
			5'd11: begin RegWrite = 1; MemtoReg = 0; end	
			//5'd12: begin Instr26 = 0; ALUSrcA = 1; ALUSrcB = 0; ALUOp = 2; PCSource = 1; PCWriteCond = 1; end	
			5'd13: begin ALUSrcA = 1; ALUSrcB = 0; ALUOp = 1; PCSource = 1; PCWriteCond = 1; end	
			//5'd14: begin Instr26 = 1; ALUSrcA = 1; ALUSrcB = 0; ALUOp = 1; PCSource = 1; PCWriteCond = 1; end						 						 
			5'd15: begin MemtoReg = 1; end			
			5'd16: begin MemWrite = 1; end
			5'd17: begin RegWrite = 1; end	
			default: begin PCWriteCond = 1'bx; PCWrite = 1'bx; MemWrite = 1'bx; MemtoReg = 1'bx; IRWrite = 1'bx;
								PCSource = 2'bx; ALUOp = 2'bx; ALUSrcA = 2'bx; ALUSrcB = 2'bx; RegWrite = 1'bx;
								 RegSelect1 = 1'bx; RegSelect2 = 2'bx; end
		endcase
	end
	
	// State transitions
	always @(reset or state or opcode)
	begin
		if (reset)
			next_state = 0;
		else
			case (state)

				5'd0: next_state = 5'd1;		
				5'd1: 
						// NOOP
						if (opcode == NOOP)
							next_state <= 5'd0;
						// R-types
						else if ((opcode == ADD) || (opcode == SUB) || (opcode == AND) || (opcode == CAS)|| (opcode == CMP))
							next_state <= 5'd2;	
						// LWS
						else if (opcode ==LWS ) 
						next_state <= 5'd8;
						// Branches
						else if ((opcode == JAL) || (opcode == J)) 
						next_state <= 5'd6;	
						else if (opcode == BEQ)
							next_state <= 5'd5;	
						// Sign Extended Arithmetic/Logical I-types
						else if (opcode == ADDI)
							next_state <= 5'd4;
						// Zero Extended Arithmetic/Logical I-types
						else if ( (opcode == LUI) || (opcode == ANDI))
							next_state <= 5'd3;
					   // Loads and stores
					   //store
						else if (opcode == SW)
							next_state <= 5'd9;
						
						else if (opcode == LW)
							next_state <= 5'd7;		
						
				5'd2:  next_state <= 5'd11;
				5'd3:  next_state <= 5'd11;
				5'd4:  next_state <= 5'd11;	
				5'd5:  
						// BEQ
						if (opcode == BEQ)
							next_state <= 5'd13;		
						
				5'd6:  next_state <= 5'd0;
				5'd7:  next_state <= 5'd15;
				5'd8:  next_state <= 5'd15;
				5'd9:  next_state <= 5'd16;
				5'd10: next_state <= 5'd16;
				5'd11: next_state <= 5'd0;
				//5'd12: next_state <= 5'd0;
				5'd13: next_state <= 5'd0;
				//5'd14: next_state <= 5'd0;
				5'd15: next_state <= 5'd17;
				5'd16: next_state <= 5'd0;
				5'd17: next_state <= 5'd0;	
			endcase
	end
	
	endmodule
    