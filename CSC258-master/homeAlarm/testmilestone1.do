vlog -timescale 1ns/1ns milestone2.v
vsim milestone1
log {/*}
add wave {/*}
force {SW} 00000000000
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# set reset back off
force {SW[11]} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# set the password

force {d_1} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


force {d_1} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_2} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_2} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_3} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


force {d_3} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


force {d_4} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_4} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

# press enter

force {enter} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# unpress enter
force {enter} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns






#load the attempted password


force {d_1} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_1} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_2} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_2} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


force {d_3} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_3} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_4} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


force {d_4} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# press enter

force {enter} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# unpress enter
force {enter} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



# authentication should be correct, wait some time

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



# provide authentication that is wrong


# 2
force {d_2} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_2} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

# 4

force {d_4} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_4} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

# 1

force {d_1} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_1} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

# 3

force {d_3} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_3} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# press enter

force {enter} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# unpress enter
force {enter} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns





#wait some time 


force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns





#provide correct authentication


force {d_1} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_1} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_2} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_2} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns




force {d_3} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_3} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



force {d_4} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {d_4} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

# press enter

force {enter} 1
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# unpress enter
force {enter} 0
force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns


# wait some time

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns

force {CLOCK_50} 0
run 10 ns
force {CLOCK_50} 1
run 10 ns



