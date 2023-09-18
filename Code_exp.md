# I2C Communication Verilog Modules

This document provides a detailed explanation of the Verilog code for implementing I2C (Inter-Integrated Circuit) communication between a master and a slave device. The code consists of two main modules: `I2C_Master` and `I2C_Slave`. Below, we break down each module's functionality and structure.

## I2C_Master Module

The `I2C_Master` module represents the I2C master device responsible for initiating and managing communication with one or more slave devices. Here's a detailed breakdown of its functionality:

### State Machine

The core of the `I2C_Master` module is a state machine that controls the I2C communication protocol. It progresses through the following states:

- **IDLE_STATE:** The initial state where the module waits for a start condition.
- **START_STATE:** This state generates a start condition by driving the SDA (Serial Data) line low while the SCL (Serial Clock) line is high.
- **WRITE_STATE:** In this state, the module writes data to the SDA line and shifts the data for each clock cycle. It determines whether to continue writing or transition to the STOP_STATE.
- **STOP_STATE:** Here, the module generates a stop condition by driving the SDA line high while SCL is high.

### Control Signals

- **start:** This output signal is high when the module is in the START_STATE, indicating a start condition.
- **stop:** Similarly, this output signal is high when the module is in the STOP_STATE, indicating a stop condition.
- **write:** This signal determines whether the module should continue writing data in the WRITE_STATE or transition to the STOP_STATE.
- **ack:** The `ack` input signal represents the acknowledgment (ACK) signal received from the slave. It is used to determine if the slave acknowledges the data sent by the master.

### Initialization

- The module initializes its state machine to the IDLE_STATE during reset (`rst_n` signal).

### Usage

To use the `I2C_Master` module, you need to instantiate it within your FPGA or ASIC design and connect the appropriate clock (`clk`), reset (`rst_n`), and control signals (`start`, `stop`, `write`, and `ack`) as required by your application. Customize the data and address signals as needed.

## I2C_Slave Module

The `I2C_Slave` module represents the I2C slave device responsible for responding to the master's requests. Below is a detailed explanation of its functionality:

### State Machine

The core of the `I2C_Slave` module is a state machine that manages the I2C communication protocol. It includes the following states:

- **IDLE_STATE:** This is the initial state where the module waits for a start condition.
- **ADDRESS_STATE:** In this state, the module waits for the master to send its address. Once the address is received, it transitions to the READ_STATE.
- **READ_STATE:** Here, the module waits for clock edges to receive data from the master.

### Control Signals

- **ack:** The `ack` output signal indicates whether the slave acknowledges the master's address during the ADDRESS_STATE.

### Initialization

- The module initializes its state machine to the IDLE_STATE during reset (`rst_n` signal).

### Usage

To use the `I2C_Slave` module, you need to instantiate it within your FPGA or ASIC design and connect the appropriate clock (`clk`), reset (`rst_n`), and communication signals (`sda`, `scl`, and `ack`) as needed for your application. Customize the data and address handling logic as per your requirements.
