`timescale 1ns/1ns
module MEM_Stage_Register(
  clk, 
  rst, 
  WB_en_in, 
  MEM_R_en_in, 
  ALU_result_in, 
  MEM_read_value_in, 
  PC_in, 
  Instruction_in, 
  Dest_in, 
  WB_en, 
  MEM_R_en,
  ALU_result, 
  MEM_read_value, 
  PC, 
  Instruction,
  Dest
);
  input clk, rst, WB_en_in, MEM_R_en_in;
  input [31 : 0] ALU_result_in, MEM_read_value_in, PC_in, Instruction_in;
  input [3 : 0] Dest_in;
  output reg WB_en, MEM_R_en;
  output reg [31 : 0] ALU_result, MEM_read_value, PC, Instruction;
  output reg [3 : 0] Dest;

  always @(posedge clk, posedge rst)begin
    if(rst) begin
      PC <= 32'd0;
      Instruction <= 32'd0;
      MEM_read_value <= 32'd0;
      ALU_result <= 32'd0;
      WB_en <= 1'd0;
      MEM_R_en <= 1'd0;
      Dest <= 4'd0;
    end
    else begin
      PC <= PC_in;
      Instruction <= Instruction_in;
      MEM_read_value <= MEM_read_value_in;
      ALU_result <= ALU_result_in;
      WB_en <= WB_en_in;
      MEM_R_en <= MEM_R_en_in;
      Dest <= Dest_in;
    end
  end
endmodule