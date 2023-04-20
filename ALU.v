`timescale 1ns / 1ns

module ALU(aluSel, a, b,result, zero,SF,cond);
	input [3:0] aluSel; 
	input [1:0] cond;
	input [23:0] a, b;
	output[23:0] result;
	output zero;
	input SF;
	
	reg [23:0] result = 0;
	reg zero;
	
	always @(*)
	begin
		case (aluSel)		
		    //NOOP OPRATION
			4'd0 : result <= result;
	         // AND
			4'd1 : result = a & b; 	
			//CAS
			4'd2 :if (a>b)
		        	 result = a;
				  else
				   result = b;
			 //ADD
			4'd3 : 
                if (cond==0 && SF==0)  //add                 
			       result= a + b; 

				else if (cond==1)begin //addEQ
				   if (a == b ) begin
			       result= a + b;
				   end

                   else
                   result = 0;
                end

				 else if (cond==2)begin //addNe
				   if (a != b ) begin
			       result= a + b;
				    end 
                    else
                   result = 0;
                 end
            
					else
					result = 0; 
                    
			//SUB
			4'd4 :if (cond==00) begin
                result = a - b; 
             if (SF==0) //sub
             begin
			 zero = 1;
             end

			 else if (SF==1)  //subsf 
             begin
			 zero = a == b; 
             end

			end	

			else if (cond==1) begin //subEQ
              if (a==b) 
			  result = a - b;
			  else
					result = 0;
			end
			else if (cond==2) begin //subNe
			  if (a != b) 
			  result = a - b;
			  else
					result =0;
			end
			//CMP
			4'd5 : if (a < b) begin
			zero = 1;
			result=0;
			end 
			else begin
			zero=0;
			result=0;
			end
			4'd6 : result = {b[16:0], 6'd0}; 	// LUI

			default : result = 23'hxxxx;
		endcase
		
		if (result == 0) zero = 1;
		else zero = 0;
	end
endmodule
    