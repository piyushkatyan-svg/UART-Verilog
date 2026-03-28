`timescale 1ns / 1ps
module UART_RX #(
    parameter clk_freq = 50_000_000,
    parameter Baud_rate = 9600
)(
    input clk,
    input reset,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
);
    
    localparam clock_per_bit = clk_freq / Baud_rate;
    localparam HALF_BIT = clock_per_bit / 2;
    
    localparam IDLE = 2'd0,
               START = 2'd1,
               DATA = 2'd2,
               STOP = 2'd3;
               
    reg [1:0] state;
    reg [12:0] clk_cnt;
    reg [2:0] bit_index;
    reg [7:0] rx_shift;
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin 
            state <= IDLE;
            rx_done <= 0;
            clk_cnt <= 0;
            bit_index <= 0;
        end else begin 
            rx_done <= 0;
            
            case (state)
                IDLE: begin  
                    if (!rx) begin
                        // Start bit detected (rx goes LOW)
                        clk_cnt <= 0;
                        state <= START;
                    end
                end
                
                START: begin
                    // Wait for middle of start bit to confirm it's valid
                    if (clk_cnt == HALF_BIT) begin
                        if(!rx) begin
                            // Start bit confirmed
                            clk_cnt <= 0;
                            bit_index <= 0;
                            state <= DATA;
                        end else begin
                            // False alarm, return to IDLE
                            state <= IDLE;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                
                DATA: begin
                    if(clk_cnt == HALF_BIT) begin
                        rx_shift[bit_index] <= rx;
                        clk_cnt <= 0;
                        if(bit_index == 7) begin
                            // All 8 bits received, move to STOP bit
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                
                STOP: begin
                    if(clk_cnt == HALF_BIT) begin
                        rx_data <= rx_shift;
                        rx_done <= 1'b1;  // Pulse for 1 clock cycle
                        clk_cnt <= 0;
                        state <= IDLE;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
            endcase
        end
    end
    
endmodule