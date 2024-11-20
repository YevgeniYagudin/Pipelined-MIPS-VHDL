onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mipstb/reset
add wave -noupdate /mipstb/clock
add wave -noupdate /mipstb/ena
add wave -noupdate -radix decimal /mipstb/PC
add wave -noupdate -radix hexadecimal /mipstb/ID_Instruct
add wave -noupdate -radix decimal /mipstb/read_data_1_out
add wave -noupdate -radix decimal /mipstb/read_data_2_out
add wave -noupdate /mipstb/ID_Regwrite
add wave -noupdate -radix hexadecimal /mipstb/EX_Instruct
add wave -noupdate -radix decimal /mipstb/ALU_result_out
add wave -noupdate -radix decimal /mipstb/EX_ALUAinput
add wave -noupdate -radix decimal /mipstb/EX_ALUBinput
add wave -noupdate /mipstb/Zero_out
add wave -noupdate -radix hexadecimal /mipstb/DM_Instruct
add wave -noupdate /mipstb/Branch_out
add wave -noupdate /mipstb/Memwrite_out
add wave -noupdate -radix decimal /mipstb/write_data_out
add wave -noupdate -radix decimal /mipstb/MEM_read_data
add wave -noupdate -radix decimal /mipstb/MEM_Address
add wave -noupdate -radix hexadecimal /mipstb/WB_Instruct
add wave -noupdate /mipstb/Regwrite_out
add wave -noupdate -radix decimal /mipstb/CLKCNT
add wave -noupdate -radix decimal /mipstb/STCNT
add wave -noupdate -radix decimal /mipstb/FHCNT
add wave -noupdate -radix decimal /mipstb/BPADD
add wave -noupdate /mipstb/STtrigger
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2539406 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {11850562 ps}
