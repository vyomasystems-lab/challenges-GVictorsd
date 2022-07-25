# Sequence Detector Design Verification

The verification environment is setup using [Vyoma's UpTickPro](https://vyomasystems.com) provided for the hackathon.

*Make sure to include the Gitpod id in the screenshot*

![](./screen1.png)

## Verification Environment

The [CoCoTb](https://www.cocotb.org/) based Python test is developed as explained. The test drives inputs to the Design Under Test (adder module here) which takes in 4-bit inputs *a* and *b* and gives 5-bit output *sum*

The values are assigned to the input port using 
```
    inputseq = [1,0,1,1,0,1,1]
    for i in inputseq:
        dut.inp_bit.value = i
```

The Clock signal is ticked using the following statement
```
    await FallingEdge(dut.clk)
```

The assert statement is used for comparing the Module's output to the expected value.


## Test Scenario - 1

The following error is seen:
```
assert dut.seq_seen.value == checkseq(inputseq, curindex), f"Test failed with: Index={curindex}, Expected Output={checkseq(inputseq, curindex)}, DUTOutput={int(dut.seq_seen.value)}"

AssertionError: Test failed with: Index=6, Expected Output=True, DUTOutput=0
```

- Test Inputs:
    input Sequence = [1,0,1,1,0,1,1]
- Expected Output sequence = [0,0,0,1,0,0,1]
- Observed Output in the DUT dut.seq_seen = [0,0,0,1,0,0,0]

Output mismatches for the above inputs proving that there is a design bug


## Design Bug
### Design Bug (1)
Based on the above test input and analysing the design, we see the following

```
    5'b01010: out = inp10;
    5'b01011: out = inp11;
    5'b01101: out = inp12;    ====> BUG(line 40)
    5'b01101: out = inp13;
    5'b01110: out = inp14;
```
The case statement was wrongly configured as 5'b01101 instead of 5'b01100.
This made the 13'th select control produce a wrong output.

This was fixed by updating the line to the following
```
    5'b01100: out = inp12;
```


### Design Bug (2)
Based on the above test input and analysing the design, we see the following

```
      5'b11100: out = inp28;
      5'b11101: out = inp29;     ==> BUG
      default: out = 0;
    endcase
  end
```
Though the case statement was configured for inputs 0 to 29, case 30 was not configured.
This lead to execution of the default statement which produced an output of 0.

This was fixed by adding the following line in the case statement
```
    5'b11110: out = inp30;    // modified line
```

## Design Fix
Updating the design and re-running the test makes the test pass.

![](./screen2.png)

The updated design is checked in as mux_fix.v

## Verification Strategy
The design was verified by providing a bunch of random values as inputs for the input lines inp0-inp30 
The select lines are looped over all the input lines to check corresponding output produced by the Design under test.
Each of the individual outputs are verified by comparing them to the corresponding input value.

## Is the verification complete ?
Yes. The verification is complete.