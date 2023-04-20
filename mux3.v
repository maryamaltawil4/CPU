`timescale 1ns / 1ns

module mux3(sel, in0, in1, in2, out);
	input [1:0] sel;
	input  [23:0] in0, in1, in2;
	output [23:0] out;
	
	assign out = (sel == 0) ? in0 :  // in0: ALUResult
					 (sel == 1) ? in1 :  // in1: ALUOut
					 (sel == 2) ? in2 :  // in2: PC
									    0 ;
endmodule
