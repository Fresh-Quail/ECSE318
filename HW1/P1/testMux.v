module testMux;
//Inp/Out
        parameter N = 4;
        reg sel;
        reg[N-1:0] A, B;
        wire[N-1:0] Out;
        mux #(N) U1 (sel, A, B, Out);

        initial begin
                $display("Time - Sel | A | B | Mux");
                $monitor($time,, "%b, %b %b, %b", sel, A, B, Out);
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
                sel = 0;
                forever begin
                        #40 sel = !sel;
                end
        end
endmodule