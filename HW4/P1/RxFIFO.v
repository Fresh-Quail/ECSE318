module RxFIFO(PSEL, PWRITE, CLEAR_B, PCLK, IN_DATA, OUT_DATA, SSPRXINTR, write);
input PSEL, PWRITE, CLEAR_B, PCLK, write;
input [7:0] IN_DATA;
output [7:0] OUT_DATA;
output SSPRXINTR;

reg [7:0] memory [3:0];
reg [1:0] readptr, wrtptr;
reg SSPRXINTR;

assign OUT_DATA = memory[readptr];

always @ (posedge PCLK) begin
	if(CLEAR_B) begin
		wrtptr <= 2'b0; 	// Represents lowest empty location
		readptr <= 2'b0; 	// Represents lowest non-empty location
		SSPRXINTR <= 1'b0; 	// If points are equal, this denotes if the queue is full/empty
	end

	if(write) begin
		if(~SSPRXINTR) begin
			memory[wrtptr] = IN_DATA;
			wrtptr = wrtptr + 2'b1;
		end
		// After addition, check if wrtprt if equal to readptr
		// If so, FIFO is full (if after write ptrs are equal fifo is full)
		// (b/c before write we guarantee it is not full)
		if(wrtptr == readptr)
			SSPRXINTR = 1'b1;
		else
			SSPRXINTR = 1'b0;
	end
end

always @ (negedge PCLK) begin
	// If SSP active and FIFO nonempty, and we want to read
	// Increment counter and 'write data out' (on negedge in peripheral)
	if(PSEL && ~PWRITE)
		readptr = readptr + 2'b1;
end
endmodule
