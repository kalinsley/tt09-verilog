# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    await ClockCycles(dut.clk, 10)

    dut._log.info("Done")