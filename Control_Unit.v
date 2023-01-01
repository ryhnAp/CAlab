`timescale 1ns/1ns
module Control_Unit(
  S,
  mode,
  opcode,
  one_input,
  controllerOutput
);
  input S;
  input [1 : 0] mode;
  input [3 : 0] opcode;
  output one_input;
  output [8 : 0] controllerOutput;

  parameter [1 : 0]
      COMPUTE=2'b00, MEMORY=2'b01, BRANCH=2'b10;
  parameter [3 : 0] 
      MOV=4'b1101, 
      MVN=4'b1111, 
      ADD=4'b0100, 
      ADC=4'b0101, 
      SUB=4'b0010, 
      SBC=4'b0110, 
      AND=4'b0000, 
      ORR=4'b1100, 
      EOR=4'b0001, 
      CMP=4'b1010, 
      TST=4'b1000, 
      LDR_STR=4'b0100;

  reg WB_enable, branch_enable, mem_read, mem_write;
  reg [3 : 0] alu_exe_cmd; //ALU execute command
  
  always @(*) begin
    {alu_exe_cmd, WB_enable, branch_enable, mem_read, mem_write} = 0;
    case(mode)
      COMPUTE: 
      begin
        case(opcode)
        MOV: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0001;
        end
        MVN: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b1001;
        end
        ADD: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0010;
        end
        ADC: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0011;
        end
        SUB: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0100;
        end
        SBC: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0101;
        end
        AND: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0110;
        end
        ORR: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b0111;
        end
        EOR: 
        begin
          WB_enable = 1;
          alu_exe_cmd = 4'b1000;
        end
        CMP:
          alu_exe_cmd = 4'b0100;
        TST:
          alu_exe_cmd = 4'b0110;
        endcase
      end

      MEMORY: 
      begin
        alu_exe_cmd = 4'b0010;
        mem_read = S; //LDR
        WB_enable = S; //LDR
        mem_write = ~S; //STR
      end

      BRANCH: branch_enable = 1'b1;

    endcase
  end

  assign status_out = branch_enable ? 1'b0 : S;
  assign controllerOutput = {alu_exe_cmd, mem_read, mem_write, WB_enable, branch_enable, status_out};
  assign one_input = ~((alu_exe_cmd == 4'b0001) || (alu_exe_cmd == 4'b1001) || branch_enable);
  
endmodule