`timescale 1ns/1ns

module IF_Stage_Register (
    input clk, rst, freeze, flush,
    input [31:0] pc_in, instruction_in,
    output reg [31:0] pc, instruction
);

  always@(posedge clk,  posedge rst) begin
    if (rst) begin 
      instruction <= 32'd0;
      pc <= 32'd0;
    end
    else if (~freeze) begin
      if (flush) begin
        pc <= 32'd0;
        instruction <= 32'd0;
      end
      else begin
        pc <= pc_in;
        instruction <= instruction_in;
      end
    end
  end
endmodule