# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 20
    dut.uio_in.value = 30

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)
    
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
    # Check if the state has accumulated
    assert dut.state_o.value.integer > 0, "State didn't accumulate with small current"
    dut._log.info(f"State after small current input: {dut.state_o.value.integer}")

    # Test with a large current that will cause a spike
    dut.current.value = 130   # This should exceed the threshold
    await ClockCycles(dut.clk_i, 1)  # Check output immediately

    # Verify if a spike occurs and the state resets
    assert dut.spike_o.value == 1, "Neuron didn't spike at high current input"
    dut._log.info("Spike occurred with large input, resetting state")

    # Check the reset behavior of `state_o`
    await ClockCycles(dut.clk_i, 1)
    assert dut.state_o.value == 0, "State didn't reset after spike"

    # Apply a sustained low current input and check for decay
    dut.current.value = 5
    await ClockCycles(dut.clk_i, 10)  # Allow time for potential decay

    # Verify if the state has decayed over time
    assert dut.state_o.value < 128, "State didn't decay as expected over time"
    dut._log.info(f"State after decay check: {dut.state_o.value.integer}")

    # Test variant threshold dynamics with repeated spiking
    dut.current.value = 140
    for _ in range(3):  # Cause multiple spikes to test threshold increment
        await ClockCycles(dut.clk_i, 1)
        assert dut.spike_o.value == 1, "Neuron didn't spike as expected"
        dut._log.info("Neuron spiked, threshold should increment")
        await ClockCycles(dut.clk_i, 1)

    # Reset current to zero and check if variant threshold decays
    dut.current.value = 0
    await ClockCycles(dut.clk_i, 10)  # Let threshold decay if no spikes

    assert dut.state_o.value == 0, "State didn't decay with zero current input"
    dut._log.info("State and variant threshold decayed without current input")

    dut._log.info("LIF neuron test completed successfully")
