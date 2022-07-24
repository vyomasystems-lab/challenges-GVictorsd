# See LICENSE.vyoma for details

import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_mux(dut):
    """Test for mux2"""
    inputs = [i%4 for i in range(31)]

    #cocotb.log.info('##### CTB: Develop your test here ########')
    dut.inp0.value = 0
    dut.inp1.value = 1
    dut.inp2.value = 2
    dut.inp3.value = 3
    dut.inp4.value = 0
    dut.inp5.value = 1
    dut.inp6.value = 2
    dut.inp7.value = 3
    dut.inp8.value = 0
    dut.inp9.value = 1
    dut.inp10.value = 2
    dut.inp11.value = 3
    dut.inp12.value = 0
    dut.inp13.value = 1
    dut.inp14.value = 2
    dut.inp15.value = 3
    dut.inp16.value = 0
    dut.inp17.value = 1
    dut.inp18.value = 2
    dut.inp19.value = 3
    dut.inp20.value = 0
    dut.inp21.value = 1
    dut.inp22.value = 2
    dut.inp23.value = 3
    dut.inp24.value = 0
    dut.inp25.value = 1
    dut.inp26.value = 2
    dut.inp27.value = 3
    dut.inp28.value = 0
    dut.inp29.value = 1
    dut.inp30.value = 2

    # input driving
    # dut.a.value = A
    # dut.b.value = B
    await Timer(2, units='ns')

    for i in range(31):
        dut.sel.value = i
        await Timer(2, units='ns')

        invalue = f'dut.inp{i}.value'
        dut._log.info(f'Sel={i} in[{i}]={inputs[i]} DUTOutput={int(dut.out.value)}')
        assert dut.out.value == inputs[i], f"Test failed with: Sel={i}, Expected Output(input[{i}])={inputs[i]}, DUTOutput={int(dut.out.value)}"

    # await Timer(2, units='ns')
    # dut._log.info(f'A={A:05} B={B:05} model={A+B:05} DUT={int(dut.sum.value):05}')
    # assert dut.sum.value == A+B, "Randomised test failed with: {A} + {B} = {SUM}".format(
    #         A=dut.a.value, B=dut.b.value, SUM=dut.sum.value)