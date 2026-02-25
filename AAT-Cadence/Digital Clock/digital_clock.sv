module digital_clock_rtl (
    input  logic       clk,
    input  logic       rst,      // Active-high synchronous reset
    output logic [5:0] seconds,
    output logic [5:0] minutes
);

    always_ff @(posedge clk) begin
        if (rst) begin
            // Synchronous reset initializes both counters to 0
            seconds <= 6'd0;
            minutes <= 6'd0;
        end else begin
            // Rollover logic for seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0; // Reset seconds after 59
                
                // Rollover logic for minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0; // Reset minutes after 59:59
                end else begin
                    minutes <= minutes + 6'd1; // Increment minutes
                end
                
            end else begin
                // Normal seconds increment
                seconds <= seconds + 6'd1;
            end
        end
    end

endmodule
