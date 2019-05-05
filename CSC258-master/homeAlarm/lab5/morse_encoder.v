module morse_encoder(CLOCK_50, SW, KEY, LEDR);
  input [2:0] SW;
  input [1:0] KEY;
  input CLOCK_50;
  output [0:0]LEDR;
  wire [13:0] binary_morse;
  wire [27:0] cycle_value;
  wire pulse;
  wire bit_out;

  // KEY[0] = reset_n
  // KEY[1] = load

  mux7to1 m_0(
              .in(SW[2:0]),
              .out(binary_morse)
    );

//  assign cycle_value = 27'b001011111010111100000111111;
  assign cycle_value = 25_000_000 - 1;

  rate_divider r_0(
                  .cycles(cycle_value),
                  .clk(CLOCK_50),
                  .en(1),
                  .reset_n(KEY[0]),
                  .pulse(pulse)
    );

    shift s_0(
              .morse(binary_morse),
              .clk(CLOCK_50),
              .reset_n(KEY[0]),
              .par_load(KEY[1]),
              .en(pulse),
              .out(LEDR[0])
      );

     // assign LEDR[0] = bit_out;

endmodule

module shift(morse, clk, reset_n, par_load, en, out);
  input [13:0] morse;
  input clk, en, reset_n, par_load;
  output reg out;
  reg [13:0] temp;

  always @(posedge clk)
  begin
  if (reset_n == 1'b0)
    temp <= 14'b00000000000000;
  else if (par_load == 1'b1)
    temp <= morse;
  else if (en == 1'b1)
    begin
      out <= temp[13];
		temp <= temp << 1;
//      temp <= {temp[12:0],1'b0};
    end
  end

endmodule

module mux7to1(in, out);
  input [2:0] in;
  output reg [13:0] out;
  always @(*)
  begin
      case(in)
          0: out = 14'b10101000000000; // S
          1: out = 14'b11100000000000; // T
          2: out = 14'b10101110000000; // U
          3: out = 14'b10101011100000; // V
          4: out = 14'b10111011100000; // W
          5: out = 14'b11101010111000; // X
          6: out = 14'b11101011101110; // Y
          7: out = 14'b11101110101000; // Z
      endcase
end

endmodule

module rate_divider(cycles, clk, en, reset_n, pulse);
  input [27:0] cycles;
  input clk, reset_n, en;
  wire [27:0] cycles;
  reg [27:0] q;
  output reg pulse;


  always @(posedge clk)
  begin
      if (reset_n == 1'b0)
          q <= cycles;
      else if (en == 1'b1)
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
