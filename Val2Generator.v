`timescale 1ns/1ns
module Val2Generator(
  shifter_operand,
  I, 
  mem_en, 
  val_Rm, 
  out
);
  input [11 : 0] shifter_operand;
  input I, mem_en;
  input [31 : 0] val_Rm;
  output reg [31 : 0] out;

  parameter [1 : 0]
      LSL=2'b00, LSR=2'b01, ASR=2'b10, ROR=2'b11;
  
  reg[31:0] rotate_out;
  wire[3:0] rotate_imm;
  assign rotate_imm = shifter_operand[11:8];
  integer i;

  always@(*) begin
    
    if(mem_en) // MEM_CMD == 1'b1
      out = {{20{shifter_operand[11]}}, shifter_operand};
    else if(I) begin // page 7, 32 bit immidiate
      rotate_out = {24'd0, shifter_operand[7 : 0]};
      for (i = 0 ; i < {rotate_imm, 1'd0} ; i = i + 1) begin //duplicate
        rotate_out = {rotate_out[0], rotate_out[31:1]};
      end
      out = rotate_out;
    end
    
    else begin // imm == 1'b0
      case (shifter_operand[6:5])
        LSL: out = val_Rm << shifter_operand[11:7]; 
        LSR: out = val_Rm >> shifter_operand[11:7];
        ASR: out = val_Rm >>> shifter_operand[11:7];
        ROR: begin
          out = val_Rm; 
          for ( i = 0 ; i < shifter_operand[11:7] ; i = i + 1) begin
            out = {out[0],out[31:1]};
          end
        end
      endcase
    end
    
  end
endmodule