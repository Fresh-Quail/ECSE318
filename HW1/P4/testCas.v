module testCas;
//Inp/Out
        reg [3:0] A, B;
	reg Cin, control;
        wire [3:0] C, S;
        cas U1[3:0] (control, A, B, Cin, C, S);

        initial begin
                $display("Time | Control | A | B | Cin | Sum | Carry");
                $monitor($time,,"%b, %b, %b, %b, %b, %b", control, A, B, Cin, S, C);
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

	initial begin
		control = 0;
		forever begin
			#80 control = 1;
		end
	end
endmodule
