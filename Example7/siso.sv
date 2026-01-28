//------------------------------------------------------------------------------
//File       : siso.sv
//Author     : Krishna Gupta/1BM23EC123
//Created    : 2026-01-24
//Module     : siso
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Serial In Serial Out Shift Register used for basic functional coverage example.
//------------------------------------------------------------------------------

module siso(
  input clk, rst,
  input si,
  output logic so
);
  logic [3:0] q;
  
  assign so = q[3];
  
  always_ff @(posedge clk or posedge rst) begin
    if (rst) 
      q <= 4'b0000;
    else 
      q <= {q[2:0], si};
  end
endmodule
