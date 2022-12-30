`timescale 1ns/1ns
module ARM_TB();

  wire[15:0] SRAM_DQ;
  wire[17:0] SRAM_ADDR;
  wire SRAM_WE_N;

  reg clk = 1'b0, rst = 1'b1, Forward_en = 1'b0;

  ARM arm(clk, rst, Forward_en, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);

  SRAM SRAM (clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);
	
  always	#10 clk = ~clk;

	initial begin
		#10 rst = 1'b0;
		#100000 $stop;
	end
endmodule

