module serial_adder_tb;

    // Inputs
    reg clear;
    reg set;
    reg clk;
    reg [7:0] addend;
    reg [7:0] augand;

    // Outputs
    wire addend_output;
    wire augand_output;
    wire sum_output;
    wire Cin;
    wire Cout;

    // Instantiate the Unit Under Test (UUT)
    serial_adder uut (
        .clear(clear),
        .set(set),
        .clk(clk),
        .addend(addend),
        .augand(augand),
        .addend_output(addend_output),
        .augand_output(augand_output),
        .sum_output(sum_output),
        .C_in(Cin),
        .Cout(Cout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        clear = 1;    // Start with clear inactive (high)
        set = 1;      // Start with set inactive (high)

        // Apply clear and set signals to reset the design
        #10 clear = 0;  // Assert clear (active low) to reset the design
        #20 clear = 1;  // Release clear (inactive high)

        // Test case 1: 6 + 4
        addend = 8'b00000110;  // 6 in binary
        augand = 8'b00000100;  // 4 in binary
        #10 set = 0;            // Assert set (active low) to enable shifting
        #100 set = 1;           // Deactivate set after the shift to stop shifting

        // Apply clear to reset the design before the next test case
        #20 clear = 0;  
        addend = 8'b00000111;  // 7 in binary
        augand = 8'b00000011;         // Assert clear to reset
        #60 clear = 1;          // Release clear

        // Test case 2: 7 + 3
       // addend = 8'b00000111;  // 7 in binary
        //augand = 8'b00000011;  // 3 in binary
        set = 0;            // Assert set (active low) to enable shifting
        #200 set = 1;           // Deactivate set after the shift to stop shifting
        #20 clear = 0;
        addend = 8'b00000110;  // 6 in binary
        augand = 8'b00000110; 
        #40 set = 0;
        clear =1;
        
        #140;

        #50;
        $finish;  // End of simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time = %0dns, clk = %b, set = %b, clear = %b, addend_output = %b, augand_output = %b, sum_output = %b, Cin = %b, Cout = %b", 
                 $time, clk, set, clear, addend_output, augand_output, sum_output, Cin, Cout);
    end

endmodule