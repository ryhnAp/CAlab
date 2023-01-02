`timescale 1ns/1ns
module EXE_Stage_Register(
  clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in, 
  ALU_result_in, ST_val_in, PC_in, Instruction_in, 
  Dest_in, 
  WB_en, MEM_R_EN, MEM_W_EN, 
  ALU_result, ST_val, PC, Instruction, 
  Dest
);
  input clk, rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in;
  input [31 : 0] ALU_result_in, ST_val_in, PC_in, Instruction_in;
  input [3 : 0] Dest_in;
  output reg WB_en, MEM_R_EN, MEM_W_EN;
  output reg [31 : 0] ALU_result, ST_val, PC, Instruction;
  output reg [3 : 0] Dest;

  always @(posedge clk, posedge rst)begin
    if(rst) begin
      PC <= 32'd0;
      Instruction <= 32'd0;
      Dest <= 4'd0;
      WB_en <= 1'd0;
      MEM_R_EN <= 1'd0; 
      MEM_W_EN <= 1'd0;
      ALU_result <= 32'd0;
      ST_val <= 32'd0;
    end
    else begin
      PC <= PC_in;
      Instruction <= Instruction_in;
      Dest <= Dest_in;
      WB_en <= WB_en_in;
      MEM_R_EN <= MEM_R_EN_in;
      MEM_W_EN <= MEM_W_EN_in;
      ALU_result <= ALU_result_in;
      ST_val <= ST_val_in; // val Rm
    end
  end
endmodule