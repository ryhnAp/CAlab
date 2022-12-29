`timescale 1ns/1ns

module MEM_Stage(
    input clk, MEMread, MEMwrite, 
    input [31:0] address, data, 
    output [31:0] MEM_result
);

  Data_Memory memory (address, data, clk, MEMread, MEMwrite, MEM_result);
endmodule