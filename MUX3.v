`timescale 1ns/1ns
module MUX3(
  in0,
  in1,
  in2,
  sel,
  out
);
  parameter len = 8;

  input [len-1:0] in0 , in1 ,in2; 
  input [1:0] sel;
  output [len-1:0] out; 
  
  assign out = sel[1] ? in2 : sel[0] ? in1 : in0;

endmodule