`timescale 1ns/1ns
module ARM(
  clk, 
  rst
);
  input clk, rst;

  wire branch, hazard, one_input, two_input;
  wire regWrite, memRead_ID, memWrite_ID, regWrite_ID, branch_ID, s_ID ,immediate_ID;
  wire memRead_EXEC, memWrite_EXEC, regWrite_EXEC, s_EXEC, ALU_carry_in, immediate_EXEC;
  wire regWrite_MEM, memRead_MEM, memWrite_MEM, memRead_WB;

  wire [3:0] WB_destination, destReg_ID, destReg_EXEC, destReg_MEM, first_input, second_input;
  wire [3:0] statusRegs, ALU_statusBits, EXE_command_ID, EXE_command_EXEC;

  wire [11:0] shift_operand_ID, shift_operand_EXEC;

  wire [23:0] s_imm_ID, s_imm_EXEC;
  
  wire [31:0] WB_data, Val_Rn_ID, Val_Rm_ID, Val_Rn_EXEC, Val_Rm_EXEC, Val_Rm_MEM, ALU_result_EXEC, ALU_result_MEM;
  wire [31:0] memory_result_MEM, memory_result_WB, ALU_result_WB;
  wire [31:0] Instruction, Inst_ID, Inst_EXEC, Inst_MEM, Inst_WB, branch_address, PC, PC_ID, PC_EXEC, PC_MEM, PC_WB; 
  wire [31:0] ID_Val_Rm_EXEC;
  
  IF_Stage if_s(
    .clk(clk), 
    .rst(rst), 
    .freeze(hazard), 
    .branch_taken(branch), 
    .branch_address(branch_address), 
    .PC(PC), 
    .Instruction(Instruction));

  IF_Stage_Register if_s_r(
    .clk(clk), 
    .rst(rst), 
    .freeze(hazard), 
    .flush(branch),
    .pc_in(PC), 
    .instruction_in(Instruction),
    .pc(PC_ID), 
    .instruction(Inst_ID));
  
  ID_Stage id_s(
    .clk(clk), 
    .rst(rst), 
    .instruction(Inst_ID), 
    .WB_data(WB_data),
    .WB_destination(WB_destination),
    .WB_en(regWrite),
    .hazard(hazard),
    .status_regs(statusRegs),
    .mem_read_out(memRead_ID), 
    .mem_write_out(memWrite_ID), 
    .WB_en_out(regWrite_ID), 
    .branch(branch_ID), 
    .s_out(s_ID),
    .imm_out(immediate_ID), 
    .EXE_cmd(EXE_command_ID), 
    .dest_reg(destReg_ID),
    .shift_operand(shift_operand_ID),
    .signed_immediate(s_imm_ID),
    .Val_Rn(Val_Rn_ID), 
    .Val_Rm(Val_Rm_ID),
    .src1(first_input), 
    .src2(second_input),
    .one_src(one_input), 
    .two_src(two_input));

  ID_Stage_Register id_s_r(
    .clk(clk), 
    .rst(rst), 
    .flush(branch),
    .WB_en_in(regWrite_ID), 
    .mem_write_in(memWrite_ID), 
    .mem_read_in(memRead_ID), 
    .imm_in(immediate_ID), 
    .branch_in(branch_ID), 
    .s_in(s_ID), 
    .carry_bit_in(statusRegs[1]),
    .EXE_cmd_in(EXE_command_ID), 
    .dest_in(destReg_ID),
    .shift_operand_in(shift_operand_ID), 
    .signed_imm_in(s_imm_ID),
    .pc_in(PC_ID), 
    .Val_Rn_in(Val_Rn_ID), 
    .Val_Rm_in(Val_Rm_ID), 
    .instruction_in(Inst_ID),
    .WB_en_out(regWrite_EXEC), 
    .mem_write_out(memWrite_EXEC), 
    .mem_read_out(memRead_EXEC), 
    .imm_out(immediate_EXEC), 
    .branch_out(branch), 
    .s_out(s_EXEC), 
    .carry_bit_out(ALU_carry_in),
    .EXE_cmd_out(EXE_command_EXEC), 
    .dest_out(destReg_EXEC),
    .shift_operand_out(shift_operand_EXEC), 
    .signed_imm_out(s_imm_EXEC),
    .pc_out(PC_EXEC), 
    .Val_Rn_out(Val_Rn_EXEC), 
    .Val_Rm_out(Val_Rm_EXEC), 
    .instruction_out(Inst_EXEC));

  Status_Register status_register(
    .clk(clk), 
    .rst(rst), 
    .load(s_EXEC), 
    .status_in(ALU_statusBits), 
    .status(statusRegs));
  
  EXE_Stage exe_s(
    .clk(clk), 
    .exe_cmd(EXE_command_EXEC), 
    .MEM_R_EN(memRead_EXEC), 
    .MEM_W_EN(memWrite_EXEC), 
    .imm(immediate_EXEC), 
    .SR(ALU_carry_in),.PC(PC_EXEC), 
    .Val_Rn(Val_Rn_EXEC), 
    .Val_Rm(Val_Rm_EXEC), 
    .shift_operand(shift_operand_EXEC), 
    .Signed_imm_24(s_imm_EXEC), 
    .ALU_result(ALU_result_EXEC), 
    .Br_addr(branch_address), 
    .status(ALU_statusBits), 
    .Val_Rm_EXEC(ID_Val_Rm_EXEC));

  EXE_Stage_Register exe_s_r(
    .clk(clk), 
    .rst(rst), 
    .WB_en_in(regWrite_EXEC), 
    .MEM_R_EN_in(memRead_EXEC), 
    .MEM_W_EN_in(memWrite_EXEC), 
    .ALU_result_in(ALU_result_EXEC), 
    .ST_val_in(ID_Val_Rm_EXEC), 
    .PC_in(PC_EXEC), 
    .Instruction_in(Inst_EXEC), 
    .Dest_in(destReg_EXEC), 
    .WB_en(regWrite_MEM), 
    .MEM_R_EN(memRead_MEM), 
    .MEM_W_EN(memWrite_MEM), 
    .ALU_result(ALU_result_MEM), 
    .ST_val(Val_Rm_MEM), 
    .PC(PC_MEM), 
    .Instruction(Inst_MEM), 
    .Dest(destReg_MEM));

  MEM_Stage mem_s(
    .clk(clk), 
    .MEMread(memRead_MEM), 
    .MEMwrite(memWrite_MEM), 
    .address(ALU_result_MEM), 
    .data(Val_Rm_MEM), 
    .MEM_result(memory_result_MEM));

  MEM_Stage_Register mem_s_r(
    .clk(clk), 
    .rst(rst), 
    .WB_en_in(regWrite_MEM), 
    .MEM_R_en_in(memRead_MEM), 
    .ALU_result_in(ALU_result_MEM), 
    .MEM_read_value_in(memory_result_MEM), 
    .PC_in(PC_MEM), 
    .Instruction_in(Inst_MEM), 
    .Dest_in(destReg_MEM), 
    .WB_en(regWrite), 
    .MEM_R_en(memRead_WB),
    .ALU_result(ALU_result_WB), 
    .MEM_read_value(memory_result_WB), 
    .PC(PC_WB), 
    .Instruction(Inst_WB),
    .Dest(WB_destination));
  
  WB_Stage WB_Stage(
    .mem_read(memRead_WB), 
    .ALU_result(ALU_result_WB), 
    .MEM_result(memory_result_WB), 
    .out_result(WB_data));
  
  Hazard_Unit hazard_unit(
    .Exe_WB_EN(regWrite_EXEC), 
    .Mem_WB_EN(regWrite_MEM), 
    .Two_src(two_input), 
    .EXE_MEM_R_EN(memRead_EXEC),
    .src1(first_input), 
    .src2(second_input), 
    .Exe_Dest(destReg_EXEC), 
    .Mem_Dest(destReg_MEM),
    .hazard_Detected(hazard));

endmodule