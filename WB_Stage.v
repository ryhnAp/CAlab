`timescale 1ns/1ns
module WB_Stage(
  mem_read,
  ALU_result, 
  MEM_result,
  out_result
);
  input mem_read;
  input [31:0] ALU_result, MEM_result;
  output [31:0] out_result;

  MUX #(.len(32)) mux(
    .in0(ALU_result), 
    .in1(MEM_result),
    .sel(mem_read),
    .out(out_result)
  );
  
endmodule