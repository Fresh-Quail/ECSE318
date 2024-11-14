module FIFO(PSEL, PWRITE, CLEAR_B, PCLK, IN_DATA, OUT_DATA);
input PSEL, PWRITE, CLEAR_B, PCLK;
input [7:0] IN_DATA;
output [7:0] OUT_DATA;

reg [7:0] memory [3:0];

always @ (posedge PCLK) begin
	if(PWRITE)
		memory[2] = memory[3];
		memory[1] = memory[2];
		memory[0] = memory[1];
end

endmodule
