`timescale 1ns/1ns
module Register_File(
  clk, 
  rst,
  reg_write,
  src1, 
  src2,
  reg_dest,
  data,
  reg1, 
  reg2
);
  parameter count = 15;
  parameter size = 4;
  parameter len = 32;

  input clk, rst;
  input reg_write;
  input [size-1 : 0] src1, src2;
  input [size-1 : 0] reg_dest;
  input [len-1 : 0] data;
  output [len-1 : 0] reg1, reg2;

  reg [len-1 : 0] registers [0 : count-1];
  
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