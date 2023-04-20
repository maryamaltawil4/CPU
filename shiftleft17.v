`timescale 1ns / 1ns

module shiftleft17(
	input [3:0] PC,
	input [2:0] R1, R2,
	input [16:0] Immediate,
	output [23:0] JumpAddress_out
);

	assign JumpAddress_out = {PC, 2'd0, R1, R2, Immediate};

endmodule
