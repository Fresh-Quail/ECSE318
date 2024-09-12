module testConcat;
//Inp/Out
        parameter N = 4;
        reg[N-1:0] A, B;
        wire[2*N-1:0] Out;
        concat #(N) U1 (A, B, Out);

        initial begin
                $display("Time | A | B | Concat");
                $monitor($time,,"%b, %b, %b", A, B, Out);
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
endmodule