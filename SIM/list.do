onerror {resume}
add list -width 15 /mipstb/reset
add list /mipstb/clock
add list /mipstb/ena
add list /mipstb/PC
add list /mipstb/ID_Instruct
add list /mipstb/read_data_1_out
add list /mipstb/read_data_2_out
add list /mipstb/ID_Regwrite
add list /mipstb/EX_Instruct
add list /mipstb/ALU_result_out
add list /mipstb/EX_ALUAinput
add list /mipstb/EX_ALUBinput
add list /mipstb/Zero_out
add list /mipstb/DM_Instruct
add list /mipstb/Branch_out
add list /mipstb/Memwrite_out
add list /mipstb/write_data_out
add list /mipstb/MEM_read_data
add list /mipstb/MEM_Address
add list /mipstb/WB_Instruct
add list /mipstb/Regwrite_out
add list /mipstb/CLKCNT
add list /mipstb/STCNT
add list /mipstb/FHCNT
add list /mipstb/BPADD
add list /mipstb/STtrigger
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
