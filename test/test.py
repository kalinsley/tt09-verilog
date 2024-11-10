# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import random


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 10)

    for i in range(784):
        dut.ui_in.value = random.randint(0, 255)
        await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 10)


    await ClockCycles(dut.clk, 100)


    dut._log.info("Done")