`timescale 1ns/1ns
module ARM(
  clk, 
  rst,
  forward_en,
  SRAM_DQ,
  SRAM_ADDR,
  SRAM_WE_N
);
  input clk, rst, forward_en;
  inout [15 : 0] SRAM_DQ;
  output [17 : 0] SRAM_ADDR; 
  output SRAM_WE_N;

  wire branch, hazard, one_input, two_input, freeze, sram_ready,ready;

  wire is_reg_write, 
    mem_read_ID, mem_write_ID, is_reg_write_ID, branch_ID, s_ID ,immediate_ID, is_reg_write_EXE,
      mem_read_EXE, mem_write_EXE, immediate_EXE, s_EXE_en, carry_in_ALU,
    is_reg_write_MEM, mem_read_MEM, mem_write_MEM,
    mem_read_WB;

  wire [1 : 0] sel_src1, sel_src2 ;

  wire [3 : 0] destination_WB, status_reg,
          EXE_command_ID, register_destination_ID, first_input, second_input, src1_reg, src2_reg, 
            EXE_command_EXE, register_destination_EXE,
          status_reg_ALU, register_destination_MEM;

  wire [11 : 0] shift_operand_ID, shift_operand_EXE;

  wire [23 : 0] s_imm_ID, s_imm_EXE;

  wire [31 : 0] PC, PC_ID, instruction, inst_ID,
          data_WB, val_Rn_ID, val_Rm_ID, PC_EXE, val_Rn_EXE, val_Rm_EXE, inst_EXE,
          ALU_result_EXE, branch_address, val_Rm_EXE_out, ALU_result_MEM, val_Rm_MEM, PC_MEM, inst_MEM,
          memory_result_MEM, PC_WB, inst_WB,
          memory_result_WB, ALU_result_WB;  

  //or freeze_or(freeze, ~ready, hazard);

  IF_Stage if_s(
    .clk(clk), 
    .rst(rst), 
    .freeze(freeze), 
    .branch_taken(branch), 
    .branch_address(branch_address), 
    .PC(PC), 
    .Instruction(instruction));

  IF_Stage_Register if_s_r(
    .clk(clk), 
    .rst(rst), 
    .freeze(freeze), 
    .flush(branch),
    .pc_in(PC), 
    .instruction_in(instruction),
    .pc(PC_ID), 
    .instruction(inst_ID));
  
  ID_Stage id_s(
    .clk(clk), 
    .rst(rst), 
    .instruction(inst_ID), 
    .WB_data(data_WB),
    .WB_destination(destination_WB),
    .WB_en(is_reg_write),
    .hazard(hazard),
    .status_regs(status_reg),
    .mem_read_out(mem_read_ID), 
    .mem_write_out(mem_write_ID), 
    .WB_en_out(is_reg_write_ID), 
    .branch(branch_ID), 
    .s_out(s_ID),
    .imm_out(immediate_ID), 
    .EXE_cmd(EXE_command_ID), 
    .dest_reg(register_destination_ID),
    .shift_operand(shift_operand_ID),
    .signed_immediate(s_imm_ID),
    .Val_Rn(val_Rn_ID), 
    .Val_Rm(val_Rm_ID),
    .src1(first_input), 
    .src2(second_input),
    .one_src(one_input), 
    .two_src(two_input));

  ID_Stage_Register id_s_r(
    .clk(clk), 
    .rst(rst), 
    .flush(branch),
    .freeze(~ready),
    .WB_en_in(is_reg_write_ID), 
    .mem_write_in(mem_write_ID), 
    .mem_read_in(mem_read_ID), 
    .imm_in(immediate_ID), 
    .branch_in(branch_ID), 
    .s_in(s_ID), 
    .carry_bit_in(status_reg[1]),
    .EXE_cmd_in(EXE_command_ID), 
    .dest_in(register_destination_ID),
    .shift_operand_in(shift_operand_ID), 
    .signed_imm_in(s_imm_ID),
    .pc_in(PC_ID), 
    .Val_Rn_in(val_Rn_ID), 
    .Val_Rm_in(val_Rm_ID), 
    .instruction_in(inst_ID),
    .first_input(first_input), 
    .second_input(second_input),
    .src1_reg(src1_reg), 
    .src2_reg(src2_reg),
    .WB_en_out(is_reg_write_EXE), 
    .mem_write_out(mem_write_EXE), 
    .mem_read_out(mem_read_EXE), 
    .imm_out(immediate_EXE), 
    .branch_out(branch), 
    .s_out(s_EXE_en), 
    .carry_bit_out(carry_in_ALU),
    .EXE_cmd_out(EXE_command_EXE), 
    .dest_out(register_destination_EXE),
    .shift_operand_out(shift_operand_EXE), 
    .signed_imm_out(s_imm_EXE),
    .pc_out(PC_EXE), 
    .Val_Rn_out(val_Rn_EXE), 
    .Val_Rm_out(val_Rm_EXE), 
    .instruction_out(inst_EXE));

  Status_Register status_register(
    .clk(clk), 
    .rst(rst), 
    .load(s_EXE_en), 
    .status_in(status_reg_ALU), 
    .status(status_reg));
  
  EXE_Stage exe_s(
    .clk(clk), 
    .exe_cmd(EXE_command_EXE), 
    .MEM_R_EN(mem_read_EXE), 
    .MEM_W_EN(mem_write_EXE), 
    .imm(immediate_EXE), 
    .SR(carry_in_ALU),
    .PC(PC_EXE), 
    .Val_Rn(val_Rn_EXE), 
    .Val_Rm(val_Rm_EXE), 
    .shift_operand(shift_operand_EXE), 
    .Signed_imm_24(s_imm_EXE), 
    .ALU_MEM_Val(ALU_result_MEM), 
    .WB_Val(data_WB),
    .Sel_src1(sel_src1), 
    .Sel_src2(sel_src2), 
    .ALU_result(ALU_result_EXE), 
    .Br_addr(branch_address), 
    .status(status_reg_ALU), 
    .Val_Rm_EXEC(val_Rm_EXE_out));

  EXE_Stage_Register exe_s_r(
    .clk(clk), 
    .rst(rst), 
    .freeze(~ready),
    .WB_en_in(is_reg_write_EXE), 
    .MEM_R_EN_in(mem_read_EXE), 
    .MEM_W_EN_in(mem_write_EXE), 
    .ALU_result_in(ALU_result_EXE), 
    .ST_val_in(val_Rm_EXE_out), 
    .PC_in(PC_EXE), 
    .Instruction_in(inst_EXE), 
    .Dest_in(register_destination_EXE), 
    .WB_en(is_reg_write_MEM), 
    .MEM_R_EN(mem_read_MEM), 
    .MEM_W_EN(mem_write_MEM), 
    .ALU_result(ALU_result_MEM), 
    .ST_val(val_Rm_MEM), 
    .PC(PC_MEM), 
    .Instruction(inst_MEM), 
    .Dest(register_destination_MEM));

  // MEM_Stage mem_s(
  //   .clk(clk), 
  //   .MEMread(mem_read_MEM), 
  //   .MEMwrite(mem_write_MEM), 
  //   .address(ALU_result_MEM), 
  //   .data(val_Rm_MEM), 
  //   .MEM_result(memory_result_MEM));
  wire [31 : 0] sram_addrs;
  wire [31 : 0] sram_write_data;
  wire [63:0] read_data;
  wire sram_write_en, sram_read_en, cache_hit, cache_WE, cache_RE, check_invalid;
  wire [16:0] cache_addr;
  wire [31:0] cache_R_data;
  wire [63:0] cache_write_data;

  SRAM_Controller sram_c(
    .clk(clk), 
    .rst(rst),
    .write_en(sram_write_en), 
    .read_en(sram_read_en),
    .address(sram_addrs), 
    .writeData(sram_write_data),
    .read_data(read_data),
    .ready(sram_ready),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_WE_N(SRAM_WE_N));


  cache cache(
    .clk(clk),
    .rst(rst),
    .cache_write_en(cache_WE), 
    .cache_read_en(cache_RE), 
    .invalid(check_invalid), 
    .address(cache_addr) ,
    .write_data(cache_write_data),
    .hit(cache_hit),
    .read_data(cache_R_data) );

  cache_controller cache_control(
    .clk(clk),
    .rst(rst),
    .mem_write_en(mem_write_MEM),
    .mem_read_en(mem_read_MEM), 
    .SRAM_ready(sram_ready), 
    .cache_hit(cache_hit),
    .address(ALU_result_MEM), 
    .write_data(val_Rm_MEM),
    .cache_read_data(cache_R_data),
    .SRAM_read_data(read_data),
    .ready(ready), 
    .cache_write_en(cache_WE), 
    .cache_read_en(cache_RE), 
    .SRAM_write_en(sram_write_en), 
    .SRAM_read_en(sram_read_en),
    .invalid(check_invalid),
    .cache_address(cache_addr), 
    .SRAM_address(sram_addrs), 
    .SRAM_write_data(sram_write_data), 
    .read_data(memory_result_MEM), 
    .cache_write_data(cache_write_data) );

  wire memRead_MEM_IN;
  MUX #(.len(1)) mux(mem_read_MEM, 1'b0, ~ready, memRead_MEM_IN);
  MEM_Stage_Register mem_s_r(
    .clk(clk), 
    .rst(rst), 
    .freeze(~ready),
    .WB_en_in(is_reg_write_MEM), 
    //.MEM_R_en_in(mem_read_MEM&ready), 
    .MEM_R_en_in(memRead_MEM_IN),
    .ALU_result_in(ALU_result_MEM), 
    .MEM_read_value_in(memory_result_MEM), 
    .PC_in(PC_MEM), 
    .Instruction_in(inst_MEM), 
    .Dest_in(register_destination_MEM), 
    .WB_en(is_reg_write), 
    .MEM_R_en(mem_read_WB),
    .ALU_result(ALU_result_WB), 
    .MEM_read_value(memory_result_WB), 
    .PC(PC_WB), 
    .Instruction(inst_WB),
    .Dest(destination_WB));
  
  WB_Stage WB_Stage(
    .mem_read(mem_read_WB), 
    .ALU_result(ALU_result_WB), 
    .MEM_result(memory_result_WB), 
    .out_result(data_WB));
  
  Hazard_Unit hazard_unit(
    .forward_en(forward_en),
    .Exe_WB_EN(is_reg_write_EXE), 
    .Mem_WB_EN(is_reg_write_MEM), 
    .Two_src(two_input), 
    .EXE_MEM_R_EN(mem_read_EXE),
    .src1(first_input), 
    .src2(second_input), 
    .Exe_Dest(register_destination_EXE), 
    .Mem_Dest(register_destination_MEM),
    .hazard_Detected(hazard));

  Forwarding_Unit forwarding_unit(
    .MEM_wb_en(is_reg_write_MEM), 
    .WB_wb_en(is_reg_write), 
    .Forward_en(forward_en), 
    .src1(src1_reg), 
    .src2(src2_reg), 
    .MEM_dst(register_destination_MEM), 
    .WB_dst(destination_WB), 
    .sel_src1(sel_src1), 
    .sel_src2(sel_src2));

  assign freeze = ~ready | hazard;

endmodule