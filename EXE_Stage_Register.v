`timescale 1ns/1ns

module EXE_Stage_Register(
    input clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in, 
    input[31:0] ALU_result_in, Val_Rm_in, PC_in, Instruction_in, 
    input[3:0] Dest_in, 
    output reg WB_en, MEM_R_EN, MEM_W_EN, 
    output reg[31:0] ALU_result, Val_Rm, PC, Instruction, 
    output reg[3:0] Dest
);

  always @(posedge clk, posedge rst)begin
    if(rst) begin
      PC <= 32'd0;
      Instruction <= 32'd0;
      Dest <= 4'd0;
      WB_en <= 1'd0;
      MEM_R_EN <= 1'd0; 
      MEM_W_EN <= 1'd0;
      ALU_result <= 32'd0;
      Val_Rm <= 32'd0;
    end
    else begin
      PC <= PC_in;
      Instruction <= Instruction_in;
      Dest <= Dest_in;
      WB_en <= WB_en_in;
      MEM_R_EN <= MEM_R_EN_in;
      MEM_W_EN <= MEM_W_EN_in;
      ALU_result <= ALU_result_in;
      Val_Rm <= Val_Rm_in;
    end
  end
endmodule


