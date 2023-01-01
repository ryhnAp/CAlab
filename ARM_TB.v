`timescale 1ns/1ns
module ARM_TB();

  	reg clk = 1'b1, rst = 1'b1, forward_en=1'b1;

	ARM arm_f(.clk(clk), .rst(rst), .forward_en(forward_en));
	ARM arm_nf(.clk(clk), .rst(rst), .forward_en(~forward_en));

  	always	#10 clk = ~clk;

	initial begin
		#10 rst = 1'b0;
		#100000 $stop;
	end

endmodule