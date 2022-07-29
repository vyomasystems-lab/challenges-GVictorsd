# See LICENSE.iitm for details
# See LICENSE.vyoma for details

import random
import sys
import cocotb
from cocotb.decorators import coroutine
from cocotb.triggers import Timer, RisingEdge
from cocotb.result import TestFailure
from cocotb.clock import Clock

# Clock Generation
@cocotb.coroutine
def clock_gen(signal):
    while True:
        signal.value <= 0
        yield Timer(1) 
        signal.value <= 1
        yield Timer(1) 

# Sample Test
@cocotb.test()
def run_test(dut):
    # clock
    cocotb.fork(clock_gen(dut.clk))

    # supported instructions and opcodes
    nop=0x0
    lda=0x1
    add=0x2
    sub=0x3
    sta=0x4
    ldi=0x5
    jmp=0x6
    jc=0x7
    jz=0x8
    out=0xe
    hlt=0xf

    # get the cpu out of halt state
    dut.hlt.value <= 0

    # reset
    dut.clr.value <= 0
    yield Timer(10) 
    dut.clr.value <= 1

    # store operands in the memory
    dut.rm.mem[0xe].value <= 0x38
    dut.rm.mem[0xf].value <= 0x23

    # load instructions to the RAM (reset vector- 0x0 )
    # program to add operands
    dut.rm.mem[0x0].value <= lda * 0x10 + 0xe
    dut.rm.mem[0x1].value <= add * 0x10 + 0xf
    dut.rm.mem[0x2].value <= out * 0x10 + 0x0
    dut.rm.mem[0x3].value <= hlt * 0x10 + 0x0

    expected_output = 0x38 + 0x23

#    yield Timer(100) 

    # obtaining the output
    dut_output = dut.display.value
#    cocotb.log.info(f'DUT OUTPUT={dut_output}')
    try:
        dut_output = 0 if dut_output == 'x'*8 else 0
    except:
        dut_output = 0

    print(dut_output)

    # cocotb.log.info(f'DUT OUTPUT={hex(dut_output)}')
    
    # comparison
    # error_message = f'Value mismatch DUT = {hex(dut_output)} does not match MODEL = {hex(expected_mav_putvalue)}'
    assert dut_output == expected_output , f'Value mismatch: Expected o/p: {expected_output}, DUT output: {dut_output}'


# @cocotb.test()
# def run_test(dut):
#     # clock
#     #    cocotb.fork(clock_gen(dut.clk))

#     yield Timer(10) 
#     yield Timer(1) 

#     # obtaining the output
#     dut_output = dut.display.value

# #    cocotb.log.info(f'DUT OUTPUT={hex(dut_output)}')
    
#     # comparison
#     # error_message = f'Value mismatch DUT = {hex(dut_output)} does not match MODEL = {hex(expected_mav_putvalue)}'
#     # assert dut_output == expected_mav_putvalue, error_message