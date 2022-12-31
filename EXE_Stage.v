`timescale 1ns/1ns

module EXE_Stage(
    input clk, rst, 
    input[31:0] ALU_MEM_Val,
    input[31:0] WB_Val,
    input[1:0] Sel_src1, Sel_src2,
    input[3:0] exe_cmd, 
    input MEM_R_EN, MEM_W_EN, imm, SR,
    input[31:0] PC, Val_Rn, Val_Rm,
    input[11:0] shift_operand,
    input[23:0] Signed_imm_24, 
    output[31:0] ALU_result, Br_addr, 
    output[3:0] status,
    output[31:0] Val_Rm_EXEC
);

  wire[31:0] mux32_1_out, mux32_2_out;
  wire[31:0] op1,op2;
  wire mem_en;
  assign op1 = Val_Rn;
  Adder adder(PC, {{(6){Signed_imm_24[23]}}, Signed_imm_24, 2'b00}, Br_addr);
  assign mem_en = MEM_R_EN | MEM_W_EN;
  Val2Generator val2generator(shift_operand, imm, mem_en, Val_Rm, op2);
  ALU alu(Val_Rn, op2, SR, exe_cmd, ALU_result, status);
 
  assign Val_Rm_EXEC = Val_Rm;
endmodule
