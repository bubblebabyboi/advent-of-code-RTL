# Advent of Code 2025

My solutions for the Advent of Code 2025 written in SystemVerilog with testbenches in cocotb.

## Running the tests

To run the tests, you need to have cocotb installed. You can install it with pip:

```bash
pip install cocotb
```

Then you can run the tests with:
```bash
make test
```

You can run the tests for a specific day with:
```bash
make test DAY=1
```
## Project structure

The project is organized into the following directories:

- `day_<number>`: The directory for the day's solutions.
- `day_<number>/day_<number>.sv`: The main module for the day's solution.
- `day_<number>/input.txt`: The input file for the testbench.
- `day_<number>/day_<number>_tb.py`: The cocotb test for the day's solution.
