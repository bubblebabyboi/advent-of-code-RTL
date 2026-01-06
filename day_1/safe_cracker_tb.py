import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock

async def send_string_axis(dut, payload):
    """
    Converts string to ASCII code & sends over AXI-Stream
    """
    for i, char in enumerate(payload):
        dut.s_axis_tvalid.value = 1
        dut.s_axis_tdata.value = ord(char)
        
        if (i == len(payload) - 1):
            dut.s_axis_tlast.value = 1;
        else:
            dut.s_axis_tlast.value = 0;

        await RisingEdge(dut.clk)
        while not dut.s_axis_tready.value:
            await RisingEdge(dut.clk)
            
    dut.s_axis_tvalid.value = 0
    dut.s_axis_tlast.value = 0

@cocotb.test()
async def test_safe_cracker(dut):
    # Setup Clock
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start()) # 500MHz clock

    # Reset
    dut.rst_n.value = 0
    dut.s_axis_tvalid.value = 0
    dut.s_axis_tdata.value = 0
    dut.s_axis_tlast.value = 0
    await Timer(10, units="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Read input text 
    try:
        with open("input.txt", "r") as f:
            full_input = f.read()
    except FileNotFoundError:
        dut._log.error("input.txt not found")
        return

    dut._log.info(f"Sending {len(full_input)} bytes of ASCII data...")

    # Drive the text data
    await send_string_axis(dut, full_input)

    while not dut.done.value:
        await RisingEdge(dut.clk)

    dut._log.info(f"Final Passcode: {int(dut.passcode.value)}")