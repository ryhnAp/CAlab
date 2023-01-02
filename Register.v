`timescale 1ns/1ns
module register (
    clk, 
    rst, 
    ld, 
    in, 
    out
);
    parameter len = 32;

    input clk, rst, ld; 
    input[len-1:0] in;
    output reg[len-1:0] out;

    always @(posedge clk, posedge rst)
	begin
		if(rst) 
            out <= 0;
		else if(~ld)
            out <= in;
	end

endmodule