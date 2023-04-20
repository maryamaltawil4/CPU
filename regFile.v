

`timescale 1ns / 1ps
module regFile(write_data,read_data_1,read_data_2,read_sel_1, read_sel_2,write_address, RegWrite, clk);
                          
    input   clk, RegWrite;	 
    input   [23:0] write_data;
    input   [2:0] read_sel_1, read_sel_2, write_address;
    output  wire [23:0] read_data_1, read_data_2;
    
    integer i;
	
	reg [23:0] register_file [7:0];
	
       initial begin
            register_file [1] = 23'd9;
            register_file [2] = 23'd1;
       end
    

	//reg [7:0] StatusReg;
	
	initial begin
		for (i=0;i<8;i=i+1)
			register_file[i] = 0; 
	end

    always @ (posedge clk) begin
        if (RegWrite) begin
			if(write_address == 0) begin
		    //  $monitor("Forbidden");
            register_file[write_address] = write_data;
			end
		else begin

            register_file[write_address] = write_data;
        end	 
	
	end		 
	
end
	assign read_data_1 = register_file[read_sel_1];
	assign read_data_2 = register_file[read_sel_2];
	
endmodule
