`timescale 1ns/1ns
module ID_Stage(
  clk, 
  rst, 
  instruction, 
  WB_data,
  WB_en,
  WB_destination,
  hazard,
  status_regs,
  WB_en_out, 
  mem_read_out, 
  mem_write_out, 
  branch, 
  s_out,
  EXE_cmd, 
  Val_Rn, 
  Val_Rm,
  imm_out, 
  shift_operand,
  signed_immediate,
  dest_reg,
  src1, 
  src2,
  one_src, 
  two_src
);
  input clk, rst;
  input [31:0] instruction;
  input [31:0] WB_data;
  input [3:0] WB_destination;
  input WB_en;
  input hazard;
  input [3:0] status_regs;
  output mem_read_out, mem_write_out, WB_en_out, branch, s_out;
  output imm_out;
  output [3:0] EXE_cmd, dest_reg;
  output [11:0] shift_operand;
  output [23:0] signed_immediate;
  output [31:0] Val_Rn, Val_Rm;
  output [3:0] src1, src2;
  output one_src, two_src;

  wire mem_write, condition_check_result;
  wire controller_mux_sel;
  wire [8:0] controller_out, final_control_signals;
  
  assign src1 = instruction[19:16];
  
  MUX #(.len(4)) src2Mux(.in0(instruction[3:0]), .in1(instruction[15:12]), .sel(mem_write), .out(src2)); //ID_registerfile_mux_in Register_File reg_file(clk, rst, WB_en, src1, src2, WB_destination, WB_data, Val_Rn, Val_Rm);

  Register_File reg_file(.clk(clk), .rst(rst), .reg_write(WB_en), .src1(src1), .src2(src2), .reg_dest(WB_destination), .data(WB_data), .reg1(Val_Rn), .reg2(Val_Rm));

  Control_Unit control_unit(.S(instruction[20]), .mode(instruction[27:26]), .opcode(instruction[24:21]), 
    .one_input(one_src), .controllerOutput(controller_out));

  Condition_Check condition_check(.cond(instruction[31:28]), .status_regs(status_regs), .cond_res(condition_check_result));

  assign controller_mux_sel = (~condition_check_result) | hazard;  
  MUX #(.len(9)) controller_mux(.in0(controller_out), .in1(9'd0), .sel(controller_mux_sel), .out(final_control_signals));

  assign {EXE_cmd, mem_read, mem_write, WB_en_out, branch, s_out} = final_control_signals;
  assign mem_read_out = mem_read;
  assign mem_write_out = mem_write;

  assign imm_out = instruction[25];
  assign shift_operand = instruction[11:0];
  assign signed_immediate = instruction[23:0];
  assign dest_reg = instruction[15:12]; // Register destination
  assign two_src = ~imm_out | WB_en;

endmodule