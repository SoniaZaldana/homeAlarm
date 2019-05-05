module clock_counter(CLOCK_50, SW, HEX0);
  input CLOCK_50;
  input [4:0] SW;
  output [6:0] HEX0;
  wire [27:0] max;
  wire pulse;
  wire [3:0] q;
  
	
  // SW[4] = enable.
  // SW[2] = par_load.
  // SW[3] = reset_n.

  choose_max c_0(
                  .in({SW[1], SW[0]}),
                  .out(max)
                  );

  rate_divider r_0(
                  .cycles(max),
                  .clk(CLOCK_50),
                  .enable(SW[4]),
                  .par_load(SW[2]),
                  .reset_n(SW[3]),
                  .pulse(pulse)
    );


  display_counter d_0(
                    .clk(CLOCK_50),
                    .enable(pulse),
                    .reset_n(SW[3]),
                    .q(q)
      );

  hexdecoder h_0(
                  .In(q),
                  .Out(HEX0)
    );

endmodule


module choose_max(in, out);
  input [1:0] in;
  output reg [27:0] out;
  always @(*)
  begin
    case (in)
        2'b00: out <= 0;
        2'b01: out <= 50000000 - 1;
        2'b10: out <= 100000000 - 1;
        2'b11: out <= 200000000 - 1;
        default: out <= 0;
    endcase
  end
endmodule

module rate_divider(cycles, clk, enable, par_load, reset_n, pulse);
  input [27:0] cycles;
  input clk, reset_n, par_load, enable;
  reg [27:0] q;
  output reg pulse;


  always @(posedge clk)
  begin
      if (reset_n == 1'b0)
          q <= cycles;
      else if (par_load == 1'b1)
          q <= cycles;
      else if (enable == 1'b1)
          begin
              if (q == 0)
                  q <= cycles;
              else
                  q <= q - 1'b1;
          end
  end

  always @(*)
  begin
  if(q == cycles)
    pulse = 1'b1;
  else
    pulse = 1'b0;
  end

endmodule



module display_counter(clk, enable, reset_n, q);
  input clk, enable, reset_n;
  output reg [3:0] q;

  always @(posedge clk)
  begin
      if (reset_n == 1'b0)
          q <= 0;
      else if (enable == 1'b1)
          begin
              if (q == 4'b1111)
                  q <= 0;
              else
                  q <= q + 1'b1;
          end
    end

endmodule

module hexdecoder(In, Out);

    input [3:0] In;

    output [6:0] Out;

    assign Out[0] = (~In[3] & ~In[2] & ~In[1] & In[0]) | (~In[3] & In[2] & ~In[1] & ~In[0]) | (In[3] & ~In[2] & In[1] & In[0]) | (In[3] & In[2] & ~In[1] & In[0]);

    assign Out[1] = (~In[3] & In[2] & ~In[1] & In[0]) | (~In[3] & In[2] & In[1] & ~In[0]) | (In[3] & ~In[2] & In[1] & In[0]) | (In[3] & In[2] & ~In[1] & ~In[0]) | (In[3] & In[2] & In[1] & ~In[0]) | (In[3] & In[2] & In[1] & In[0]);

    assign Out[2] = (~In[3] & ~In[2] & In[1] & ~In[0]) | (In[3] & In[2] & ~In[1] & ~In[0]) | (In[3] & In[2] & In[1] & ~In[0]) | (In[3] & In[2] & In[1] & In[0]);

    assign Out[3] = (~In[3] & ~In[2] & ~In[1] & In[0]) | (~In[3] & In[2] & ~In[1] & ~In[0]) | (~In[3] & In[2] & In[1] & In[0]) | (In[3] & ~In[2] & In[1] & ~In[0]) | (In[3] & In[2] & In[1] & In[0]);

    assign Out[4] = (~In[3] & ~In[2] & ~In[1] & In[0]) | (~In[3] & ~In[2] & In[1] & In[0]) | (~In[3] & In[2] & ~In[1] & ~In[0]) | (~In[3] & In[2] & ~In[1] & In[0]) | (~In[3] & In[2] & In[1] & In[0]) | (In[3] & ~In[2] & ~In[1] & In[0]);

    assign Out[5] = (~In[3] & ~In[2] & ~In[1] & In[0]) | (~In[3] & ~In[2] & In[1] & ~In[0]) | (~In[3] & ~In[2] & In[1] & In[0]) | (~In[3] & In[2] & In[1] & In[0]) | (In[3] & In[2] & ~In[1] & In[0]);

    assign Out[6] = (~In[3] & ~In[2] & ~In[1] & ~In[0]) | (~In[3] & ~In[2] & ~In[1] & In[0]) | (~In[3] & In[2] & In[1] & In[0]) | (In[3] & In[2] & ~In[1] & ~In[0]);

endmodule
