vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/xbip_utils_v3_0_8
vlib questa_lib/msim/c_reg_fd_v12_0_4
vlib questa_lib/msim/c_mux_bit_v12_0_4
vlib questa_lib/msim/c_shift_ram_v12_0_11

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap xbip_utils_v3_0_8 questa_lib/msim/xbip_utils_v3_0_8
vmap c_reg_fd_v12_0_4 questa_lib/msim/c_reg_fd_v12_0_4
vmap c_mux_bit_v12_0_4 questa_lib/msim/c_mux_bit_v12_0_4
vmap c_shift_ram_v12_0_11 questa_lib/msim/c_shift_ram_v12_0_11

vlog -work xil_defaultlib -64 -sv \
"D:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xbip_utils_v3_0_8 -64 -93 \
"../../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_4 -64 -93 \
"../../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work c_mux_bit_v12_0_4 -64 -93 \
"../../../ipstatic/hdl/c_mux_bit_v12_0_vh_rfs.vhd" \

vcom -work c_shift_ram_v12_0_11 -64 -93 \
"../../../ipstatic/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../Crystals-kyber.srcs/sources_1/ip/c_shift_ram_4/sim/c_shift_ram_4.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

