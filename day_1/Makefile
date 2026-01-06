SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = $(shell pwd)/safe_cracker.sv
TOPLEVEL = safe_cracker
MODULE = safe_cracker_tb

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

EXTRA_ARGS += --trace --trace-structs

COCOTB_RESULTS_FILE = results/results.xml
WAVES = 1

# Create results dir 
$(shell mkdir -p results)
include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY: run clean

run:
	@$(MAKE) sim
	@if [ -f dump.vcd ]; then mv dump.vcd results/wave.vcd; fi

clean::
	@rm -f results/*
