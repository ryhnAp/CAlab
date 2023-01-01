`timescale 1ns/1ns
module PC_Register(
  clk, 
  rst, 
  freeze,
  pc_in,
  pc
);
  parameter size = 32;

  input clk, rst, freeze;
  input [size-1 : 0] pc_in;
  output reg [size-1 : 0] pc;

  always@(posedge clk, posedge rst) begin
    if (rst)
      pc <= 32'd0;
    else if (~freeze)
      pc <= pc_in;
  end

endmodule