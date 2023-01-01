`timescale 1ns/1ns
module Condition_Check(
  cond, 
  status_regs, 
  cond_res
);
  parameter op_size = 4;

  input [op_size-1 : 0]cond, status_regs; 
  output reg cond_res;

  wire N_, Z_, C_, V_;
  assign {N_, Z_, C_, V_} = status_regs;
  always@(*) begin
    cond_res = 1'b0;
    case(cond)
    4'b0000: if(Z_) cond_res = 1'b1;
    4'b0001: if(~Z_) cond_res = 1'b1;
    4'b0010: if(C_) cond_res = 1'b1;
    4'b0011: if(~C_) cond_res = 1'b1;
    4'b0100: if(N_) cond_res = 1'b1;
    4'b0101: if(~N_) cond_res = 1'b1;
    4'b0110: if(V_) cond_res = 1'b1;
    4'b0111: if(~V_) cond_res = 1'b1;
    4'b1000: if(C_ && ~Z_) cond_res = 1'b1;
    4'b1001: if(~C_ || Z_) cond_res = 1'b1;
    4'b1010: if(N_ == V_) cond_res = 1'b1;
    4'b1011: if(N_ != V_) cond_res = 1'b1;
    4'b1100: if(~Z_ && N_ == V_) cond_res = 1'b1;
    4'b1101: if(Z_ && N_ != V_) cond_res = 1'b1;
    4'b1110: cond_res = 1'b1;
    endcase
  end

endmodule