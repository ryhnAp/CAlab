`timescale 1ns/1ns
module Data_Memory(
  Add, 
  input_data,
  clk, 
  MEM_read, 
  MEM_write,
  out_data
);
  parameter mem_size = 64;
  parameter len = 32;

  input [len-1 : 0] Add, input_data;
  input clk, MEM_read, MEM_write;
  output reg [len-1 : 0] out_data;

  wire [len-1 : 0] temp_addr  = Add - 32'd1024;
  wire [len-1 : 0] real_addr = {2'd0, temp_addr[31:2]};

  reg [len-1 : 0] memory [0 : mem_size];

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

