module RxFIFO(PSEL, PWRITE, CLEAR_B, PCLK, IN_DATA, OUT_DATA, SSPRXINTR, ready);
input PSEL, PWRITE, CLEAR_B, PCLK;
input [7:0] IN_DATA;
output [7:0] OUT_DATA;
output SSPTXINTR, ready;

reg [7:0] memory [3:0];
reg [1:0] readptr, wrtptr;
reg ready, SSPTXINTR;

assign OUT_DATA = memory[readptr];

always @ (posedge PCLK) begin
	if(CLEAR_B) begin
		wrtptr <= 2'b0; 	// Represents lowest empty location
		readptr <= 2'b0; 	// Represents lowest non-empty location
		ready <= 1'b0;		// Signal to Logic module that data is ready (nonempty)
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

	// If readptr is not at wrtptr, the FIFO is non-empty
	// Otherwise if they are equal and SSPTXINTR is 1, it is nonempty
	if(wrtptr != readptr || SSPTXINTR) 
		ready = 1'b1;
	else
		ready = 1'b0;
end

always @ (negedge PCLK) begin
	// If SSP active and FIFO nonempty
	// Increment counter and 'write data out' (on negedge in peripheral)
	if(PSEL && ready)
		readptr = readptr + 2'b1;
end
endmodule
