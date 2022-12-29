`timescale 1ns/1ns

module Adder(
  input[31:0] A, B,
  output[31:0] sum
);

  assign sum = A + B;
endmodule

