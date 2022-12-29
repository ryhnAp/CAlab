`timescale 1ns/1ns

module ALU(
  input[31:0] op1, op2,
  input carry,
  input[3:0] exe_cmd,
  output[31:0] ALU_Res,
  output[3:0] Status_Bits
);

  reg v, c;
  wire n, z;
  reg [32:0] temp;
  assign n = ALU_Res[31];
  assign z = ALU_Res == 32'b0;
  assign ALU_Res = temp[31:0];
  assign Status_Bits = {n, z, c, v};

  always@(*)begin
    {v, c} = 2'b00;
    case(exe_cmd)
      4'b0001: begin //mov
        temp = op2;
      end
      4'b1001: begin //mvn
        temp = ~op2;
      end
      4'b0010: begin //add & ldr & str
        temp = op1 + op2;
        c = temp[32];
        v = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0011: begin //adc
        temp = op1 + op2 + carry;
        c = temp[32];
        v = (temp[31] ^ op1[31]) & (op1[31] ~^ op2[31]);
      end
      4'b0100: begin //sub & cmp
        temp = {op1[31],op1} - {op2[31],op2};
        c = temp[32];
        v = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
      end
      4'b0101: begin //sbc
        if(carry) temp = op1 - op2;
        else temp = op1 - op2 - 1'b1;
       
        c = temp[32];
        v = (temp[31] ^ op1[31]) & (op1[31] ^ op2[31]);
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
endmodule