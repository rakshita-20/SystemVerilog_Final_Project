# Makefile for QuestaSim with SystemVerilog

# Compiler and simulator settings
# defining environments
# variable = command
VLOG = vlog
VSIM = vsim
WORK = work

# Source files

# \ means continued in the next line
SRCS = textfile.sv

# Top module
TOP_MODULE = createTextfile

SIM_OPTIONS = -do "run -all"
# Log file for compilation errors
#LOG_FILE = compile_errors.log

# Default target
# clean is not included initially because it will not have "work" folder (Will get cleaned)
all: compile simulate

# Compile step\
# incdir= include directory= indicating directories containing design module and testbench, syntax- +incdir+<dir name>
# multiple directories- +incdir+<directory name>+incdir+<2nd directory name>
# ./  means present directory
compile:
	$(VLOG) +incdir+./ -lint -source $(SRCS) 2>&1

# Simulation step
simulate:
	$(VSIM) -c -voptargs=+acc $(SIM_OPTIONS) $(WORK).$(TOP_MODULE)

# Clean up generated files
clean:
	rm -rf transcript vsim.wlf work

.PHONY: all compile simulate clean
