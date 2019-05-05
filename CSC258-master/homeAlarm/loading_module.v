module load_module(clock, resetn, write, digit,
                   out_keycode);

input clock, resetn, write;
input [3:0] digit;
output [15:0] out_keycode;
wire ld_0, ld_1, ld_2, ld_3;

control_load_digits c_0(.clock(clock),
                        .resetn(resetn),
                        .w(write),
                        .ld_0(ld_0),
                        .ld_1(ld_1),
                        .ld_2(ld_2),
                        .ld_3(ld_3)
                        );
datapath_load_digits d_0(.clock(clock),
                         .resetn(resetn),
                         .ld_0(ld_0),
                         .ld_1(ld_1),
                         .ld_2(ld_2),
                         .ld_3(ld_3),
                         .d_0(digit),
                         .d_1(digit),
                         .d_2(digit),
                         .d_3(digit),
                         .out_keycode(out_keycode)
                         );


endmodule


module control_load_digits(clock, resetn, w, ld_0, ld_1, ld_2, ld_3);
input clock, resetn, w;
output reg ld_0, ld_1, ld_2, ld_3;
reg [2:0] current_state;
reg [2:0]  next_state;

localparam  LOAD_DIGIT_0  	= 3'd0,
						LOAD_DIGIT_1	  = 3'd1,
						LOAD_DIGIT_2    = 3'd2,
						LOAD_DIGIT_3	  = 3'd3;
// DEPENDS ON THE CURRENT_STATE. because current_state depends on the next state
// this happens every clock cycle or whenever the signal w changes.
always @(*)
begin: state_table
    case(current_state)
    //START: begin if (w) next_state = LOAD_DIGIT_0;
    //else next_state = START;
    //end
    LOAD_DIGIT_0: begin
          if (!w) next_state = LOAD_DIGIT_0;
          else next_state = LOAD_DIGIT_1;
          end
    LOAD_DIGIT_1: begin
          if (!w) next_state = LOAD_DIGIT_1;
          else next_state = LOAD_DIGIT_2;
	  end
    LOAD_DIGIT_2: begin
          if (!w) next_state = LOAD_DIGIT_2;
          else next_state = LOAD_DIGIT_3;
          end
    LOAD_DIGIT_3: begin
          if (!w) next_state = LOAD_DIGIT_3;
          else next_state = LOAD_DIGIT_0;

          end
    default: next_state = LOAD_DIGIT_0;
    endcase
end

    always @(*)
          begin: enable_signals
          // By default make all signals 0
          ld_0 = 1'b0;
          ld_1 = 1'b0;
          ld_2 = 1'b0;
          ld_3= 1'b0;
          case (current_state)
            	LOAD_DIGIT_0: begin
                if (w)   ld_0 = 1'b1;
            	end
            	LOAD_DIGIT_1: begin
            			ld_1 = 1'b1;
            	end
              LOAD_DIGIT_2: begin
                  ld_2 = 1'b1;
              end
              LOAD_DIGIT_3: begin
                  ld_3 = 1'b1;
              end
          endcase
    end

// State Register (i.e., FFs)
  always @(posedge clock)
    begin   // Start of state_FFs (state register)
        if(resetn == 1'b0)
            current_state <= LOAD_DIGIT_0;
        else
            current_state <= next_state;
        end  // End of state_FFs (state register)

endmodule

module datapath_load_digits(resetn, clock, ld_0, ld_1, ld_2, ld_3,
                            out_keycode, d_0, d_1, d_2, d_3);
input ld_0, ld_1, ld_2, ld_3;
input clock, resetn;
input [3:0] d_0, d_1, d_2, d_3;
output reg [15:0] out_keycode;

always @(posedge clock)
begin
    if (!resetn) begin
        out_keycode <= 16'd0;
    end
    else if (ld_0) begin
        out_keycode[3:0] <= d_0;
    end
    else if (ld_1) begin
        out_keycode[7:4] <= d_1;
    end
    else if (ld_2) begin
        out_keycode[11:8] <= d_2;
    end
    else if (ld_3) begin
        out_keycode[15:12] <= d_3;
    end
end


endmodule
