# UART in Verilog

## Overview
A UART (Universal Asynchronous Receiver-Transmitter) protocol implementation
in Verilog. Covers both transmitter (TX) and receiver (RX) modules with
configurable baud rate. Simulated and verified in Xilinx Vivado.

## Tools Used
- **Language:** Verilog (IEEE 1364)
- **Simulator:** Xilinx Vivado

## File Structure
| File | Description |
|---|---|
| `uart_tx.v` | UART Transmitter module |
| `uart_rx.v` | UART Receiver module |
| `uart_tb.v` | Testbench |

## Features
- Configurable baud rate
- Start and stop bit generation
- 8-bit data frame
- TX and RX verified together in simulation

## Simulation Output
# UART in Verilog

## Overview
A UART (Universal Asynchronous Receiver-Transmitter) protocol implementation
in Verilog. Covers both transmitter (TX) and receiver (RX) modules with
configurable baud rate. Simulated and verified in Xilinx Vivado.

## Tools Used
- **Language:** Verilog (IEEE 1364)
- **Simulator:** Xilinx Vivado

## File Structure
| File | Description |
|---|---|
| `uart_tx.v` | UART Transmitter module |
| `uart_rx.v` | UART Receiver module |
| `uart_tb.v` | Testbench |

## Features
- Configurable baud rate
- Start and stop bit generation
- 8-bit data frame
- TX and RX verified together in simulation

## Simulation Output
<img width="1573" height="635" alt="image" src="https://github.com/user-attachments/assets/6607527f-2e9a-4ea4-8900-0f035afcb18c" />




## How to Simulate
1. Open Xilinx Vivado
2. Add all `.v` files to a new project
3. Set `uart_tb.v` as top simulation module
4. Run Behavioral Simulation
```

