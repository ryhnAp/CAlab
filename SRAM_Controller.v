`timescale 1ns/1ns
module SRAM_Controller(
    clk, 
    rst,
    write_en, 
    read_en,
    address, 
    writeData,
    read_data,
    ready,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,
    SRAM_LB_N,
    SRAM_WE_N,
    SRAM_CE_N,
    SRAM_OE_N
);
    input clk, rst;
    // from memory block stage 
    input write_en, read_en;
    input [31 : 0] address;
    input [31 : 0] writeData;
    inout [15 : 0] SRAM_DQ; // SRAM data bus 16 bits
    output [31 : 0] read_data; // to wb stage
    output ready;// for freezing other stages using sram ready and hazard in arm
    output [17 : 0] SRAM_ADDR; // SRAM address bus 18 bits
    //active low
    output SRAM_UB_N; // SRAM high-byte data mask
    output SRAM_LB_N; // SRAM low-byte data mask
    output SRAM_WE_N; // SRAM write enable
    output SRAM_CE_N; // SRAM chip enable
    output SRAM_OE_N; // SRAM output enable

    wire [15:0] read_data_low_temp, read_data_low;
    wire [31:0] read_data_temp;
    
    wire [2 : 0] cnt;
    reg [1 : 0] ps, ns;
    reg cnt_enable;

    parameter [2 : 0]
        cycles = 3'b101, low = 3'b001, high = 3'b010;
    parameter [1 : 0] 
        IDLE = 2'b0, READ = 2'b01, WRITE = 2'b10;

    wire[31:0] converted_addr  = address - 32'd1024;

    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'd0; // all of them should be active recording to pag3 par1

    assign ready = ~(read_en || write_en) ? 1'b1 : (cnt == cycles); //if we don't use mem for reading or writing, it is ready to use, otherwise we should wait 6 clk cycles so we check counter for using it 

    Counter cnt3bit6cycle(.clk(clk), .rst(rst), .cnt_en(cnt_enable), .cnt(cnt));

    assign SRAM_WE_N = write_en ? ~(cnt == low || cnt == high) : 1'b1; //if purpose of using mem is to write on it, we should active it(active low) in 1&2 clk cycles(due to 16 of 32 bits)
    assign SRAM_WE_N = read_en ? (cnt == low || cnt == high) : 1'b0; //when we dont read from mem, it should be active, otherwise if we read on 1/2 clk cuz we need to read addr and next addr(other 16 bit) so we shouldnt active it(make high imp)

    assign SRAM_ADDR = (cnt == low) ?  {converted_addr[18 : 2], 1'b0}  :  (cnt == high) ? {converted_addr[18 : 2], 1'b0} + 18'd1 : 18'bz;

    assign SRAM_DQ = (write_en) ? ((cnt == low) ? {writeData[15:0]} // clk 1->low, clk 2_>high
                            : ((cnt == high) ? {writeData[31:16]} : 16'bz)) : 16'bz;

    assign read_data_low_temp = (cnt == low) ? SRAM_DQ : 16'bz;
    register #(.len(16)) read_data_low_reg(.clk(clk), .rst(rst), .ld(1'b0), .in(read_data_low_temp), .out(read_data_low)); // reg for data bits attachment
    assign read_data_temp = (cnt == high) ? {SRAM_DQ,  read_data_low} : 32'bz;

    wire ld = ~(cnt == high);
    register #(.len(32)) read_data_comp_reg(.clk(clk), .rst(rst), .ld(ld), .in(read_data_temp), .out(read_data));

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= 3'b0;
        else
            ps <= ns;
    end

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
                if (cnt != cycles)
                    ns = READ;
                else
                    ns = IDLE;
            end
            WRITE: begin
                cnt_enable = 1'b1;
                if (cnt != cycles)
                        ns = WRITE;
                    else
                        ns = IDLE;
            end
        endcase
    end

endmodule