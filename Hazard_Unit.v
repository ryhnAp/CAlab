`timescale 1ns/1ns

module Hazard_Unit(
    input Exe_WB_EN, Mem_WB_EN, Two_src, Forward_en, EXE_MEM_R_EN,
    input[3:0] src1, src2, Exe_Dest, Mem_Dest,
    output reg hazard_Detected
);

  always @(*) begin
        hazard_Detected = 1'b0;
        if (Forward_en == 1'b0) begin
            if ((Exe_WB_EN == 1'b1) && (src1 == Exe_Dest))
                hazard_Detected = 1'b1;
            else if ((Mem_WB_EN == 1'b1) && (src1 == Mem_Dest))
                hazard_Detected = 1'b1;
            else if ((Exe_WB_EN == 1'b1) && (src2 == Exe_Dest) && (Two_src == 1'b1)) 
                hazard_Detected = 1'b1;
            else if ((Mem_WB_EN == 1'b1) && (src2 == Mem_Dest) && (Two_src == 1'b1)) 
                hazard_Detected = 1'b1;
        end
        else if (Forward_en == 1'b1) begin 
            if ((EXE_MEM_R_EN == 1'b1) && (Exe_WB_EN == 1'b1) && (src1 == Exe_Dest)) 
                hazard_Detected = 1'b1;
            else if ((EXE_MEM_R_EN == 1'b1) && (Exe_WB_EN == 1'b1) && (src2 == Exe_Dest) && (Two_src == 1'b1)) 
                hazard_Detected = 1'b1;
        end
    end

  
endmodule

