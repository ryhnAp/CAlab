`timescale 1ns/1ns

module Condition_Check(
    input [3:0]cond, status_regs, 
    output reg result
);
  wire N, Z, C, V;
  assign {N, Z, C, V} = status_regs;
  always@(*) begin
    result = 1'b0;
    case(cond)
    4'b0000: if(Z) result = 1'b1;
    4'b0001: if(~Z) result = 1'b1;
    4'b0010: if(C) result = 1'b1;
    4'b0011: if(~C) result = 1'b1;
    4'b0100: if(N) result = 1'b1;
    4'b0101: if(~N) result = 1'b1;
    4'b0110: if(V) result = 1'b1;
    4'b0111: if(~V) result = 1'b1;
    4'b1000: if(C && ~Z) result = 1'b1;
    4'b1001: if(~C || Z) result = 1'b1;
    4'b1010: if(N == V) result = 1'b1;
    4'b1011: if(N != V) result = 1'b1;
    4'b1100: if(~Z && N == V) result = 1'b1;
    4'b1101: if(Z && N != V) result = 1'b1;
    4'b1110: result = 1'b1;
    endcase
  end
endmodule