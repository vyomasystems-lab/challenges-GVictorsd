# See LICENSE.iitm for details
# See LICENSE.vyoma for details

import random
import sys
import cocotb
from cocotb.decorators import coroutine
from cocotb.triggers import Timer, RisingEdge
from cocotb.result import TestFailure
from cocotb.clock import Clock

from model_mkbitmanip import *

# Clock Generation
@cocotb.coroutine
def clock_gen(signal):
    while True:
        signal.value <= 0
        yield Timer(1) 
        signal.value <= 1
        yield Timer(1) 


def forminst(opcode, f3, f7, a, b, c):
    '''
    opcode, f3, f7, rs1, rs2, rd
    '''
    res = 0
#    res |= int(str(opcode[2:]).zfill(7), 2)
    res |= int(bin(opcode)[2:].zfill(7), 2)
    res |= int(bin(c)[2:].zfill(5), 2) << 7
    res |= int(bin(f3)[2:].zfill(3),2) << 12
    res |= int(bin(a)[2:].zfill(5), 2) << 15
    res |= int(bin(b)[2:].zfill(5), 2) << 20
    res |= int(bin(f7)[2:].zfill(7), 2) << 25
    return res

# Sample Test
@cocotb.test()
def run_test(dut):

    # clock
    cocotb.fork(clock_gen(dut.CLK))

    # reset
    dut.RST_N.value <= 0
    yield Timer(10) 
    dut.RST_N.value <= 1

    ######### CTB : Modify the test to expose the bug #############
    # input transaction
    mav_putvalue_src1 = 0x5
    mav_putvalue_src2 = 0x1
    mav_putvalue_src3 = 0x1
    # mav_putvalue_instr = 0x101010B3
    opcode = int('0110011', 2)
    f3 = int('011', 2)
    f7 = int('0001000', 2)

    mav_putvalue_instr = forminst(opcode, f3, f7, 0x0, 0x1, 0x1)

    # expected output from the model
    expected_mav_putvalue = bitmanip(mav_putvalue_instr, mav_putvalue_src1, mav_putvalue_src2, mav_putvalue_src3)

    # driving the input transaction
    dut.mav_putvalue_src1.value = mav_putvalue_src1
    dut.mav_putvalue_src2.value = mav_putvalue_src2
    dut.mav_putvalue_src3.value = mav_putvalue_src3
    dut.EN_mav_putvalue.value = 1
    dut.mav_putvalue_instr.value = mav_putvalue_instr
  
    yield Timer(1) 

    # obtaining the output
    dut_output = dut.mav_putvalue.value

    cocotb.log.info(f'DUT OUTPUT={hex(dut_output)}')
    cocotb.log.info(f'EXPECTED OUTPUT={hex(expected_mav_putvalue)}')
    
    # comparison
    error_message = f'Value mismatch DUT = {hex(dut_output)} does not match MODEL = {hex(expected_mav_putvalue)}'
    assert dut_output == expected_mav_putvalue, error_message
