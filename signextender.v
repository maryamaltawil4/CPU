`timescale 1ns / 1ns

module signextender(in, out);
	input  [16:0] in;
	output [23:0] out;
		
	assign out = { {7{in[16]}}, in};
	
endmodule
