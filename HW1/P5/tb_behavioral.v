module tb_behavioral();
reg x1, x2;
wire s1, s2, z1, z2;

behavioral_circuit uut (
        .x1(x1),
        .x2(x2),
        .s1(s1),
        .s2(s2),
        .z1(z1),
        .z2(z2)
    );


     initial begin
        x1 = 0;
        x2 = 0;
        $display("Time\t x1 x2 | s1 s2 | z1 z2");
        $monitor("%0t\t %b  %b  | %b  %b  | %b  %b", $time, x1, x2, s1, s2, z1, z2);


        //  x1 = 0, x2 = 0
        x1 = 0; x2 = 0;
        #50;  //50 time units

        //  x1 = 0, x2 = 1
        x1 = 0; x2 = 1;
        #50;  //50 time units

        // T x1 = 1, x2 = 0
        x1 = 1; x2 = 0;
        #50;  //50 time units

        //  x1 = 1, x2 = 1
        x1 = 1; x2 = 1;
        #50;  //50 time units

        x1 = 0; x2 = 1;
        #50;  //50 time units

        x1 = 1; x2 = 0;
        #50;  //50 time units

        x1 = 0; x2 = 0;
        #50;  //50 time units

        x1 = 0; x2 = 1;
        #50;  //50 time units

         x1 = 1; x2 = 1;
        #50;  //50 time units

        x1 = 0; x2 = 1;
        #50;  //50 time units

        x1 = 0; x2 = 1;
        #50;  //50 time units


        
        $finish;
    end

endmodule

