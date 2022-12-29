`timescale 1ns/1ns

module MUX #(parameter N = 32)(
  input [N-1:0] A, B,
  input sel,
  output [N-1:0] out
);
  assign out = sel ? B : A;
endmodule
