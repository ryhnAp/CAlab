`timescale 1ns/1ns
module Adder(
  left,
  right,
  sum
);
  parameter size = 32;

  input [size-1 : 0] left, right;
  output [size-1 : 0] sum;

  assign sum = left + right;

endmodule