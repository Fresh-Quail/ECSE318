module testStage2;
//Inp/Out
        reg[1:0] A, B, Sin;
        reg Cin;
        wire C;
        wire[3:0] S;
        stage2 U1 (A, B, Cin, Sin, C, S);

        initial begin
                $display("Time | A | B | Sin | Cin | Carry | Sum");
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
                        #20 B = B + 1;
                end
        end

        initial begin
                Cin = 1'b0;
                forever begin
                        #40 Cin = Cin + 1;
                end
        end

        initial begin
                Sin = 2'b00;
                forever begin
                        #80 Sin = Sin + 1;
                end
        end

endmodule
