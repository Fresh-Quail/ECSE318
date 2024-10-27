module testProcessor;
    reg clock;
    wire [11:0] PC;

    processor proc(clock, PC);

    initial begin
        clock = 0;
    end

    always begin
        #5 clock = ~clock;
    end
endmodule
