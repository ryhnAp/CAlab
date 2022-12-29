`timescale 1ns/1ns

module Register_File(
    input clk, rst,
    input reg_write,
    input [3:0] src1, src2,
    input [3:0] reg_dest,
    input [31:0] data,
    output [31:0] reg1, reg2
);

  reg [31:0] registers [0:14];
  
  assign reg1 = registers[src1];
  assign reg2 = registers[src2];
  
  integer i;  
  always @(negedge clk, posedge rst) begin
    if(rst) begin
      for(i = 0; i < 15; i = i + 1)
          registers[i] <= i;
    end
    else begin
      if(reg_write)
          registers[reg_dest] <= data;
    end
  end
endmodule
