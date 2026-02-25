program automatic tb_program(clock_if.tb vif);

    // Functional Coverage Definition
    covergroup clock_cg @(posedge vif.clk);
        // Cover all values and the specific 59 -> 0 transition for seconds
        cp_seconds: coverpoint vif.seconds {
            bins all_vals[]  = {[0:59]};
            bins rollover    = (59 => 0);
            illegal_bins inv = {[60:$]};
        }
        
        // Cover all values and the specific 59 -> 0 transition for minutes
        cp_minutes: coverpoint vif.minutes {
            bins all_vals[]  = {[0:59]};
            bins rollover    = (59 => 0);
            illegal_bins inv = {[60:$]};
        }
        
        // Cross coverage to ensure all seconds/minutes combinations are hit
        cross_sec_min: cross cp_seconds, cp_minutes;
    endgroup

    // Instantiate coverage group
    clock_cg cg;

    initial begin
        cg = new();
        
        $display("[%0t] Starting Digital Clock Verification...", $time);
        
        // Apply Synchronous Reset
        vif.rst = 1;
        @(posedge vif.clk);
        @(posedge vif.clk);
        vif.rst = 0;
        $display("[%0t] Reset de-asserted. Counters should be 00:00.", $time);

        // Run simulation long enough to cover a full 59:59 -> 00:00 rollover
        // 60 minutes * 60 seconds = 3600 clock cycles. 
        // We run for 3610 cycles to comfortably capture the 59->0 transition on minutes.
        repeat (3610) begin
            @(posedge vif.clk);
        end

        // Check and report coverage
        $display("[%0t] Simulation complete.", $time);
        $display("Final Time -> Minutes: %0d, Seconds: %0d", vif.minutes, vif.seconds);
        $display("Functional Coverage: %0.2f%%", cg.get_coverage());
        
        if (cg.get_coverage() == 100.0)
            $display("SUCCESS: 100%% Coverage Achieved!");
        else
            $warning("Coverage is not 100%%. Check stimulus duration.");
            
    end
endprogram
