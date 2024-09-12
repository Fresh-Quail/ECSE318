module testStage1;
//Inp/Out
        reg[1:0] A, B;
        reg Cin;
        wire C;
        wire[1:0] S;
        stage1 U1 (A, B, Cin, C, S);

        initial begin
                $display("Time | A | B | Cin | Carry | Sum");
                $monitor($time,,"%b, %b, %b, %b, %b", A, B, Cin, C, S);
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
                Cin = 0;
                forever begin
                        #40 Cin = Cin + 1;
                end
        end
endmodule