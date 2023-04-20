`timescale 1ns / 1ns

module mux2(sel, a, b, y);

	input sel;
	input  [23:0] a, b;
	output [23:0] y;
	
	assign y = sel ? b : a;
	
endmodule
