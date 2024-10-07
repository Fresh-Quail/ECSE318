module testSigned;
	reg signed [15:0] A, B, expected;
    reg [4:0] alu_code;
	wire signed [15:0] C;
    wire overflow;
    reg [2:0] CODE;
	FSM fsm(A, B, alu_code, C, overflow);

        initial begin
            $display("\t\tTime | A | B | OUT == EXP | OUT | EXPECTED | OVERFLOW | CODE");
            $monitor($time,,"%d, %d, %b, %d, %d, %b, %b", A, B, C == expected, C, expected, overflow, alu_code);
            #400;
        $finish;
        end

        // ALU Signed Tests
        initial begin
            $display("\t\tSigned ALU Operations");
            A = 27;
            #50 A = -25;

            #50 A = 27;
            #50 A = -25;
        end

        initial begin
            forever begin
                #5 A = A + 5;
            end
        end

        initial begin
            B = 10;
            #25 B = -44;
            #25 B = 14;
            #25 B = -32;

            #25 B = 10;
            #25 B = -44;
            #25 B = 14;
            #25 B = -32;
        end

        initial begin
            forever begin
                #5 B = B + 3;
            end
        end

        initial begin
            alu_code = 0;
            #100 alu_code = 2;
            #105;
            $display("\t\tTest Increment");
            A = 20; B = 21; alu_code = 4;
            #5 alu_code = 5; B = 20;
        end

        initial begin
            forever begin
                expected = alu_code == 0 ? A + B : 
                alu_code == 2 ? A - B :
                alu_code == 4 ? A + 1 : A - 1;
                #5;
            end
        end

        initial begin
            #215;
            alu_code = 0;
            $display("\t\tTest Overflow");
            A = 2 ** 14 + 4;
            B = 2 ** 14 - 2;
            #5;
            A = -(2 ** 14 + 5);
            B = -(2 ** 14 + 13);
            #5;
        end

endmodule