module testLogic;
	reg [15:0] A, B;
    reg [4:0] alu_code;
	wire [15:0] C;
    wire overflow;
	FSM fsm(A, B, alu_code, C, overflow);

        initial begin
            $display("\t\tTime | A | B | OUT | CODE");
            $monitor($time,,"%b, %b, %b, %b", A, B, C, alu_code);
            #20;
        $finish;
        end

        // ALU Tests
        initial begin
            $display("\t\tLogic Operations");
            A = 58;
        end

        initial begin
            B = 555;
        end

        initial begin
            alu_code = 5'b01000;
            #5 alu_code = 5'b01001;
            #5 alu_code = 5'b01010;
            #5 alu_code = 5'b01100;
        end
endmodule
