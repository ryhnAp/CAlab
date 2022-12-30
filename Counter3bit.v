module Counter3bit(input clk, rst, cnt_en, output reg[2:0] cnt);
  always @(posedge clk, posedge rst) begin
    if (rst)
        cnt <= 3'b0;
      else if (cnt_en) begin
        if (cnt == 3'b101 + 1)
            cnt <= 3'b0;
        else
            cnt <= cnt + 1;
      end
  end
endmodule