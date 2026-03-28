`timescale 1ns / 1ps
 
module UART_tb;
    reg clk = 0, reset = 1;
    reg tx_start = 0;
    reg [7:0] tx_data;
    wire tx;
    wire rx_done;
    wire [7:0] rx_data;
    
    // Clock = 50 MHz (period = 20 ns)
    always #10 clk = ~clk;
    
    
    UART_TX #(50_000_000, 115200) dut_tx (
        .clk(clk), 
        .reset(reset), 
        .tx_start(tx_start), 
        .tx_data(tx_data), 
        .tx(tx),
        .tx_busy()
    );
    
    UART_RX #(50_000_000, 115200) dut_rx (
        .clk(clk), 
        .reset(reset), 
        .rx(tx), 
        .rx_data(rx_data), 
        .rx_done(rx_done)
    );
    
    // Waveform dumping for visualization
    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, UART_tb);
    end
    
    initial begin
        // Reset sequence
        @(posedge clk);
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(10) @(posedge clk);
        
        // Test 1: Send 0xA5 (10100101)
        $display("\n[Test 1] Sending 0xA5 at time %0t ns", $time);
        tx_data = 8'hA5;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        
        // Wait for reception with timeout
        fork
            wait(rx_done);
            begin
                repeat(50000) @(posedge clk);  // 1 ms timeout
                $error("TIMEOUT: rx_done never asserted");
                $finish;
            end
        join_any
        disable fork;
        
        // Verify received data
        repeat(10) @(posedge clk);
        if (rx_data == 8'hA5) begin
            $display("✓ PASS: Received 0x%h (Expected 0xA5)", rx_data);
        end else begin
            $error("✗ FAIL: Expected 0xA5, got 0x%h", rx_data);
        end
        
        // Test 2: Send 0x55 (01010101)
        repeat(50) @(posedge clk);
        $display("\n[Test 2] Sending 0x55 at time %0t ns", $time);
        tx_data = 8'h55;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        
        fork
            wait(rx_done);
            begin
                repeat(50000) @(posedge clk);
                $error("TIMEOUT: rx_done never asserted");
                $finish;
            end
        join_any
        disable fork;
        
        repeat(10) @(posedge clk);
        if (rx_data == 8'h55) begin
            $display("✓ PASS: Received 0x%h (Expected 0x55)", rx_data);
        end else begin
            $error("✗ FAIL: Expected 0x55, got 0x%h", rx_data);
        end
        
        // Test 3: Send 0xFF (11111111)
        repeat(50) @(posedge clk);
        $display("\n[Test 3] Sending 0xFF at time %0t ns", $time);
        tx_data = 8'hFF;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
        
        fork
            wait(rx_done);
            begin
                repeat(50000) @(posedge clk);
                $error("TIMEOUT: rx_done never asserted");
                $finish;
            end
        join_any
        disable fork;
        
        repeat(10) @(posedge clk);
        if (rx_data == 8'hFF) begin
            $display("✓ PASS: Received 0x%h (Expected 0xFF)", rx_data);
        end else begin
            $error("✗ FAIL: Expected 0xFF, got 0x%h", rx_data);
        end
        $finish;
    end
    
endmodule
 