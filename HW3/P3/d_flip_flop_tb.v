module d_flip_flop_tb;

    // Inputs
    reg d;
    reg clk;
    reg clear;
    reg set;

    // Outputs
    wire q;

    // Instantiate the Unit Under Test (UUT)
    d_flip_flop uut (
        .d(d),
        .clk(clk),
        .clear(clear),
        .set(set),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        d = 0;
        clear = 1;
        set = 1;

        // Wait 10 ns for global reset
        #10;

        // Test Case 1: Set active (set = 0)
        set = 1;
        #10;
        set = 0;  // Release set

        // Test Case 2: Clear active (clear = 0)
        clear = 1;
        #10;
        clear = 0;  // Release clear

        // Test Case 3: Normal operation (set and clear inactive)
        d = 1;
        #10;
        d = 0;
        #10;
        d = 1;
        #10;

        // Test Case 4: Toggle d during normal operation
        d = 1;
        #10;
        d = 0;
        #10;
        d = 1;
        #10;
        d = 0;
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0t | d = %b | clk = %b | clear = %b | set = %b | q = %b",
                  $time, d, clk, clear, set, q);
    end

endmodule