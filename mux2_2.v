`timescale 1ns / 1ns

module mux2_2(sel, a, b, y);

	input sel;
	input   a, b;
	output  y;
	
	assign y = sel ? b : a;
	
endmodule
