module testMath;
    reg clock;

    processor proc(clock);

initial begin
    $display("mem0 | mem1 | mem2");
    $monitor("%d, %d, %d", proc.mem.mem[0], proc.mem.mem[1], proc.mem.mem[2]);
    #10000;
    $finish;
end

    initial begin
        proc.PC = 4095 - 21;
        proc.mem.math(10, 29);
        clock = 0;

        #(30*50 + 2*60 + 170);
        proc.PC = 4095 - 21;
        proc.mem.math(0, 100);

        #(32*50 + 170);
        proc.PC = 4095 - 21;
        proc.mem.math(0, 0);

        #(32*50 + 170);
        proc.PC = 4095 - 21;
        proc.mem.math(1, 4235);
    end

    always begin
        #5 clock = ~clock;
    end
endmodule
