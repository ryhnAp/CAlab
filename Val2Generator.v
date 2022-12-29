`timescale 1ns/1ns

module Val2Generator(
  input[11:0] shifter_operand,
  input I, mem_en, 
  input[31:0] val_Rm, 
  output reg[31:0] out
);

  reg[31:0] rotate_out;
  wire[3:0] rotate_imm;
  assign rotate_imm = shifter_operand[11:8];
  integer i;
  always@(*) begin
    
    if(mem_en)
      out = {20'd0, shifter_operand};
    else if(I) begin
      rotate_out = {24'd0, shifter_operand[7:0]};
      for (i = 0 ; i < {rotate_imm, 1'd0} ; i = i + 1) begin //2 barabar
        rotate_out = {rotate_out[0], rotate_out[31:1]};
      end
      out = rotate_out;
    end
    
    else begin
      case (shifter_operand[6:5])
        2'b00: begin //LSL
          out = val_Rm << shifter_operand[11:7]; 
        end
        2'b01: begin //LSR
          out = val_Rm >> shifter_operand[11:7];
        end
        2'b10: begin //ASR
          out = val_Rm >>> shifter_operand[11:7];
        end
        2'b11: begin //ROR
          out = val_Rm; 
          for ( i = 0 ; i < shifter_operand[11:7] ; i = i + 1) begin
            out = {out[0],out[31:1]};
          end
        end
      endcase
    end
  end
endmodule
