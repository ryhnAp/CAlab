`timescale 1ns/1ns
module MUX(
  in0, 
  in1,
  sel,
  out
);
  parameter len = 32;

  input [len-1:0] in0, in1;
  input sel;
  output [len-1:0] out;

  assign out = sel ? in1 : in0;

endmodule