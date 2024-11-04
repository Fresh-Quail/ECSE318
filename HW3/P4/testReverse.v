module testReverse;
    reg clock;

    processor proc(clock);

initial begin
    $display("\t\tTime | mem0 | mem1 | mem2 | mem3 | mem4 | mem5 | mem6 | mem7 | mem8 | mem9 | mem10 | mem11");
    $monitor($time,,"%b: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", clock, proc.mem.mem[0], proc.mem.mem[1], proc.mem.mem[2], proc.mem.mem[3], proc.mem.mem[4], proc.mem.mem[5], proc.mem.mem[6], proc.mem.mem[7], proc.mem.mem[8], proc.mem.mem[9], proc.mem.mem[10], proc.mem.mem[11]);
    #1000;
    $finish;
end
    initial begin
	proc.PC = 4095 - 34;
        proc.mem.reverse();
        clock = 0;
    end

    always begin
        #5 clock = ~clock;
    end
endmodule
