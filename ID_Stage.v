`timescale 1ns/1ns
module ID_Stage(
    input clk, rst, 
    input [31:0] instruction, 
    input [31:0] WB_data,
    input [3:0] WB_destination,
    input WB_en,
    input hazard,
    input [3:0] status_regs,
    output mem_read_out, mem_write_out, WB_en_out, branch, s_out,
    output imm_out, 
    output [3:0] EXE_cmd, dest_reg,
    output [11:0] shift_operand,
    output [23:0] signed_immediate,
    output [31:0] Val_Rn, Val_Rm,
    output [3:0] src1, src2,
    output one_src, two_src
);
  wire mem_write, condition_check_result;
  wire controller_mux_sel;
  wire [8:0] controller_out, final_control_signals;
  assign src1 = instruction[19:16];
  
  assign controller_mux_sel = hazard | (~condition_check_result);  
  assign {EXE_cmd, mem_read, mem_write, WB_en_out, branch, s_out} = final_control_signals;
  assign mem_read_out = mem_read;
  assign mem_write_out = mem_write;
  assign imm_out = instruction[25];
  assign signed_immediate = instruction[23:0];
  assign shift_operand = instruction[11:0];
  assign dest_reg = instruction[15:12];
  assign two_src = WB_en | ~imm_out;
  MUX #4 src2Mux(instruction[3:0], instruction[15:12], mem_write, src2);
  
  Register_File RegFile(clk, rst, WB_en, src1, src2, WB_destination, WB_data, Val_Rn, Val_Rm);
  Control_Unit control_unit(instruction[20], instruction[27:26], instruction[24:21], one_src,controller_out);
  Condition_Check condition_check(instruction[31:28], status_regs, condition_check_result);
  MUX #9 controller_mux(controller_out, 9'd0, controller_mux_sel, final_control_signals);

endmodule
