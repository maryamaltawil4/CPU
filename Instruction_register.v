`timescale 1ns / 1ps

module Instruction_register(
	input clock,
	input IRWrite,
	input wire [23:0] Instr_in,
	output reg [1:0] cond,
    output reg [4:0] opcode,
    output reg sf,
    output reg [2:0] rd,
    output reg [2:0] rs,
    output reg [2:0] rt,
    output reg [6:0] unused,
    output reg [9:0] Iimm,
    output reg [16:0] Jimm
    
	);

always@(posedge clock)
		begin
			if (IRWrite)


    cond [1:0] = Instr_in [23:22];
    opcode [4:0] = Instr_in [21:17];

    if(opcode >= 0 && opcode <= 6)
    begin

        sf = Instr_in [16];
        rd [2:0] = Instr_in [15:13]; // change order (rd last) when connecting it to reg. file
        rs [2:0] = Instr_in [12:10];
        rt [2:0] = Instr_in [9:7];
        unused [6:0] = Instr_in [6:0];
    end

    else if(Instr_in >= 7 && Instr_in <= 11)
    begin
        sf = Instr_in [16];
        rt [2:0] = Instr_in [15:13]; // change order (rs, rt) when connecting it to reg. file
        rs [2:0] = Instr_in [12:10];
        Iimm [9:0] = Instr_in [9:0];
    end

    else if(opcode >= 12 && opcode <= 14)
    begin
        Jimm [16:0] = Instr_in [16:0];
    end

end

endmodule
