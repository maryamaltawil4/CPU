`timescale 1ns / 1ns

module reg_pc(
	input clock,
	input reset,
	input PC_on,
	input [23:0] PC_in,
	output [23:0] PC_out
   );
	

	reg [23:0] Reg = 0; 

	assign PC_out = Reg;
	
	always@(posedge clock or reset)   
		begin
			if (reset)
				Reg <= 23'd0;
			else if (PC_on)
				Reg <= PC_in;
		end
endmodule





