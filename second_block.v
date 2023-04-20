`timescale 1ns / 1ns

module second_block(
	input clock,
	input [23:0] b_in,
	output [23:0] b_out
   );


	reg [23:0] Reg;

	assign b_out = Reg;

	always@(posedge clock)
		begin
		Reg <= b_in;
		end

endmodule
