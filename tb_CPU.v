`timescale 1ns / 1ns
`include "CPU.v"
`default_nettype none

module tb_CPU;

	reg clk;
	reg rst;

	// Outputs
	wire [23:0] pc_out;
	wire [23:0] ALU_OUT;

	always #25 assign clk = ~clk;


	CPU uut(
		.clk(clk), 
		.rst(rst), 
		.pc_out(pc_out), 
		.ALU_OUT(ALU_OUT)
	);
initial begin
	$dumpfile("tb_CPU.vcd");
	$dumpvars(0, tb_CPU);
end
	initial begin

		clk = 0;
		rst = 1;

		#50;
		rst = 0;
		
	end
      
endmodule

