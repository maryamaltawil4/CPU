`timescale 1ns / 1ps

module MemoryData_register(
	input clock,
	input [23:0] data_in,
	output [23:0] data_out
   );

	reg [23:0] Reg;

	assign data_out = Reg;

	always@(posedge clock)
		begin
		Reg <= data_in;
		end

endmodule
