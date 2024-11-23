module traffic_light_controller_tb;

    reg Sa  ;
    reg Sb ;
    reg clk ;
    reg rst ;

    wire Ga ;
    wire Ya ;
    wire Ra ;
    wire Gb ;
    wire Yb ;
    wire Rb; 
    wire[3:0] state_test;

    // uut
    traffic_light_controller uut (
    .Sa(Sa),
    .Sb(Sb),
    .clk(clk),
    .rst(rst),
    .Ga(Ga),
    .Ya(Ya),
    .Ra(Ra),
    .Gb(Gb),
    .Yb(Yb),
    .Rb(Rb),
    .state_test(state_test)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        rst = 1;
        #5;
        rst = 0;
        #10;
        rst = 1;
        #5;
        rst = 0;
        #10;
        Sa = 1;
        Sb = 1;
        #15;
        Sa = 0;
        Sb = 0;
        rst = 1;
        #5;
        rst = 0; 
        #60;
        Sa = 0;
        Sb = 1;
        #30;
    
        Sb = 1;
        #40;
        Sa = 1;
        Sb = 0;
        #30;
        Sa = 1;


             

        

        #50;
        $finish;  
    end

    
    initial begin
        $display("\t\tTime | Sa| Sb | rst| Ga | Ya | Ra | Gb | Rb| Rb| state_test");
        $monitor("Time = %0dns, Sa = %b, Sb = %b, rst = %b, Ga = %b, Ya = %b, Ra = %b, Gb = %b, Yb = %b, Rb = %b, state_test = %d", 
                 $time, Sa, Sb, clk, rst, Ga, Ya, Ra, Gb, Yb, Rb, state_test);
    end
   

endmodule