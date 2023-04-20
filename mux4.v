`timescale 1ns / 1ns

module mux4(sel, in0, in1, in2, in3, out);
	input [1:0] sel;
	input  [23:0] in0, in1, in2, in3;
	output [23:0] out;
	
	assign out = (sel == 0) ? in0 :  // in0: B
					 (sel == 1) ? in1 :  // in1: 32'd1;
					 (sel == 2) ? in2 :  // in2: immediate 32-bit (Instr[15:0] sign extended to 32-bit)
					 (sel == 3) ? in3 :  // in3: 32-bit address (might not need to shift by 2 if word addressable)
									    0 ;
endmodule
