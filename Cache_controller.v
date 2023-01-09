`timescale 1ns / 1ns 

module cache_controller (input clk,rst, mem_write_en,mem_read_en, SRAM_ready, cache_hit,
    input[31:0] address, write_data,cache_read_data,input [63:0] SRAM_read_data,
    output ready, cache_write_en, cache_read_en, SRAM_write_en, SRAM_read_en,invalid,
    output [16:0] cache_address, output [31:0] SRAM_address, SRAM_write_data,output  [31:0]  read_data, output [63:0] cache_write_data );
    
    reg [1:0] ps,ns ;
    parameter IDLE = 2'b00 , MISS = 2'b01 , WRITE = 2'b10;

    wire [31:0] real_addr;

    assign real_addr  = {address[31:2], 2'b00} - 32'd1024;
    assign cache_address = real_addr[18:2];
    //assign cache_address = address[17:2];
    assign SRAM_address  = address;

    assign SRAM_write_en = (ps == WRITE);
    assign SRAM_read_en = (ps == MISS); //You changed this from write to miss and half the registers became z but the rest are correct
    assign cache_read_en = (ps == IDLE) && mem_read_en;
    assign cache_write_en = (ps == MISS && SRAM_ready);
    assign SRAM_Write_Data  = SRAM_write_en ? write_data : 32'b0;
    assign cache_write_data = ((ps == MISS) && SRAM_ready) ? SRAM_read_data : 64'b0;
    assign invalid = (ps == IDLE) && mem_write_en;
    //assign invalid = (ps == IDLE && ns == WRITE);
    assign ready =  (~mem_write_en && ~mem_read_en) || ((ps == MISS) && SRAM_ready) || ((ps == IDLE) && mem_read_en && cache_hit) || ((ps == WRITE) && SRAM_ready);
    //assign ready = (ns == IDLE);
    assign read_data = ((ps == IDLE) && mem_read_en && cache_hit) ? cache_read_data : 
                      (((ps == MISS) && SRAM_ready) ? (cache_address [0] ? SRAM_read_data[63:32] : SRAM_read_data[31:0]) : 32'b0); 
    /*
    wire is_read_ok, is_miss, is_in_sram_read, is_in_sram_write;
    wire [31:0] real_addr;
    reg  [1 :0] ps, ns;
    parameter IDLE = 2'b00, WRITE = 2'b01, SRAM_WRITE = 2'b10;

    assign real_addr  = {address[31:2], 2'b00} - 32'd1024;
    assign cache_address = real_addr[18:2];
    assign SRAM_addr  = address;

    assign is_read_ok = (ps == IDLE) && mem_read_en && cache_hit;
    assign is_miss    = (ps == WRITE) && SRAM_ready;
    assign SRAM_write_en = (ps == SRAM_WRITE);
    assign cache_read_en = (ps == IDLE) && mem_read_en;
    assign is_in_sram_read = (ps == WRITE);
    assign is_in_sram_write = (ps == SRAM_WRITE) && SRAM_ready;
    assign cache_write_en = is_miss;
    assign SRAM_read_en   = is_in_sram_read;
    assign SRAM_Write_Data  = SRAM_write_en ? write_data : 32'b0;
    assign cache_write_data = is_miss ? SRAM_read_data : 64'b0;
    assign invalid    = (ps == IDLE) && mem_write_en;
    assign ready = (~mem_write_en && ~mem_read_en) || is_miss || is_read_ok || is_in_sram_write;
    assign read_data = is_read_ok ? cache_read_data : 
                      (is_miss ? (cache_address[0] ? SRAM_read_data[63:32] : SRAM_read_data[31:0]) : 32'b0); 
    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= IDLE;
        else
            ps <= ns;
    end

    always @(*) begin
      if(ps == IDLE) begin
        if(mem_read_en) ns = cache_hit ? IDLE : WRITE;
        else if(mem_write_en) ns = SRAM_WRITE;
        else ns = IDLE;
      end

      else if(ps == WRITE) 
        ns = SRAM_ready ? IDLE : WRITE;

      else if(ps == SRAM_WRITE) 
        ns = SRAM_ready ? IDLE : SRAM_WRITE;
    end

    always @(posedge clk, posedge rst) begin
      if(rst) 
        ps <= IDLE;
      else 
        ps <= ns;
    end
    

    always @(*)
    begin
        case (ps)
            IDLE: begin
            
            if (mem_read_en && ~cache_hit)
                ns = MISS;
            else if (mem_write_en)
                ns = WRITE;
            else
                ns = IDLE; 
            end

            MISS: begin
                if (SRAM_ready)
                    ns = IDLE;
                else
                    ns = MISS;
            end

            WRITE: begin
                if (SRAM_ready)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
        endcase
    end
    */
    always @(*) begin
      if(ps == IDLE) begin
        if(mem_read_en) ns = cache_hit ? IDLE : MISS;
        else if(mem_write_en) ns = WRITE;
        else ns = IDLE;
      end

      else if(ps == MISS) 
        ns = SRAM_ready ? IDLE : MISS;

      else if(ps == WRITE) 
        ns = SRAM_ready ? IDLE : WRITE;
    end

    always @(posedge clk, posedge rst) begin
      if(rst) 
        ps <= IDLE;
      else 
        ps <= ns;
    end
    
/*
    always @(*) begin

        read_data = 32'b0;

        if (ps == IDLE && cache_hit)

            read_data = cache_read_data;

        else 
            if (ps == MISS && SRAM_ready) begin
        
                read_data = cache_address[0] ? SRAM_read_data[63:32] : SRAM_read_data[31:0];

            end
    end

    always @(*)
    begin
        SRAM_write_data = 32'b0;
        if (ps == WRITE)
            SRAM_write_data = write_data;
    end


    always @(*)
    begin
        SRAM_address = 32'b0;
        if (ps == MISS || ps == WRITE)
            SRAM_address = address ;
    end
*/

endmodule 
