`timescale 1ns/1ns
module ALU(
  op1, 
  op2,
  carry,
  exe_cmd,
  ALU_Res,
  Status_Bits
);
  parameter size = 32;
  parameter op_size = 4; //operation

  input carry;
  input [size-1 : 0] op1, op2;
  input [op_size-1 : 0] exe_cmd;
  output [size-1 : 0] ALU_Res;
  output [op_size-1 : 0] Status_Bits;

  reg v_, c_;
  wire n_, z_;
  reg [size : 0] temp;

  always@(*)begin
    {v_, c_} = 2'b00;
    case(exe_cmd)
      4'b0001: begin //mov
        temp = op2;
      end
      4'b1001: begin //mvn
        temp = ~op2;
      end
      4'b0010: begin //add & ldr & str
        temp = op1 + op2;
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0011: begin //adc
        temp = op1 + op2 + carry;
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0100: begin //sub & cmp
        temp = {op1[31],op1} - {op2[31],op2};
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
      end
      4'b0101: begin //sbc
        if(carry) temp = op1 - op2;
        else temp = op1 - op2 - 1'b1;
       
        c_ = temp[32];
        v_ = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
      end
      4'b0110: begin //and & tst
        temp = op1 & op2;
      end
      4'b0111: begin //orr
        temp = op1 | op2;
      end
      4'b1000: begin //eor
        temp = op1 ^ op2;
      end
    endcase
  end

  assign n_ = ALU_Res[31];
  assign z_ = ALU_Res == 32'b0;
  assign ALU_Res = temp[31:0];
  assign Status_Bits = {n_, z_, c_, v_};

endmodule