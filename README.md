# Advent of Code 2025

My solutions for the Advent of Code 2025 written in SystemVerilog with testbenches in cocotb.

## Running the tests

To run the tests, you need to have cocotb & verilator installed. You can install the dependencies with the following commands:

**Mac:**
```bash
brew install verilator
pip install cocotb
brew install --cask gtkwave  # optional
```

**Linux:**
```bash
sudo apt install verilator python3-pip gtkwave
pip install cocotb
```

## Makefile

```bash
make help         # Shows commands

make DAY=N        # Runs day N
make clean DAY=N  # Cleans day N

make all          # Runs all days
make clean-all    # Cleans all days

```

Waveforms saved to `day_N/results/wave.vcd` can be viewed with gtkwave or your waveform viewer of choice.
