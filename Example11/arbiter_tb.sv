//------------------------------------------------------------------------------
//File       : arbiter_tb.sv
//Author     : Krishna Gupta/1BM23EC123
//Created    : 2026-01-28
//Module     : tb
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Arbiter used for basic functional coverage example.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module tb;
  logic clk = 0, rst;
  logic [3:0] req, gnt;
  
  always #5 clk = ~clk;
  
  arbiter dut(.*);
  
  // Assertion to catch illegal states
  assert property (@(posedge clk) $onehot0(gnt))
    else $error("Protocol Violation: Multiple Grants!");

  covergroup cg_arb @(posedge clk);
    
    // 1. INPUT COVERAGE
    cp_req: coverpoint req {
      bins all_inputs[] = {[0:15]};
    }
    
    // 2. OUTPUT COVERAGE
    cp_gnt: coverpoint gnt {
      bins valid_grants[] = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
  endgroup

  cg_arb cg; 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    cg = new();
    
    rst = 1; req = 0;
    #15;
    rst = 0;
    
    repeat(100) begin
      req = $urandom(); 
      @(posedge clk);
    end
    
    $display("Final Coverage: %0.2f %%", cg.get_inst_coverage());
    $finish;
  end
endmodule
