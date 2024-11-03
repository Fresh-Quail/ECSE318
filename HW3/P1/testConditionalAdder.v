module testConditionalAdder;
//Inp/Out
        reg[7:0] A, B;
        reg Cin;
        wire[7:0] S, correct;
        conditionalAdder U1 (A, B, Cin, C, S);

        assign correct = A + B + Cin == S;
        initial begin
                $display("Time | A | B | Cin | Cout | Sum | Correctness");
                $monitor($time,,"%b, %b, %b, %b, %b: %d", A, B, Cin, C, S, correct);
                #200;
        $finish;
        end
        //Start Sim
	initial begin
                A = 0;
                forever begin
                        #5 A = A + 3;
                end
        end

        initial begin
                B = 0;
                forever begin
                        #40 B = B + 2;
                end
        end

        initial begin
                Cin = 1'b0;
                forever begin
                        #80 Cin = Cin + 1;
                end
        end
endmodule
