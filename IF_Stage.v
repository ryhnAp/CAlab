`timescale 1ns/1ns
module IF_Stage(
  clk, 
  rst, 
  freeze, 
  branch_taken, 
  branch_address, 
  PC, 
  Instruction
);
  input clk, rst, freeze, branch_taken;
  input [31:0] branch_address;
  output [31:0] PC, Instruction;

  wire [31:0] prev_pc, next_pc;

  MUX #(.len(32)) branch_pc(.in0(PC), .in1(branch_address), .sel(branch_taken), .out(next_pc));

  PC_Register pc_reg(.clk(clk), .rst(rst), .freeze(freeze), .pc_in(next_pc), .pc(prev_pc));
  
  Adder program_counter(.left(prev_pc), .right(32'd4), .sum(PC));

  Instruction_Memory inst_mem(.Address(prev_pc), .Instruction(Instruction));

endmodule