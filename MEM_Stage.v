`timescale 1ns/1ns
module MEM_Stage(
  clk, 
  MEMread, 
  MEMwrite, 
  address, 
  data, 
  MEM_result
);
  input clk, MEMread, MEMwrite;
  input [31 : 0] address, data;
  output [31 : 0] MEM_result;

  Data_Memory memory(.clk(clk), .MEM_read(MEMread), .MEM_write(MEMwrite),
    .Add(address), .input_data(data), .out_data(MEM_result));

endmodule