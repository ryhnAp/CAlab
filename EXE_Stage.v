`timescale 1ns/1ns
module EXE_Stage(
  clk,
  exe_cmd, 
  MEM_R_EN, 
  MEM_W_EN, 
  Val_Rn, 
  Val_Rm,
  imm, 
  shift_operand,
  Signed_imm_24, 
  SR,
  PC, 
  ALU_result, 
  Br_addr, 
  status,
  Val_Rm_EXEC
);
  input clk;
  input [3 : 0] exe_cmd;
  input MEM_R_EN, MEM_W_EN, imm, SR;
  input [31 : 0] PC, Val_Rn, Val_Rm;
  input [11 : 0] shift_operand;
  input [23 : 0] Signed_imm_24;
  output [31 : 0] ALU_result, Br_addr;
  output [3 : 0] status;
  output [31 : 0] Val_Rm_EXEC;

  wire [31 : 0] mux32_1_out, mux32_2_out;
  wire [31 : 0] op1,op2;
  wire mem_en;

  assign op1 = Val_Rn;
  Adder cal_branch(.left(PC), .right({{(6){Signed_imm_24[23]}}, Signed_imm_24, 2'b00}),
    .sum(Br_addr));

  assign mem_en = MEM_R_EN | MEM_W_EN;

  Val2Generator val2generator(.shifter_operand(shift_operand), .I(imm), .mem_en(mem_en), .val_Rm(Val_Rm), .out(op2));

  ALU alu(.op1(Val_Rn), .op2(op2), .carry(SR), .exe_cmd(exe_cmd),
    .ALU_Res(ALU_result), .Status_Bits(status));
 
  assign Val_Rm_EXEC = Val_Rm;

endmodule