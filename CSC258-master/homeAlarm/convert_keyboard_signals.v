module convert_keyboard_signals(clock, sig_0, sig_1, sig_2, sig_3, sig_4,
                         sig_5, sig_6, sig_7, sig_8, sig_9, resetn,  digit);
input clock;
input sig_0, sig_1, sig_2, sig_3, sig_4, sig_5, sig_6;
input sig_7, sig_8, sig_9, sig_9, resetn;
output reg [3:0] digit;
reg [3:0] digit_value;

localparam  digit_0 = 4'b0000,
            digit_1 = 4'b0001,
            digit_2 = 4'b0010,
            digit_3 = 4'b0011,
            digit_4 = 4'b0100,
            digit_5 = 4'b0101,
            digit_6 = 4'b0110,
            digit_7 = 4'b0111,
            digit_8 = 4'b1000,
            digit_9 = 4'b1001;

always @(*) begin
if (sig_0)
    digit_value = digit_0;
else if (sig_1)
    digit_value = digit_1;
else if (sig_2)
    digit_value = digit_2;
else if (sig_3)
    digit_value = digit_3;
else if (sig_4)
    digit_value = digit_4;
else if (sig_5)
    digit_value = digit_5;
else if (sig_6)
    digit_value = digit_6;
else if (sig_7)
    digit_value = digit_7;
else if (sig_8)
    digit_value = digit_8;
else if (sig_9)
    digit_value = digit_9;
end


always @(*)begin
if (!resetn) begin
	digit <= 4'b0000;
	//digit_value <= 4'b0000;

end
else	digit <= digit_value;
end
	


endmodule
