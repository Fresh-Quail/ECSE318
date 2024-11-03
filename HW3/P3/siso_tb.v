module siso_tb;

    // Inputs
    reg clk;
    reg set;
    reg reset;
    reg siso_input;

    // Outputs
    wire siso_output;

    // Instantiate the Unit Under Test (UUT)
    siso uut (
        .clk(clk), 
        .set(set), 
        .reset(reset), 
        .siso_input(siso_input), 
        .siso_output(siso_output)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;     // Deassert reset (inactive high)
        set = 1;       // Deassert set (inactive high)
        siso_input = 0;

        // Apply reset
        #10 reset = 0; // Assert reset (active low)
        #20 reset = 1; // Deassert reset (inactive high)
        
        // Apply set to enable shift
        #10 set = 0;   // Assert set (active low)

        // Apply test sequence
        #10 siso_input = 1;  // Shift in a '1'
        #10 siso_input = 0;  // Shift in a '0'
        #10 siso_input = 1;  // Shift in a '1'
        #10 siso_input = 1;  // Shift in another '1'
        #10 siso_input = 0;  // Shift in a '0'

        // Hold for several cycles to observe shifting
        #50;
        
        // Reset the system again to observe clearing
        reset = 0;    // Assert reset (active low)
        #10 reset = 1; // Deassert reset (inactive high)
        
        // Apply another sequence after reset
        #10 siso_input = 1;
        #10 siso_input = 0;
        #10 siso_input = 1;
        #10 siso_input = 1;
        
        #50;
        $finish;  // End of simulation
    end

    // Monitor output changes
    initial begin
        $monitor("Time = %0dns, clk = %b, set = %b, reset = %b, siso_input = %b, siso_output = %b", 
                 $time, clk, set, reset, siso_input, siso_output);
    end

endmodule