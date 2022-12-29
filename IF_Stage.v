`timescale 1ns/1ns

module IF_Stage(
    input clk, rst, freeze, branch_taken, 
    input [31:0] branch_address, 
    output [31:0] PC, Instruction
);

  wire [31:0] prev_pc, next_pc;
  MUX #32 PCMUX(PC, branch_address, branch_taken, next_pc);
  PC_Register PCReg(clk, rst, freeze, next_pc, prev_pc);
  Adder AddPC(prev_pc, 32'd4, PC);
  Instruction_Memory InstMem(prev_pc, Instruction);
endmodule
