module I2C_Master (
    input wire clk,              // System clock
    input wire rst_n,            // Reset (active low)
    output wire sda,            // Serial Data (bidirectional)
    output wire scl,            // Serial Clock
    output wire start,          // Start condition
    output wire stop,           // Stop condition
    output wire write,          // Write data
    input wire ack              // Acknowledge from slave
);

    // Internal signals and registers
    reg [7:0] data_out;
    reg [7:0] address;
    reg [2:0] state;

    // Constants for I2C states
    localparam IDLE_STATE = 3'b000;
    localparam START_STATE = 3'b001;
    localparam WRITE_STATE = 3'b010;
    localparam STOP_STATE = 3'b011;

    // I2C state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE_STATE;
        end else begin
            case (state)
                IDLE_STATE: begin
                    if (start) begin
                        state <= START_STATE;
                    end
                end

                START_STATE: begin
                    // Drive SDA low to indicate start condition
                    sda <= 0;
                    scl <= 1;
                    if (scl) begin
                        state <= WRITE_STATE;
                    end
                end

                WRITE_STATE: begin
                    // Write data to SDA
                    sda <= data_out[7];
                    scl <= 1;
                    if (scl) begin
                        data_out <= data_out << 1;
                        if (write) begin
                            state <= WRITE_STATE;
                        end else begin
                            state <= STOP_STATE;
                        end
                    end
                end

                STOP_STATE: begin
                    // Drive SDA high to indicate stop condition
                    sda <= 1;
                    scl <= 1;
                    if (scl) begin
                        state <= IDLE_STATE;
                    end
                end
            endcase
        end
    end

    // Initialize outputs
    assign start = (state == START_STATE);
    assign stop = (state == STOP_STATE);
    assign write = (state == WRITE_STATE);

endmodule
