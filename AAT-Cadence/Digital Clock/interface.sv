interface clock_if (input logic clk);
    logic       rst;
    logic [5:0] seconds;
    logic [5:0] minutes;

    // DUT Modport: Design drives outputs, reads inputs
    modport dut (
        input  clk, rst,
        output seconds, minutes
    );

    // TB Modport: Testbench drives inputs, reads outputs
    modport tb (
        input  clk, seconds, minutes,
        output rst
    );

    // Assertions: Verify counters never exceed 59
    // Disabled during reset to prevent false failures during initialization
    property p_seconds_max;
        @(posedge clk) disable iff (rst) (seconds <= 59);
    endproperty

    property p_minutes_max;
        @(posedge clk) disable iff (rst) (minutes <= 59);
    endproperty

    assert_sec_max: assert property (p_seconds_max) 
        else $error("Assertion Failed: Seconds reached %0d, exceeding 59!", seconds);
        
    assert_min_max: assert property (p_minutes_max) 
        else $error("Assertion Failed: Minutes reached %0d, exceeding 59!", minutes);

endinterface
