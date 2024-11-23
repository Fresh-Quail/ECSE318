`timescale 1ps / 1ps

module fullmodule;
    reg clock, inprw, inp_strobe;
    reg [15:0] in_addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    tri [31:0] data_bus;
    wire ready;

    assign data_bus = data_in;
    cache mod(clock, inprw, inp_strobe, in_addr, ready, data_bus);

initial begin
    $display("Clk | strobe  prw  addr \t| data_bus  ready | Time");
    #10000;
    $finish;
end
always @(posedge clock) $display("%b | %b, %b, %b | %d, %b", clock, inp_strobe, inprw, in_addr, mod.cache.p_data_bus, ready, $time);

initial begin
    // $readmemb("data_mem.bin", mod.data_mem);
    clock = 1'b0;
    inprw = 1'b1;
    inp_strobe = 1'b0;
    in_addr = 1'b0;
    data_in = 32'hZZZZZZZZ;
    @(posedge clock);

    // First request 
    inp_strobe = 1'b1;
    in_addr = 16'h12;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    // Second request 
    inp_strobe = 1'b1;
    in_addr = 16'h45;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    // Third request
    inp_strobe = 1'b1;
    in_addr = 16'h76;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    // Fourth request
    inp_strobe = 1'b1;
    in_addr = 16'h66;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);@(posedge clock);@(posedge clock);@(posedge clock);

    // Fifth request
    inp_strobe = 1'b1;
    in_addr = 16'h76;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);@(posedge clock);@(posedge clock);@(posedge clock);

    // Sixth request 
    inp_strobe = 1'b1;
    in_addr = 16'h59;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);@(posedge clock);@(posedge clock);@(posedge clock);

    // Seventh request
    inp_strobe = 1'b1;
    in_addr = 16'h45;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);@(posedge clock);@(posedge clock);@(posedge clock);

    // Eight request
    inp_strobe = 1'b1;
    in_addr = 16'h12;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge clock);@(posedge clock);@(posedge clock);@(posedge clock);

    $display("Test writing");
    $display("Write over address 12");
    inp_strobe = 1'b1;
    in_addr = 16'h12;
    inprw = 1'b0;
    data_in = 32'h0000AC32;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge ready);
    data_in = 32'hZZZZZZZZ;

    $display("Read written request");
    inp_strobe = 1'b1;
    in_addr = 16'h12;
    inprw = 1'b1;
    @(posedge clock);
    inp_strobe = 1'b0;
    @(posedge ready);@(posedge clock);@(posedge clock);@(posedge clock);
end

always begin
    #50 clock = ~clock;
end
endmodule
