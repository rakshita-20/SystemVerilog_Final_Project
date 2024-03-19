vlib work
vdel -all
vlib work

vlog -lint IOM.sv
vlog -lint top.sv +acc
vlog -lint Intel8088Pins.sv
vlog -lint 8088if.svp

vsim work.top

add wave -r *\

run -all