module testShift;
	reg [15:0] A, B;
    reg [4:0] alu_code;
	wire [15:0] C;
    wire overflow;
	FSM fsm(A, B, alu_code, C, overflow);

    initial begin
            $display("\t\tTime | A | B | OUT | OVERFLOW | CODE");
            $monitor($time,,"%b, %b, %b, %b, %b", A, B[3:0], C, overflow, alu_code);
            #400;
        $finish;
        end
    // Set Condition Tests   
    initial begin
        $display("\t\tShift Operations");
        // Test if not equal
        A = 29;  // Test if equal
        forever begin // comparisons
            #10 A = -A;
        end
    end

    initial begin
        B = 19; // Test if equal
        forever begin // comparisons
            #20 B = -B;
        end
    end

     initial begin
        alu_code = 5'b10000;
        forever begin // comparisons
            #40 alu_code = alu_code + 1'b1;
        end
    end

endmodule