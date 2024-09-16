module testStage3;
//Inp/Out
        reg[3:0] A, B, Sin;
        reg Cin;
        wire C;
        wire[7:0] S;
        stage3 U1 (A, B, Cin, Sin, C, S);

        initial begin
                $display("Time | A | B | Sin | Cin | Cout | Sum");
                $monitor($time,,"%b, %b, %b, %b, %b, %b", A, B, Sin, Cin, C, S);
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
                        #40 B = B + 1;
                end
        end

        initial begin
                Cin = 1'b0;
                forever begin
                        #80 Cin = Cin + 1;
                end
        end

        initial begin
                Sin = 4'b00;
                forever begin
                        #80 Sin = Sin + 1;
                end
        end

endmodule
