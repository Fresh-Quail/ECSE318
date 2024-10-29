module testMath;
    reg clock;

    processor proc(clock);

initial begin
    $display("mem0 | mem1 | mem2");
    $monitor("%d, %d, %d", proc.mem.mem[0], proc.mem.mem[1], proc.mem.mem[2]);
    #10000;
    $finish;
end

always @(proc.regFile[2] or proc.mem.mem[2]) begin
    $display("REG2: %d", proc.regFile[2]);
end
    initial begin
        proc.PC = 4095 - 21;
        proc.mem.math(10, 29);
        clock = 0;

        #(30*50 + 2*60 + 40);
        proc.PC = 4095 - 21;
        proc.mem.math(0, 100);

        #(32*60 + 40);
        proc.PC = 4095 - 21;
        proc.mem.math(1, 4235);
    end

    always begin
        #5 clock = ~clock;
    end
endmodule
