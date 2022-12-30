`timescale 1ns/1ns
module SRAM_Controller(
    input clk, rst,
    // from memory stage
    input write_en, read_en,
    input [31 : 0] address, 
    input [31 : 0] writeData,
    // to next stage
    output [31 : 0] read_data,
    // for freezing other stages
    output ready,

    inout [15:0] SRAM_DQ,
    output [17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);

    wire [2 : 0] cnt;
    reg [1 : 0] ps, ns;
    reg cnt_enable;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'd0;

    assign ready = ~(read_en || write_en) ? 1'b1 : (cnt == 3'b101);

    Counter3bit cnt3bit(clk, rst, cnt_enable, cnt);

    assign SRAM_WE_N = write_en ? ~(cnt == 3'b001 || cnt == 3'b010) : 1'b1;
    assign SRAM_WE_N = read_en ? (cnt == 3'b001 || cnt == 3'b010) : 1'b0; 

    wire[31:0] real_addr  = address - 32'd1024;
    assign SRAM_ADDR = (cnt == 3'b001) ?  {real_addr[18 : 2], 1'b0}  :  (cnt == 3'b010) ? {real_addr[18 : 2], 1'b0} + 18'd1 : 18'bz;

    assign SRAM_DQ = (write_en) ? ((cnt == 3'b001) ? {writeData[15:0]} : ((cnt == 3'b010) ? {writeData[31:16]} : 16'bz)) : 16'bz;

    wire [15:0] read_data_low_temp, read_data_low;
    wire [31:0] read_data_temp;
    assign read_data_low_temp = (cnt == 3'b001) ? SRAM_DQ : 16'bz;
    register #16 read_data_reg(clk, rst, 1'b0, read_data_low_temp, read_data_low);
    assign read_data_temp = (cnt == 3'b010) ? {SRAM_DQ,  read_data_low} : 32'bz;

    wire ld = ~(cnt == 3'b010);
    register #32 read_data_reg2(clk, rst, ld, read_data_temp, read_data);

    parameter [1 : 0] IDLE = 2'b0, READ = 2'b01, WRITE = 2'b10;

    always @(*) begin
      cnt_enable = 1'b0;
        case (ps)
            IDLE: begin
                if (read_en)
                    ns = READ;
                else if (write_en)
                    ns = WRITE;
                else
                    ns = IDLE;
            end

            READ: begin
              cnt_enable = 1'b1;
                if (cnt != 3'b101)
                    ns = READ;
                else
                    ns = IDLE;
            end

            WRITE: begin
              cnt_enable = 1'b1;
                if (cnt != 3'b101)
                        ns = WRITE;
                    else
                        ns = IDLE;
            end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= 3'b0;
        else
            ps <= ns;
    end
endmodule