# See LICENSE.vyoma for details

# SPDX-License-Identifier: CC0-1.0

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge

def checkseq(arr, index):
    if index < 3:
        return False
    return arr[index-3:index+1] == [1,0,1,1]

@cocotb.test()
async def test_seq_bug1(dut):
    """Test for seq detection """

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    cocotb.start_soon(clock.start())        # Start the clock

    # reset
    dut.reset.value = 1
    await FallingEdge(dut.clk)  
    dut.reset.value = 0
    await FallingEdge(dut.clk)

    # output seq_seen;
    # input inp_bit;
    # input reset;
    # input clk;
    # inputseq = [0, 1, 0, 1, 1, 0, 1, 1]
    inputseq = [1,0,1,1,0,1,1]
    for curindex, i in enumerate(inputseq):
        dut.inp_bit.value = i
        await FallingEdge(dut.clk)
        
        dut._log.info(f'inputbit={i} DUTOutput={int(dut.seq_seen.value)}')
        assert dut.seq_seen.value == checkseq(inputseq, curindex), f"Test failed with: Index={curindex}, Expected Output={checkseq(inputseq, curindex)}, DUTOutput={int(dut.seq_seen.value)}"


    cocotb.log.info('#### CTB: Develop your test here! ######')
    