`timescale 1ns/1ns

module ARM(input clk, rst);

  wire branch, hazard, one_input, two_input;
  wire regWrite, memRead_ID, memWrite_ID, regWrite_ID, branch_ID, s_ID ,immediate_ID;
  wire memRead_EXEC, memWrite_EXEC, regWrite_EXEC, s_EXEC, ALU_carry_in, immediate_EXEC;
  wire regWrite_MEM, memRead_MEM, memWrite_MEM, memRead_WB;

  wire[1:0] sel_src1, sel_src2;

  wire [3:0] WB_destination, destReg_ID, destReg_EXEC, destReg_MEM, first_input, second_input;
  wire [3:0] statusRegs, ALU_statusBits, EXE_command_ID, EXE_command_EXEC;
  wire [3:0] src1_reg, src2_reg;

  wire [11:0] shift_operand_ID, shift_operand_EXEC;

  wire [23:0] s_imm_ID, s_imm_EXEC;
  
  wire [31:0] WB_data, Val_Rn_ID, Val_Rm_ID, Val_Rn_EXEC, Val_Rm_EXEC, Val_Rm_MEM, ALU_result_EXEC, ALU_result_MEM;
  wire [31:0] memory_result_MEM, memory_result_WB, ALU_result_WB;
  wire [31:0] Instruction, Inst_ID, Inst_EXEC, Inst_MEM, Inst_WB, branch_address, PC, PC_ID, PC_EXEC, PC_MEM, PC_WB; 
  wire[31:0] ID_Val_Rm_EXEC;
  
  IF_Stage IF_Stage(clk, rst, hazard, branch, branch_address, PC, Instruction);

  IF_Stage_Register IF_ID_Register(clk, rst, hazard, branch, PC, Instruction, PC_ID, Inst_ID);
  
  ID_Stage ID_Stage(clk, rst, Inst_ID, WB_data, WB_destination, regWrite, hazard, statusRegs,
              memRead_ID, memWrite_ID, regWrite_ID, branch_ID, s_ID, immediate_ID, 
              EXE_command_ID, destReg_ID, shift_operand_ID, s_imm_ID,
              Val_Rn_ID, Val_Rm_ID, first_input, second_input, one_input, two_input);

  ID_Stage_Register ID_EXE_Register(clk, rst, branch, regWrite_ID, memWrite_ID, memRead_ID, immediate_ID, branch_ID, s_ID, statusRegs[1], EXE_command_ID, 
                       destReg_ID, shift_operand_ID, s_imm_ID, PC_ID, Val_Rn_ID, Val_Rm_ID, Inst_ID, first_input, second_input, 
                       regWrite_EXEC, memWrite_EXEC, memRead_EXEC, immediate_EXEC, branch, s_EXEC, ALU_carry_in, EXE_command_EXEC, 
                       destReg_EXEC, shift_operand_EXEC, s_imm_EXEC, PC_EXEC, Val_Rn_EXEC, Val_Rm_EXEC, 
                       Inst_EXEC, src1_reg, src2_reg);
  
  EXE_Stage EXE_Stage(clk, rst, ALU_result_MEM, WB_data, 1'b0, 1'b0, EXE_command_EXEC, memRead_EXEC, memWrite_EXEC, immediate_EXEC, ALU_carry_in,
            PC_EXEC, Val_Rn_EXEC, Val_Rm_EXEC, shift_operand_EXEC, s_imm_EXEC,
            ALU_result_EXEC, branch_address, ALU_statusBits, ID_Val_Rm_EXEC);
            
  EXE_Stage_Register EXE_MEM_Register(clk, rst, regWrite_EXEC, memRead_EXEC, memWrite_EXEC, ALU_result_EXEC, 
                          ID_Val_Rm_EXEC, PC_EXEC, Inst_EXEC, destReg_EXEC, 
                          regWrite_MEM, memRead_MEM, memWrite_MEM, ALU_result_MEM, 
                          Val_Rm_MEM, PC_MEM, Inst_MEM, destReg_MEM);
  
  MEM_Stage MEM_Stage(clk, memRead_MEM, memWrite_MEM, ALU_result_MEM, Val_Rm_MEM, memory_result_MEM);
  
  MEM_Stage_Register MEM_WB_Register(clk, rst, regWrite_MEM, memRead_MEM, ALU_result_MEM, memory_result_MEM, PC_MEM, Inst_MEM, destReg_MEM,
                       regWrite, memRead_WB, ALU_result_WB, memory_result_WB, PC_WB, Inst_WB, WB_destination);
  
  WB_Stage WB_Stage(memRead_WB, ALU_result_WB, memory_result_WB, WB_data);

  Hazard_Unit hazard_unit(regWrite_EXEC, regWrite_MEM, two_input,
                      	 memRead_EXEC, first_input, second_input, destReg_EXEC,
                      	 destReg_MEM, hazard);

  Status_Register status_register(clk, rst, s_EXEC, ALU_statusBits, statusRegs);
endmodule