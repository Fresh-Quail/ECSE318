module tb_4bit_cla();
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] sum;
    wire Cout;

    sumGenerator uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .sum(sum),
        .Cout_final(Cout)
    );

    initial begin
       A = 4'b0101; B = 4'b0011; Cin = 1'b0;
        #100; // wait 100 time units
        $display("A=%b B=%b Cin=%b -> Sum=%b Cout=%b", A, B, Cin, sum, Cout);

        // test case 2
        A = 4'b1101; B = 4'b1010; Cin = 1'b1;
        #100; // wait 100 time units
        $display("A=%b B=%b Cin=%b -> Sum=%b Cout=%b", A, B, Cin, sum, Cout);

         A = 4'b1001; B = 4'b1100; Cin = 1'b1;
        #100; // wait 100 time units
        $display("A=%b B=%b Cin=%b -> Sum=%b Cout=%b", A, B, Cin, sum, Cout);

        // test case 3 
        A = 4'b1111; B = 4'b1111; Cin = 1'b1;
        #800; // wait 800 time units
        $display("A=%b B=%b Cin=%b -> Sum=%b Cout=%b", A, B, Cin, sum, Cout);

        $finish;   
    end

endmodule

