`timescale 1ns / 1ns

module mux2_3(sel, a, b, y);

	input sel;
	input  [2:0] a, b;
	output [2:0] y;
	
	assign y = sel ? b : a;
	
endmodule
