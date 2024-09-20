module testNCSA;
	wire [15:0] out1;
	wire [13:0] out2;
        reg [79:0] In1;
       	reg [63:0] In2; 
	ncsa #(.N(8), .K(10)) csa10(In1, out1);
	ncsa #(.N(8), .K(8)) csa8(In2, out2);

        initial begin
                $display("Time | Sum10 | Sum8");
                $monitor($time,,"%b, %b", out1, out2);
                #200;
        $finish;
        end
        //Start Sim

        initial begin
	In1 = {8'b01011, 8'b010, 8'b01101, 8'b0100, 8'b0101, 8'b0110, 8'b0111, 8'b01000, 8'b01001, 8'b01010};
        In2 = {8'b0011, 8'b01110, 8'b0101, 8'b0110, 8'b0111, 8'b01000, 8'b010011, 8'b01010};
                forever begin
                        #5; 
                end
        end
endmodule
