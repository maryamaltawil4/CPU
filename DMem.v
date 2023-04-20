
module DMem(WriteData,   
            MemData,     
            Address,     
            MemWrite,    		
            Clk);        

input [23:0]  WriteData;
input [23:0]    Address;
input MemWrite;
input Clk;

output [23:0] MemData;

reg [23:0] mem_contents [23:0];
integer i;

assign MemData= mem_contents[Address];

always @(posedge Clk)
begin
	if(MemWrite)
	begin
		mem_contents[Address]<= WriteData;
	end
end

endmodule