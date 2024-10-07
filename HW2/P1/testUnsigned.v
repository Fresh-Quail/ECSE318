module testUnSigned;
	reg [15:0] A, B, expected;
    reg [4:0] alu_code;
	wire [15:0] C;
    wire overflow;
	FSM fsm(A, B, alu_code, C, overflow);

        initial begin
            $display("\t\tTime | A | B | OUT == EXP | OUT | EXPECTED | OVERFLOW | CODE");
            $monitor($time,,"%d, %d, %b, %d, %d, %b, %b", A, B, C == expected, C, expected, overflow, alu_code);
            #400;
        $finish;
        end

        // ALU Tests
        initial begin
            $display("\t\tUnsigned ALU Operations");
            A = 27;
                forever begin
                    #5 A = A + 5;
                end
        end

        initial begin
            B = 10;
                forever begin
                    #5 B = B + 3;
                end
        end

        initial begin
            alu_code = 1;
            #50 alu_code = 3;
        end
        
        initial begin
            forever begin
                expected = alu_code == 1 ? A + B : A - B;
                #5;
            end
        end
endmodule
