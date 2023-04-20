`timescale 1ns / 1ns

module zeroextender(in, out);
	input  [16:0] in;
	output [23:0] out;
		
	assign out = {7'd0, in};

endmodule