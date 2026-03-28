`timescale 1ns / 1ps
module UART_TX #(
    parameter clk_freq = 50_000_000,
    parameter Baud_rate = 9600
)(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    
    localparam clock_per_bit = clk_freq / Baud_rate;
    localparam IDLE = 3'd0,
               START = 3'd1,
               DATA = 3'd2,
               STOP = 3'd3;
    
    reg [2:0] state;
    reg [12:0] clk_cnt;      // baud rate counter
    reg [2:0] bit_index;     // which data bit we are sending
    reg [7:0] tx_shift;      // shift register for data
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            clk_cnt <= 0;
            bit_index <= 0;
        end else begin
            case (state) 
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    
                    if(tx_start) begin
                        tx_shift <= tx_data;
                        tx_busy <= 1'b1;
                        clk_cnt <= 0;
                        state <= START;
                    end
                end 
                
                START: begin
                    tx <= 1'b0;  // Send start bit (LOW)
                    if(clk_cnt == clock_per_bit - 1) begin
                        clk_cnt <= 0;
                        bit_index <= 0;
                        state <= DATA;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                
                DATA: begin
                    tx <= tx_shift[bit_index];
                    if(clk_cnt == clock_per_bit - 1) begin
                        clk_cnt <= 0;
                        if(bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                
                STOP: begin
                    tx <= 1'b1;  // Send stop bit (HIGH)
                    if(clk_cnt == clock_per_bit - 1) begin
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