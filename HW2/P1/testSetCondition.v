module testSetCondition;
	reg signed [15:0] A, B;
    reg [4:0] alu_code;
	wire [15:0] C;
    wire overflow;
	FSM fsm(A, B, alu_code, C, overflow);

    initial begin
            $display("\t\tTime | A | B | OUT | OVERFLOW | CODE");
            $monitor($time,,"%d, %d, %d, %b, %b", A, B, C, overflow, alu_code);
            #400;
        $finish;
        end
    // Set Condition Tests   
    initial begin
        $display("\t\tALU Operations");
        // Test if not equal
        A = 27;  // Test if equal
        #20;
        forever begin // comparisons
            #10 A = -A;
        end
    end

    initial begin
        B = 27; // Test if equal
        #25 B = 10;  // Test if not equal
        forever begin // comparisons
            #5 B = -B;
        end
    end


        initial begin
            alu_code = 5'b11000;
            #5 alu_code = 5'b11001;
            #5 alu_code = 5'b11010;
            #5 alu_code = 5'b11011;
            #5 alu_code = 5'b11100;
            #5 alu_code = 5'b11101;

            #5 alu_code = 5'b11101;
            #5 alu_code = 5'b11000; 
            #20 alu_code = 5'b11001;
            #20 alu_code = 5'b11010;
            #20 alu_code = 5'b11011;
        end

endmodule