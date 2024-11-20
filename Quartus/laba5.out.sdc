## Generated SDC file "laba5.out.sdc"

## Copyright (C) 2021  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"

## DATE    "Sun Jun 18 04:40:18 2023"

##
## DEVICE  "5CSXFC6D6F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clock} -period 30.000 -waveform { 0.000 10.000 } [get_ports {clock}]
create_clock -name {Bit32Register:regExt|dataOut[0]} -period 30.000 -waveform { 0.000 10.000 } [get_registers {Bit32Register:regExt|dataOut[0]}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -rise_to [get_clocks {clock}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -rise_to [get_clocks {clock}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -fall_to [get_clocks {clock}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -fall_to [get_clocks {clock}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -rise_to [get_clocks {clock}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -rise_to [get_clocks {clock}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -fall_to [get_clocks {clock}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {Bit32Register:regExt|dataOut[0]}] -fall_to [get_clocks {clock}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {clock}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {clock}] -rise_to [get_clocks {clock}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {clock}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {clock}] -fall_to [get_clocks {clock}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {Bit32Register:regExt|dataOut[0]}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {clock}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {clock}] -rise_to [get_clocks {clock}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {clock}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {clock}] -fall_to [get_clocks {clock}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

