`timescale 1ns / 1ns

module first_block(
	input clock,
	input [23:0] a_in,
	output [23:0] a_out
   );


	reg [23:0] Reg;

	assign a_out = Reg;

	always@(posedge clock)
		begin
		Reg <= a_in;
		end

endmodule
