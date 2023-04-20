`timescale 1ns / 1ns

module ALUOut_register(
	input clock,
	input [23:0] ALUOut_in,
	output [23:0] ALUOut_out
   );


	reg [23:0] Reg;

	assign ALUOut_out = Reg;

	always@(posedge clock)
		begin
		Reg <= ALUOut_in;
		end

endmodule
