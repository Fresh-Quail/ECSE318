module serial_adder_tb;

    
    reg clear;
    reg set;
    reg clk;
    reg [7:0] addend;
    reg [7:0] augand;

    
    wire addend_output;
    wire augand_output;
    wire sum_output;
    wire Cin;
    wire Cout;
    wire sum_reg;

    // uut
    serial_adder uut (
        .clear(clear),
        .set(set),
        .clk(clk),
        .addend(addend),
        .augand(augand),
        .addend_output(addend_output),
        .augand_output(augand_output),
        .sum_output(sum_output),
        .sum_register(sum_reg),
        .C_in(Cin),
        .Cout(Cout)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    initial begin
        
        clear = 1;    
        set = 1;     

        //reset the design
        #10 clear = 0;  
        #20 clear = 1;  

        // test case: 6+4
        addend = 8'b00000110;  
        augand = 8'b00000100; 
        #10 set = 0;            
        #100 set = 1;          

        //reset the design before the next test case
        // test case : 7+3
        #20 clear = 0;  
        addend = 8'b00000111;  
        augand = 8'b00000011;         
        #55 clear = 1;          

        // test case: 6+4
        set = 0;            
        #200 set = 1;           
        #20 clear = 0;
        addend = 8'b00000110;  
        augand = 8'b00000100; 
        #40 set = 0;
        clear =1;
        
        #140;

        #50;
        $finish;  
    end

    
    initial begin
        $monitor("Time = %0dns, clk = %b, set = %b, clear = %b, addend_output = %b, augand_output = %b, sum_output = %b, Cin = %b, Cout = %b", 
                 $time, clk, set, clear, addend_output, augand_output, sum_output, sum_reg, Cin, Cout);
    end
   

endmodule