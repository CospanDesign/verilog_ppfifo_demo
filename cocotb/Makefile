TOPLEVEL_LANG ?= verilog
PWD=$(shell pwd)
TOPDIR=$(PWD)/..
COCOTB		:= $(shell $(python) nysa paths -c -s)

PYTHONPATH := ./model:$(PYTHONPATH)
export PYTHONPATH
export PYTHONHOME=$(shell python -c "from distutils.sysconfig import get_config_var; print(get_config_var('prefix'))")

EXTRA_ARGS+=-I$(TOPDIR)/rtl

#Dependencies
VERILOG_SOURCES =  ${TOPDIR}/rtl/cross_clock_enable.v
VERILOG_SOURCES += ${TOPDIR}/rtl/blk_mem.v
VERILOG_SOURCES += ${TOPDIR}/rtl/ppfifo.v
VERILOG_SOURCES += ${TOPDIR}/rtl/ppfifo_sink.v
VERILOG_SOURCES += ${TOPDIR}/rtl/ppfifo_source.v

#DUT
VERILOG_SOURCES += $(TOPDIR)/sim/tb_ppfifo.v

TOPLEVEL = tb_ppfifo

GPI_IMPL := vpi

export TOPLEVEL_LANG
MODULE=test_dut

include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim

.PHONY: wave test
wave:
	gtkwave waveforms.gtkw &


