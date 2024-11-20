module ssp(PCLK, CLEAR_B, PSEL, PWRITE, PWDATA, SSPCLKIN, SSPFSSIN, SSPRXD,
		PRDATA, SSPOE_B, SSPTXD, SSPCLKOUT, SSPFSSOUT, SSPTXINTR, SSPRXINTR);
input PCLK, CLEAR_B, PSEL, PWRITE, SSPCLKIN, SSPFSSIN, SSPRXD;
input [7:0] PWDATA;
output SSPOE_B, SSPTXD, SSPCLKOUT, SSPFSSOUT, SSPTXINTR, SSPRXINTR;
output [7:0] PRDATA;

wire [7:0] Tx, Rx;

reg SSPCLKOUT, SSPTXD, SSPOE_B, SSPFSSOUT;
reg [3:0] tcount, rcount;
reg [7:0] TxData, RxData;
reg tread, rwrite;

TxFIFO TxFIFO(PSEL, PWRITE, CLEAR_B, PCLK, PWDATA, Tx, SSPTXINTR, tready, tread);
RxFIFO RxFIFO(PSEL, PWRITE, CLEAR_B, PCLK, RxData, PRDATA, SSPRXINTR, rwrite);

always @(posedge PCLK) begin
	if (~CLEAR_B) begin
	// Initialize output inactive high and counts
		SSPCLKOUT = 1'b0;
		SSPFSSOUT = 1'b0;
		SSPOE_B = 1'b1;
		tcount = 4'b0000;
		rcount = 4'b1000;
		rwrite = 1'b0;
		tread = 1'b0;
	end 
	// Clock Logic - Half as fast
	SSPCLKOUT = ~SSPCLKOUT;		// Making clock flip every posedge of PCLK
end

always @(negedge PCLK) begin
	// Must read data in sync with FIFO when data is ready
	// On the negedge, must be ready on posedge for SSPCLKOUT
	if(tread)		//If data is valid and we want to read in
		TxData = Tx;
	tread = 1'b0;
	rwrite = 1'b0;
end

always @ (posedge SSPCLKOUT) begin
	// If output enabled, transmit bits
	if(~SSPOE_B) begin
		if(~tcount[3]) // While 8 or less bits have been transmitted
			SSPTXD = TxData[tcount[2:0]];	// Assign
			//TxData = TxData >> 1'b1;	// Then Shift
	end
	if(tcount == 4'b0) begin	// If on LSB check if another TxData is ready
		SSPFSSOUT = tready;
		tread = tready;
	end else
		SSPFSSOUT = 1'b0;
end

always @(negedge SSPCLKOUT) begin
	// If transmit data ready, enable output and initialize registers
	if (SSPFSSOUT) begin
		SSPOE_B = 1'b0;
		tcount = 4'b0111;
	end 
	else if (tcount[3])
		SSPOE_B = 1'b1;
	else if (~SSPOE_B) begin
		SSPOE_B = 1'b0;
		tcount = tcount - 4'b1;
	end
end

always @ (negedge SSPCLKIN) begin
	if(~rcount[3]) begin	// While 8 or less bits have been read in
		RxData[rcount[2:0]] = SSPRXD;
		rcount = rcount - 4'b1;
	end
	if(rcount == 4'b1111) begin	// If all bits read, write on next PCLK edge
		rwrite = 1'b1;
		rcount = 4'b1000;
	end
	if(SSPFSSIN)			// Reset count for receival
		rcount = 4'b0111;
end
endmodule
