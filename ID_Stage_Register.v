`timescale 1ns/1ns

module ID_Stage_Register(
    input clk, rst,freeze, flush,
    input WB_en_in, mem_write_in, mem_read_in, 
    input imm_in, branch_in, s_in, carry_bit_in,
    input[3:0] EXE_cmd_in, dest_in,
    input[11:0] shift_operand_in, 
    input[23:0] signed_imm_in,
    input[31:0] pc_in, Val_Rn_in, Val_Rm_in, instruction_in,
    input[3:0] first_input, second_input,
    
    output reg WB_en_out, mem_write_out, mem_read_out, 
    output reg imm_out, branch_out, s_out, carry_bit_out,
    output reg[3:0] EXE_cmd_out, dest_out,
    output reg[11:0] shift_operand_out, 
    output reg[23:0] signed_imm_out,
    output reg[31:0] pc_out, Val_Rn_out, Val_Rm_out, instruction_out,
    output reg[3:0] src1_reg, src2_reg
);

  always@(posedge clk, posedge rst) begin
    if(rst || flush) begin
      {WB_en_out, mem_write_out, mem_read_out, imm_out, branch_out, s_out, carry_bit_out} <= 8'd0;
      {EXE_cmd_out, dest_out} <= 8'd0;
      shift_operand_out <= 12'd0;
      signed_imm_out <= 24'd0;
      {pc_out, Val_Rn_out, Val_Rm_out, instruction_out} <= 128'd0;
    end
    else if(~freeze) begin
        WB_en_out <= WB_en_in; 
        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;
        imm_out <= imm_in;
        branch_out <= branch_in;
        s_out <= s_in; 
        EXE_cmd_out <= EXE_cmd_in;
        dest_out <= dest_in;
        shift_operand_out <= shift_operand_in; 
        signed_imm_out <= signed_imm_in;
        pc_out <= pc_in;
        Val_Rn_out <= Val_Rn_in;
        Val_Rm_out <= Val_Rm_in;
        instruction_out <= instruction_in;
        carry_bit_out <= carry_bit_in;
        src1_reg <= first_input;
        src2_reg <= second_input;
    end
  end
endmodule




