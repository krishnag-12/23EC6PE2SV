module digital_clock (clock_if.dut dif);

    always_ff @(posedge dif.clk) begin
        if (dif.rst) begin
            dif.seconds <= 0;
            dif.minutes <= 0;
        end else begin
            // Rollover logic for seconds
            if (dif.seconds == 59) begin
                dif.seconds <= 0;
                
                // Rollover logic for minutes
                if (dif.minutes == 59) begin
                    dif.minutes <= 0;
                end else begin
                    dif.minutes <= dif.minutes + 1;
                end
                
            end else begin
                dif.seconds <= dif.seconds + 1;
            end
        end
    end

endmodule
