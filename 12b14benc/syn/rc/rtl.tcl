# Simple Cadence RC flow for ssp 12b14b encoder
# Authors: Faisal T. Abu-Nimeh
# Date: 20170926

# set PDK path
set pdk_dir [ getenv  "TSMC130_DIR" ]
# source files
set src_dir ../../src/ssp12b14benc

set out_prefix enc12b14b

# use low temp lib
set_attribute library $pdk_dir/Front_End/timing_power_noise/NLDM/tcb013ghp_220a/tcb013ghplt.lib

# define tech and cell lef's
set_attribute lef_library "$pdk_dir/Back_End/lef/tcb013ghp_211a/lef/tcb013ghp.lef $pdk_dir/Back_End/lef/tcb013ghp_211a/lef/tsmc013gFsg_8lm.lef"

# define cap table
set_attribute cap_table_file $pdk_dir/Back_End/lef/tcb013ghp_211a/techfiles/t013s8mg_fsg_v2.0b.cap

# use -40C cells
set_attribute operating_condition LTCOM

# read hdl design
read_hdl -vhdl $src_dir/StdRtlPkg.vhd $src_dir/Code12b14bPkg.vhd $src_dir/SspFramer.vhd $src_dir/Encoder12b14b.vhd $src_dir/SspEncoder12b14b.vhd

# elaborate
elab

current_design SspEncoder12b14b

# SDC, Main clock is 100MHz
create_clock [get_ports {clk}] -name clk -period 10 -waveform {0 5}

# synthesize
synthesize -to_mapped

# get reports
report area > ${out_prefix}_area.rpt
report gates > ${out_prefix}_gates.rpt
report timing > ${out_prefix}_timing.rpt
report power > ${out_prefix}_power.rpt

# prepare design to encounter
write_design -encounter SspEncoder12b14b

# export netlist, timing, and delay files
write_hdl > $out_prefix.v
write_sdc > $out_prefix.sdc
write_sdf > $out_prefix.sdf
