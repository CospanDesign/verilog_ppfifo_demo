
import cocotb
from cocotb.triggers import RisingEdge


@cocotb.test(skip = False)
def first_test(dut):
    dut.log.info("Testing...")

    COUNT = 1000
    count = 0
 
    while count < COUNT:
        yield RisingEdge(dut.clk)
        count += 1

    dut.log.info("Done!")
