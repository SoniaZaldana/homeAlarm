module laser_detector(out, in, clock);
input in, clock;
output reg out;

always @(posedge clock)
begin
    out <= in;
end

endmodule
