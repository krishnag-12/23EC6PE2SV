//------------------------------------------------------------------------------
//File       : digital_clock_tb.sv
//Author     : Krishna Gupta/1BM23EC123
//Created    : 2026-01-28
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Basic Digital Clock used for basic functional coverage example.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module tb;
  logic clk = 0;
  logic rst;
  logic [5:0] sec, min;
  
  always #5 clk = ~clk;

  digital_clock dut (.*);

  // Task 2: Covergroup with Transition Bins
  covergroup cg_clock @(posedge clk);
    
    // Coverpoint for Seconds
    cp_sec: coverpoint sec {
      // Task 3 Goal: Verify transition 59 -> 0
      bins rollover = (59 => 0); 
    }

    // Coverpoint for Minutes
    cp_min: coverpoint min;

    // Checks if 'min' changes exactly when 'sec' rolls over
    cross_rollover: cross cp_sec, cp_min; 

  endgroup

  cg_clock cg;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    cg = new();

    // Reset
    rst = 1; 
    repeat(5) @(posedge clk);
    rst = 0;

    $display(" Starting Digital Clock Verification ");

    // 60 seconds * 3 minutes = 180 cycles approx.
    repeat (200) begin 
      @(posedge clk);
      
      // Monitor logic to visually confirm the transition
      if (sec == 0 && min > 0)
        $display("Time: %0d:%0d (Rollover Detected)", min, sec);
    end

    $display(" Final Coverage: %0.2f %%", cg.get_inst_coverage());

    // Check specifically if we hit the rollover bin
    if (cg.cp_sec.get_inst_coverage() > 0)
      $display(" STATUS: PASSED (Sec Rollover 59=>0 Verified)");
    else
      $display(" STATUS: FAILED (Rollover Bin Missed)");
    $finish;
  end
endmodule
