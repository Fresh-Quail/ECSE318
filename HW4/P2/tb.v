`timescale 1ps / 1ps

module fullmodule;
    reg clock, inprw, inp_strobe;
    reg [15:0] in_addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    tri [31:0] data_bus;
    wire ready;

    cache mod(clock, inprw, inp_strobe, in_addr, ready, data_bus);

initial begin
    $display("clk | inp_strobe  inprw  in_addr  data_in | data_out  ready");
    $monitor("%b | %b, %b, %b, %d | %d, %b", clock, inp_strobe, inprw, in_addr, data_in, mod.cache.data_bus, ready);
    #10000;
    $finish;
end

initial begin
    $readmemh("data_mem.hex", mod.data_mem);
    clock = 1'b0;
    inprw = 1'b1;
    inp_strobe = 1'b0;
    in_addr = 1'b0;
    data_in = 1'b0;
    @(posedge clock);
    inp_strobe = 1'b1;
    in_addr = 16'h12;
    inprw = 1'b1;
    @(posedge clock);
    $display("%b", mod.address);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
end

always begin
    #100 clock = ~clock;
end
endmodule
