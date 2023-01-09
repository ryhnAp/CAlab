`timescale 1ns/1ns
module ARM_TB();
  	reg clk = 1'b0, rst = 1'b1, Forward_en = 1'b0;

  	wire [17 : 0] SRAM_ADDR;
  	wire [15 : 0] SRAM_DQ;
  	wire SRAM_WE_N;

  	ARM arm(.clk(clk), .rst(rst), .forward_en(Forward_en), .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR), .SRAM_WE_N(SRAM_WE_N));

  	SRAM SRAM (.clk(clk), .rst(rst), .SRAM_WE_N(SRAM_WE_N), .SRAM_ADDR(SRAM_ADDR), .SRAM_DQ(SRAM_DQ));

  	always	#10 clk = ~clk;

	initial begin
		#10 rst = 1'b0;
		#100000 $stop;
	end

endmodule