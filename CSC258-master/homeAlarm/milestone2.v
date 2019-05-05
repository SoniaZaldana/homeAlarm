/*
Potential bugs:
digit changes again when everything moves back to 0. make sure this doesn't fuck anything up.
Fix the Hexes and LEDR
Try repeeating values: 2211
Ensure rate divider stops and resets to default whenever you enter the right password(don't make dependent on correct yet!)
See if resetting correct is necessary
*/


module milestone2(CLOCK_50, KEY, SW,PS2_CLK, PS2_DAT, LEDR, HEX0, HEX1, HEX2, HEX3, HEX5, GPIO_0);
input [11:0] SW;
input [2:0] KEY;
inout PS2_CLK;
inout PS2_DAT;
input CLOCK_50;
inout [1:0] GPIO_0;// 0 is the pin for the laser module, 1 is the pin for the buzzer
output [9:0] LEDR;
//output [1:1] GPIO_0; // output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX5;
wire d_0,d_1,d_2,d_3,d_4,d_5,d_6,d_7,d_8,d_9,enter;
wire [3:0] digit;
wire [2:0] current_state;
wire key_pressed;
wire correct, resetn;
wire register_passcode, load_user_attempt, validate_en;
wire [15:0] saved_password, attempted_password;
wire [1:0] num_attempts;

wire clock;
wire alarm_start;
wire laser_in; // This is the wire for the laser module
wire laser_out; // this is the signal the laser emits
wire rate_divider_en;
wire pulse, pulse_for_alarm;
/* This is for the rate divider to wait 5 seconds */
wire [28:0] cycles;
assign cycles = 250000000 - 1;
wire [28:0] cycles_for_alarm;
// we want lights to flash every quarter second
assign cycles_for_alarm = 6250000 -1;
//assign cycles = 5;

/* This is input value for laser */
assign laser_in = GPIO_0[0];
assign alarm_start = GPIO_0[1];
assign clock = CLOCK_50;
assign LEDR[0] = GPIO_0[0];
assign LEDR[9:8] = num_attempts;
assign resetn = KEY[0];


rate_divider rd_0(.cycles(cycles),
                  .clock(CLOCK_50),
                  .rate_en(rate_divider_en),
                  .reset_n(resetn),
                  .pulse(pulse)
                  );

rate_divider rd_1(.cycles(cycles_for_alarm),
                  .clock(CLOCK),
                  .rate_en(alarm_start),
                  .reset_n(resetn),
                  .pulse(pulse_for_alarm)
                  );

enable_lights e_l(
                    .pulse(pulse_for_alarm),
                    .lights(LEDR[7:1])

                );


/*
This module tracks any changes for the numbers: 0,1,2,3,4,5,6,7,8,9 and enter\
SYNCHRONOUS
*/
keyboard_tracker  #(.PULSE_OR_HOLD(1)) u_0(
   .clock(clock),
     .reset(resetn),
   .PS2_CLK(PS2_CLK),
   .PS2_DAT(PS2_DAT),
     .d_0(d_0),
   .d_1(d_1),
   .d_2(d_2),
   .d_3(d_3),
   .d_4(d_4),
   .d_5(d_5),
   .d_6(d_6),
   .d_7(d_7),
   .d_8(d_8),
   .d_9(d_9),
   .enter(enter)
     );
assign key_pressed = d_0 || d_1 || d_2 || d_3 || d_4 || d_5 || d_6 || d_7 || d_8 || d_9;

//SYNCHRONOUS
/* This is the module to assign the laser values in sync */
laser_detector l_0(.out(laser_out),
                   .in(laser_in),
                   .clock(CLOCK_50)
                   );
//ASYNCHRONOUS
hexdecoder h_0(.In({4'b0000, saved_password[3:0]}),
               .Out(HEX3)
               );

hexdecoder h_1(.In({3'b000, saved_password[7:4]}),
               .Out(HEX2));
hexdecoder h_2(.In({3'b000, saved_password[11:8]}),
               .Out(HEX1));
hexdecoder h_3(.In({3'b000, saved_password[15:12]}),
               .Out(HEX0));
hexdecoder h_5(.In({4'b0000, current_state[2:0]}),
               .Out(HEX5));

/* This module takes in the signals from the keyboard libraries and translates
them into their actual binary value */
// ASYNCHRONOUS
convert_keyboard_signals cks_0 (
    .clock(clock),
    .sig_0(d_0),
    .sig_1(d_1),
    .sig_2(d_2),
    .sig_3(d_3),
    .sig_4(d_4),
    .sig_5(d_5),
    .sig_6(d_6),
    .sig_7(d_7),
    .sig_8(d_8),
    .sig_9(d_9),
    .resetn(resetn),
    .digit(digit)
    );


control_main cm_0(.clock(clock),
    .resetn(resetn),
    .key_pressed(key_pressed),
    .enter_key_pressed(enter),
    .correct(correct),
    .register_passcode(register_passcode),
    .load_user_attempt(load_user_attempt),
    .validate(validate_en),
    .current_state(current_state),
    .num_attempts(num_attempts),
    .tresspass(laser_out),
    .rate_divider_en(rate_divider_en),
    .timer_done(pulse),
    .alarm_en(alarm_start)
    );


// This one is for saving the custom key code
load_module save_pass(.clock(clock),
                .resetn(resetn),
                .write(register_passcode),
                .digit(digit),
                .out_keycode(saved_password)
);

// This one is the user attempt
load_module user_attempt(.clock(clock),
                .write(load_user_attempt),
                .digit(digit),
                .out_keycode(attempted_password),
                .resetn(resetn)
);



/* This one takes the user_key and the set_key and compares whether they are equal */

validation v_0(.clock(clock),
               .user_key(saved_password),
               .set_key(attempted_password),
               .correct_signal(correct),
               .validate_en(validate_en),
           .resetn(resetn)
               );


endmodule

module enable_lights(pulse, lights);
    input pulse;
    output reg [6:0] lights;
    always @(*)
    begin
        if(pulse)
        	lights = 7'b1111111;
        else
        	lights = 7'b0000000;
    end


endmodule
/* This module is to control the progression we want to show for this milestone:
set custom key -> user puts in arbitrary code -> validates
*/
module control_main(clock, resetn, key_pressed, enter_key_pressed, correct, register_passcode, load_user_attempt, validate, current_state, num_attempts, tresspass,
                    rate_divider_en, timer_done, alarm_en);
input clock, resetn, key_pressed;
input enter_key_pressed; // signal denoting the user has set or entered a password.
input correct; // signal denoting the user input matches the custom key code
input tresspass, timer_done;
output reg register_passcode, load_user_attempt, validate, rate_divider_en, alarm_en;
output reg[2:0] current_state;
reg [2:0]  next_state;
output reg[1:0] num_attempts;
reg previously_locked;


localparam  REGISTER_KEY_CODE  = 3'd0,
            LOAD_ATTEMPT       = 3'd1,
            VALIDATION         = 3'd2,
            CHECK_VALIDATION   = 3'd3,
            LOCKING            = 3'd4,
            LOCKED             = 3'd5,
            UNLOCKED           = 3'd6,
            STATE_OF_ALARM     = 3'd7;

always @(*)
begin: state_table
case(current_state)
    REGISTER_KEY_CODE: begin
            if (enter_key_pressed) begin
//                      num_attempts = 2'd3;
                        next_state = LOAD_ATTEMPT;
                        previously_locked =1'b0;
                        end
                else next_state = REGISTER_KEY_CODE;
                end
    LOAD_ATTEMPT: begin
                if (timer_done || (num_attempts == 0))
                    next_state = STATE_OF_ALARM;
                else if (enter_key_pressed)
                 next_state = VALIDATION;
                else next_state = LOAD_ATTEMPT;
                end
    VALIDATION: begin
    next_state = CHECK_VALIDATION;
    end
    CHECK_VALIDATION: begin
                if (correct) begin
//                      num_attempts = 2'd3;
                      if (previously_locked) // gotta figure out how to get this signal
                          next_state = UNLOCKED;
                      else
                          next_state = LOCKING;
                            end
                else begin
                     ///////////////////////
                  next_state = LOAD_ATTEMPT;
//                  num_attempts = num_attempts - 1;
                end
                end
    LOCKING: begin
             if(timer_done) next_state = LOCKED;
             else next_state = LOCKING;
     end
    LOCKED: begin
            previously_locked = 1'b1;
            if ((!tresspass) ||  key_pressed) begin // because you need the laser to be blocked for it to be considered tresspassing
               next_state = LOAD_ATTEMPT;
            end
            else
              next_state = LOCKED;
    end
    UNLOCKED: begin
           previously_locked = 1'b0;
           if (key_pressed) begin
              next_state = LOAD_ATTEMPT;
           end
           else
              next_state = UNLOCKED;
    end
     STATE_OF_ALARM: begin
//          next_state = STATE_OF_ALARM;
     end

    default: next_state = REGISTER_KEY_CODE;
    endcase
  end


  always @(*)
        begin: enable_signals
        // By default make all signals 0
        register_passcode = 1'b0;
        validate = 1'b0;
        load_user_attempt = 1'b0;
        alarm_en = 1'b0;
        case (current_state)
            REGISTER_KEY_CODE: begin
                rate_divider_en = 1'b0;
                       if (key_pressed)
                          register_passcode = 1'b1;
                 end
            LOAD_ATTEMPT: begin
                        if(key_pressed)
                  load_user_attempt = 1'b1;
            end
            VALIDATION: begin
                validate = 1'b1;
            end
            CHECK_VALIDATION: begin
                if (correct) begin
                    if(previously_locked) rate_divider_en = 1'b0;
                    else rate_divider_en = 1'b1;
                end
            end
            LOCKING: begin
                if(timer_done) rate_divider_en = 1'b0;

             end
            LOCKED: begin
                if (!tresspass) begin
               rate_divider_en = 1'b1;
                end
                      if(key_pressed) begin
                           load_user_attempt = 1'b1;end
                  end
            UNLOCKED: begin
                  if(key_pressed)
                       load_user_attempt = 1'b1;
            end
            STATE_OF_ALARM: begin
                alarm_en = 1'b1;

            end
        endcase
  end


  // State Register (i.e., FFs
  // Basically, every clock cycle, we change the state.
    always @(posedge clock)
      begin   // Start of state_FFs (state register)
          if(resetn == 1'b0) begin
              current_state <= REGISTER_KEY_CODE;

              end
          else
              current_state <= next_state;
    end  // End of state_FFs (state register)
     
     always @(posedge clock)
     begin: num_attempts_stuff
     
      case (current_state)
            REGISTER_KEY_CODE: begin
                     num_attempts <= 2'd3;
                end
            CHECK_VALIDATION: begin
                if (correct) num_attempts <= 2'd3;
                     else 
                     num_attempts <= num_attempts - 1;
            end
     endcase
     
     
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
