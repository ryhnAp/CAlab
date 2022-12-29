`timescale 1ns/1ns

module Data_Memory(
  input[31:0] Add, input_data,
  input clk, MEM_read, MEM_write,
  output reg[31:0] out_data
);

  wire[31:0] temp_addr  = Add - 32'd1024;
  wire[31:0] real_addr = {2'd0, temp_addr[31:2]};

  reg[31:0] memory[0:63];

  integer i; 
  initial begin
    for(i = 0 ; i < 64 ; i = i + 1)
	    memory[i] = 32'd0; 	
  end

  always @ (posedge clk) begin
    if(MEM_write)begin
      memory[real_addr] <= input_data;
    end
  end

  always @ (MEM_read, real_addr) begin
    if(MEM_read) begin 
      out_data = memory[real_addr];
    end
  end

endmodule

