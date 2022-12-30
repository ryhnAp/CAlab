`timescale 1ns/1ns

module register #(parameter size = 1)(input clk, rst, freeze, input[size-1:0] in, output reg[size-1:0] out);
    always @(posedge clk, posedge rst)
	begin
		if(rst) 
            out <= 0;
		else if(~freeze)
            out <= in;
	end
endmodule
 
 