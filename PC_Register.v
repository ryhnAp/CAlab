`timescale 1ns/1ns

module PC_Register(
  input clk, rst, freeze,
  input [31:0] pc_in,
  output reg [31:0] pc
);

  always@(posedge clk, posedge rst) begin
    if (rst)
      pc <= 32'd0;
    else if (~freeze)
      pc <= pc_in;
  end
endmodule
