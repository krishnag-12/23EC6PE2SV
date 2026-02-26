`timescale 1ns/1ps

module top_tb;

    // Clock
    logic clk;

    initial clk = 0;
    always #5 clk = ~clk;   // 10ns period

    // Interface instance
    clock_if intf(clk);

    // DUT instance
    digital_clock_rtl dut (
        .clk     (clk),
        .rst     (intf.rst),
        .seconds (intf.seconds),
        .minutes (intf.minutes)
    );

    // Program block instance
    tb_program tb(intf);

endmodule
