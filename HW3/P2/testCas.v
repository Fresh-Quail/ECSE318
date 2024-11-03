module testCas;
//Inp/Out
        reg [3:0] A, B;
	reg  control;
        wire C;
        wire [3:0] S;

        cas U1(control, A, B, C, S);

        initial begin
                $display("Time | Control | A | B | Sum | Carry");
                $monitor($time,,"%b, %b, %b, %b, %b", control, A, B, S, C);
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
		control = 0;
		forever begin
			#80 control = 1;
		end
	end
endmodule
