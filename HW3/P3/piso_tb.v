module piso_tb;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg [7:0] data;

    // Output
    wire piso_output;

    // Instantiate the Unit Under Test (UUT)
    piso uut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .enable(enable),
        .piso_output(piso_output)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        data = 8'b11010101;
        reset = 1;
        enable = 1;

        // Apply reset
        #10 reset = 0;  // Activate reset (assuming falling edge active)
        #10 reset = 1;  // Release reset

        // Test Case 1: Shift out data with enable active
        enable = 0;
        #10 data = 8'b11010101; // Load data to be shifted out
        #160 enable = 1;          // Disable shifting after 8 clock cycles

        // Test Case 2: Load new data and shift
        #10 enable = 1;
        reset = 0;
        data = 8'b10011010;
        #20 enable = 0;
        reset = 1; 
        #160         // Disable shifting

        // Finish simulation
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t | Data = %b | Reset = %b | Enable = %b | Output = %b",
                  $time, data, reset, enable, piso_output);
    end

endmodule