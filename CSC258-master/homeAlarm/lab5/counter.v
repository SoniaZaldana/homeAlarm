module counter(SW, KEY, HEX0, HEX1);
input [0:0] KEY;
input [1:0] SW;
output [6:0] HEX0, HEX1;
wire [7:0] q;

initialize c_0(
            .en(SW[1]),
            .clk(KEY[0]),
            .clear_b(SW[0]),
            .q(q)
  );

hexdecoder h_0(
              .In(q[3:0]),
              .Out(HEX0[6:0])
  );

hexdecoder h_1(
              .In(q[7:4]),
              .Out(HEX1[6:0])
  );

endmodule

module initialize(en, clk, clear_b, q);
  input en, clk, clear_b;
  output [7:0]q;


  my_tff t_0(
            .clk(clk),
            .clear_b(clear_b),
            .t(en),
            .q(q[0])
            );

  my_tff t_1(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0]),
            .q(q[1])
    );


  my_tff t_2(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1]),
            .q(q[2])
    );

  my_tff t_3(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1] && q[2]),
            .q(q[3])
    );


  my_tff t_4(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1] && q[2] && q[3]),
            .q(q[4])
    );


  my_tff t_5(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1] && q[2] && q[3] && q[4]),
            .q(q[5])
    );


  my_tff t_6(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1] && q[2] && q[3] && q[4] && q[5]),
            .q(q[6])
    );


  my_tff t_7(
            .clk(clk),
            .clear_b(clear_b),
            .t(en && q[0] && q[1] && q[2] && q[3] && q[4] && q[5] && q[6]),
            .q(q[7])
    );

endmodule


module my_tff (clk, clear_b, t, q);

    input t, clk, clear_b;

    output reg q;


    always @(posedge clk, negedge clear_b)

    begin

        if (~clear_b)

            q<= 1'b0;

        else

            q<= q ^ t;

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
