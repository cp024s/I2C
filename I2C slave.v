module I2C_Slave (
    input wire clk,          // System clock
    input wire rst_n,        // Reset (active low)
    input wire sda,          // Serial Data (bidirectional)
    input wire scl,          // Serial Clock
    output wire ack          // Acknowledge to master
);

    // Internal signals and registers
    reg [7:0] data_in;
    reg [7:0] received_data;
    reg [2:0] state;

    // Constants for I2C states
    localparam IDLE_STATE = 3'b000;
    localparam ADDRESS_STATE = 3'b001;
    localparam READ_STATE = 3'b010;

    // I2C state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE_STATE;
        end else begin
            case (state)
                IDLE_STATE: begin
                    if (scl == 0 && sda == 0) begin
                        state <= ADDRESS_STATE;
                    end
                end

                ADDRESS_STATE: begin
                    // Wait for address byte
                    if (scl == 1) begin
                        data_in <= sda;
                        state <= READ_STATE;
                    end
                end

                READ_STATE: begin
                    // Read data on clock rising edge
                    if (scl == 1) begin
                        received_data <= data_in;
                        state <= ADDRESS_STATE;
                    end
                end
            endcase
        end
    end

    // Acknowledge logic
    assign ack = (state == ADDRESS_STATE);

endmodule
