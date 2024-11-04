module testComplement;
    reg clock;
    processor proc(clock);
    wire signed [31:0] signed_num;
    assign signed_num = proc.mem.mem[1];
initial begin
    $display("mem0 | mem1");
    $monitor("%b: %d, %d", clock, proc.mem.mem[0], signed_num);
    #10000;
    $finish;
end

    initial begin
        proc.PC = 4095 - 7;
        proc.mem.complement(0);
        clock = 0;

        #70;
        proc.PC = 4095 - 7;
        proc.mem.complement(1);

        #70;
        proc.PC = 4095 - 7;
        proc.mem.complement(3419);
    end

    always begin
        #5 clock = ~clock;
    end
endmodule
