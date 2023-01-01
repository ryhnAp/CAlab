`timescale 1ns/1ns
module Status_Register(
  clk, 
  rst, 
  load, 
  status_in, 
  status
);
  parameter len = 4;

  input clk, rst, load;
  input [len-1 : 0] status_in;
  output reg[len-1 : 0] status;

  always@(negedge clk, posedge rst) begin
    if(rst) begin
      status <= 4'b0;
    end
    else if(load) begin
      status <= status_in;
    end
    else begin
      status <= status;
    end
  end

endmodule