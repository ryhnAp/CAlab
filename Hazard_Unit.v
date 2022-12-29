`timescale 1ns/1ns

module Hazard_Unit(
    input Exe_WB_EN, Mem_WB_EN, Two_src, EXE_MEM_R_EN,
    input[3:0] src1, src2, Exe_Dest, Mem_Dest,
    output reg hazard_Detected
);

  always @(*) begin
    hazard_Detected = 1'b0;
        if ((Exe_WB_EN == 1'b1) && (src1 == Exe_Dest))
            hazard_Detected = 1'b1;
        else if ((Mem_WB_EN == 1'b1) && (src1 == Mem_Dest))
            hazard_Detected = 1'b1;
        else if ((Exe_WB_EN == 1'b1) && (src2 == Exe_Dest) && (Two_src == 1'b1)) 
            hazard_Detected = 1'b1;
        else if ((Mem_WB_EN == 1'b1) && (src2 == Mem_Dest) && (Two_src == 1'b1)) 
            hazard_Detected = 1'b1;
    end

  
endmodule
