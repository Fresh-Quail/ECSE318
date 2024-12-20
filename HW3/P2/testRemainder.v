module testRemainder;
//Inp/Out
        reg[3:0] Sum, Divisor;
        wire [3:0] Remainder;
        remainder U1(Sum[3], Sum, Divisor, 1'b0, Remainder);

        initial begin
                $display("Time | Sum | Divisor | Remainder");
                $monitor($time,,"%b, %b, %b", Sum, Divisor, Remainder);
                #200;
        $finish;
        end
        //Start Sim

        initial begin
                Divisor = 11;
                forever begin
                        #5 Divisor = Divisor + 1;
                end
        end

        initial begin
                Sum = -7;
                forever begin
                        #20 Sum = 3; Divisor = 11;
                end
        end
endmodule
