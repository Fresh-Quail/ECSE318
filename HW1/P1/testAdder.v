module testAdder;
        reg A, B, Cin;
        FA adder(A, B, Cin, C, S);

        initial begin
                $display("Time | A | B | Cin | Sum | Carry");
                $monitor($time,,"%b, %b, %b, %b, %b", A, B, Cin, S, C);
                #200;
        $finish;
        end
        //Start Sim

        initial begin
                A = 0;
                forever begin
                        #5 A = A + 1;
                end
        end

        initial begin   
                B = 0;
                forever begin
                        #10 B = B + 1;
                end
        end

        initial begin
                Cin = 0;
                forever begin
                        #20 Cin = Cin + 1;
                end
        end
endmodule
