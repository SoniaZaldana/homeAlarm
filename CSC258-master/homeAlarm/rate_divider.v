module rate_divider(cycles, clock, rate_en, reset_n, pulse);
input [28:0] cycles;
input clock, reset_n, rate_en;
reg [28:0] q;
output reg pulse;

always @(posedge clock)
begin
if ((reset_n == 1'b0) || (rate_en == 1'b0))
begin
    q <= cycles;
end
else if (rate_en == 1'b1)
    begin
        if (q == 0)
            q <= cycles;
        else
            q <= q - 1'b1;
        end

end

always @(*)
begin
if (q == 0)
    pulse = 1'b1;
else
    pulse = 1'b0;
end

endmodule
