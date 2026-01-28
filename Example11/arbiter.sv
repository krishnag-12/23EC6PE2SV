//------------------------------------------------------------------------------
//File       : arbiter.sv
//Author     : Krishna Gupta/1BM23EC123
//Created    : 2026-01-28
//Module     : arbiter
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Arbiter used for basic functional coverage example.
//------------------------------------------------------------------------------

module arbiter(
  input logic clk, rst,
  input logic [3:0] req,
  output logic [3:0] gnt
);
  always_ff @(posedge clk) begin
    if(rst)
      gnt <= 4'b0001;
    else
      case(req)
        4'b0001: gnt <= 4'b0001;
        4'b0010: gnt <= 4'b0010;
        4'b0100: gnt <= 4'b0100;
        4'b1000: gnt <= 4'b1000;
        default: gnt <= 4'b0001; 
      endcase
  end
endmodule
