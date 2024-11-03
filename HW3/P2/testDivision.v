module testDivision;
//Inp/Out
        reg[3:0] M, D;
	wire [3:0] Q, R;
        division div (M, D, Q, R);

        initial begin
                $display("Time | Divisor | Dividend | Quotient | Remainder");
                $monitor($time,,"%b, %b, %b, %b", M, D, Q, R);
                #200;
        $finish;
        end
        //Start Sim

        initial begin
                M = 2;
		#10 M = 4;
        end

        initial begin
                D = 7;
		#5 D = 6;
		#5 D = 9;
        end
endmodule
