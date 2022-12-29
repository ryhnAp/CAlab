`timescale 1ns/1ns

module Control_Unit(
  input S,
  input [1:0] mode,
  input [3:0] opcode,
  output one_input,
  output [8:0] controllerOutput
);

  reg regWrite, branch, memRead, memWrite;
  reg[3:0] ALU_command;
  
  always @(*) begin
    {ALU_command, memRead, memWrite, regWrite, branch} = 8'd0;

    case(mode)
      2'b01: begin
        if(S) begin  // LDR
          ALU_command = 4'b0010;
          memRead = 1'b1;
          regWrite = 1'b1;
        end
        else begin   // STR
          ALU_command = 4'b0010;
          memWrite = 1'b1;
        end
    end

    2'b10: branch = 1'b1;

    2'b00: begin
      case(opcode)
      4'b1101: begin  // MOV
        regWrite = 1;
        ALU_command = 4'b0001;
      end
      4'b1111: begin  // MVN
        regWrite = 1;
        ALU_command = 4'b1001;
      end
      4'b0100: begin  // ADD
        regWrite = 1;
        ALU_command = 4'b0010;
      end
      4'b0101: begin  // ADC
        regWrite = 1;
        ALU_command = 4'b0011;
      end
      4'b0010: begin  // SUB
        regWrite = 1;
        ALU_command = 4'b0100;
      end
      4'b0110: begin  // SBC
        regWrite = 1;
        ALU_command = 4'b0101;
      end
      4'b0000: begin  // AND
        regWrite = 1;
        ALU_command = 4'b0110;
      end
      4'b1100: begin  // ORR
        regWrite = 1;
        ALU_command = 4'b0111;
      end
      4'b0001: begin  // EOR
        regWrite = 1;
        ALU_command = 4'b1000;
      end
      4'b1010:   // CMP
        ALU_command = 4'b0100;
      4'b1000:   // TST
        ALU_command = 4'b0110;
      endcase
    end
    endcase
  end

  assign status_out = branch ? 1'b0 : S;
  assign controllerOutput = {ALU_command, memRead, memWrite, regWrite, branch, status_out};
  assign one_input = ~((ALU_command == 4'b0001) || (ALU_command == 4'b1001) || branch);
  
endmodule