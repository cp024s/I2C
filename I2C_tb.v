`timescale 1ns / 1ps

module tb_i2c;

    // Define parameters
    parameter CLK_PERIOD = 10;  // Clock period in ns

    // Declare signals
    reg clk;
    reg rst_n;
    reg sda;
    reg scl;
    wire start;
    wire stop;
    wire write;
    wire ack;

    // Instantiate I2C master and slave modules
    I2C_Master master (
        .clk(clk),
        .rst_n(rst_n),
        .sda(sda),
        .scl(scl),
        .start(start),
        .stop(stop),
        .write(write),
        .ack(ack)
    );

    I2C_Slave slave (
        .clk(clk),
        .rst_n(rst_n),
        .sda(sda),
        .scl(scl),
        .ack(ack)
    );

    // Clock generation
    always begin
        #CLK_PERIOD/2 clk = ~clk;
    end

    // Initializations
    initial begin
        // Initialize clock and reset
        clk = 0;
        rst_n = 1;

        // Reset the system
        rst_n = 0;
        #10 rst_n = 1;

//------------------------------------------------------------------------------------------------------------------
// Test Case 1: Start, Write, Stop, and Acknowledgment
start = 0;
stop = 0;
write = 0;
scl = 1;
sda = 1;

start = 1;
#10 start = 0;

// Write data from master to slave
sda = 0; // Start of data transmission
#10 sda = 1;
#10 write = 1; // More data to send
sda = 0;
#10 sda = 1;
#10 write = 1; // More data to send
sda = 0;
#10 sda = 1;
#10 write = 0; // End of data transmission

// Stop condition
stop = 1;
#10 stop = 0;

// Verify acknowledgment from the slave
assert(ack === 1) else $display("Test Case 1 Failed: No acknowledgment from the slave.");

      
//------------------------------------------------------------------------------------------------------------------
// Test Case 2: Start, Stop, and No Data
start = 0;
stop = 0;
scl = 1;
sda = 1;

start = 1;
#10 start = 0;

// Stop condition without sending data
stop = 1;
#10 stop = 0;

// Verify no acknowledgment from the slave
assert(ack === 0) else $display("Test Case 2 Failed: Unexpected acknowledgment from the slave.");

//------------------------------------------------------------------------------------------------------------------
// Test Case 3: Start, Write, Read, Stop, and Acknowledgment
start = 0;
stop = 0;
write = 0;
scl = 1;
sda = 1;

start = 1;
#10 start = 0;

// Write data from master to slave
sda = 0; // Start of data transmission
#10 sda = 1;
#10 write = 1; // More data to send
sda = 0;
#10 sda = 1;
#10 write = 1; // More data to send
sda = 0;
#10 sda = 1;
#10 write = 0; // End of data transmission

// Repeated start for reading
start = 1;
#10 start = 0;

// Read data from the slave
sda = 1; // Release SDA for data reception
#10 sda = 0; // Data bit 1
#10 sda = 1; // Release SDA (high) after reading data
#10 sda = 0; // Data bit 2
#10 sda = 1; // Release SDA (high) after reading data

// Stop condition
stop = 1;
#10 stop = 0;

// Verify acknowledgment from the slave
assert(ack === 1) else $display("Test Case 3 Failed: No acknowledgment from the slave.");

//------------------------------------------------------------------------------------------------------------------
// Test Case 4: Multiple Start and Stop Conditions
start = 0;
stop = 0;
scl = 1;
sda = 1;

start = 1;
#10 start = 0;

// Stop condition
stop = 1;
#10 stop = 0;

// Another start condition
start = 1;
#10 start = 0;

// Another stop condition
stop = 1;
#10 stop = 0;

// Yet another start condition
start = 1;
#10 start = 0;

// Yet another stop condition
stop = 1;
#10 stop = 0;
      
//------------------------------------------------------------------------------------------------------------------
// Test Case 5: Address Recognition and Data Reception
start = 0;
stop = 0;
scl = 1;
sda = 1;

start = 1;
#10 start = 0;

// Address sent by the master
sda = 0;
#10 sda = 1;

// Acknowledgment from the slave
ack = 1;
#10 ack = 0;

// Read data from the slave
sda = 1; // Release SDA for data reception
#10 sda = 0; // Data bit 1
#10 sda = 1; // Release SDA (high) after reading data
#10 sda = 0; // Data bit 2
#10 sda = 1; // Release SDA (high) after reading data

// Stop condition
stop = 1;
#10 stop = 0;

//------------------------------------------------------------------------------------------------------------------
      
        $finish;
    end

endmodule
