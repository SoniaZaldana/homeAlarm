module validation(clock, user_key, set_key, correct_signal, validate_en,resetn);
input [15:0] user_key, set_key;
input clock, validate_en, resetn;
output reg correct_signal;



always @(posedge clock, negedge resetn)
begin
if (!resetn)begin
	correct_signal <=1'b0;
end
else if (validate_en) begin
  if (user_key == set_key)
      correct_signal <= 1'b1;
  else
    correct_signal <= 1'b0;
end

end
endmodule
