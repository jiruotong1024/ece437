onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate /system_tb/DUT/CPU/scif/memstore
add wave -noupdate /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -radix binary /system_tb/DUT/CPU/scif/ramload
add wave -noupdate /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate /system_tb/DUT/CPU/scif/memREN
add wave -noupdate /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate /system_tb/DUT/RAM/addr
add wave -noupdate /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate /system_tb/DUT/CPU/DP/pc
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUop
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Branch
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/CPUS
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ExtOp
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Jump
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/MemWrite
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/MemtoReg
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/RWEN
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/RegDst
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/cuif/instruction
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/jump_addr
add wave -noupdate -radix binary /system_tb/DUT/CPU/DP/cuif/src_addr
add wave -noupdate /system_tb/DUT/RAM/count
add wave -noupdate /system_tb/DUT/CPU/DP/afif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/afif/negative
add wave -noupdate /system_tb/DUT/CPU/DP/afif/output_port
add wave -noupdate /system_tb/DUT/CPU/DP/afif/overflow
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/afif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/afif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/afif/zero
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/RF/new_reg/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/next_pc
add wave -noupdate /system_tb/DUT/CPU/DP/pc_EN
add wave -noupdate /system_tb/DUT/CPU/DP/shamt
add wave -noupdate /system_tb/DUT/CPU/DP/new_pc
add wave -noupdate -expand /system_tb/DUT/CPU/DP/RF/new_register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168048 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 110
configure wave -valuecolwidth 71
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {32850 ps} {231850 ps}
