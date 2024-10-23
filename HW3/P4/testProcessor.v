module testProcessor;
	reg [15:0] clk;
	wire [15:0] C;
    

        initial begin
            $display("\t\tTime | A | B | OUT | CODE");
            $monitor($time,,"%b, %b, %b, %b", A, B, C, alu_code);
            #20;
        $finish;
        end

        // ALU Tests
        initial begin

        end

        initial begin

        end

        initial begin
            
        end
endmodule
