module mux2to1 (input [31:0] a,b,input sel_a, sel_b, output reg [31:0] out);

    always @(a or b or sel_a or sel_b)
    begin
        out = 0;
        if (sel_a)
            out = a;
        else if (sel_b)
            out = b; 
    end
endmodule