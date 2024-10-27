module memory(clock, write, address, in_data, out_data);
input [31:0] in_data;
input [11:0] address;
input write, clock;
output [31:0] out_data;

reg [32:0] mem [4095:0];

assign out_data = mem[address];

always @(negedge clock) begin
    if(write)
        mem[address] = in_data;
end

localparam NOP = 4'b0000;
localparam LD = 4'b0001;
localparam STR = 4'b0010;
localparam BRA = 4'b0011;
localparam XOR = 4'b0100;
localparam ADD = 4'b0101;
localparam ROT = 4'b0110;
localparam SHF = 4'b0111;
localparam HLT = 4'b1000;
localparam CMP = 4'b1001;

localparam REG0 = 12'b0000;
localparam REG1 = 12'b0001;
localparam REG2 = 12'b0010;
localparam REG3 = 12'b0011;
localparam REG4 = 12'b0100;
localparam REG5 = 12'b0101;
localparam REG6 = 12'b0110;
localparam REG7 = 12'b0111;
localparam REG8 = 12'b1000;
localparam REG9 = 12'b1001;
localparam REG10 = 12'b1010;
localparam REG11 = 12'b1011;
localparam REG12 = 12'b1100;
localparam REG13 = 12'b1101;
localparam REG15 = 12'b1111;

localparam ALW = 3'b000;
localparam PAR = 3'b001;
localparam EVN = 3'b010;
localparam CAR = 3'b011;
localparam NEG = 3'b100;
localparam ZRO = 3'b101;
localparam NCA = 3'b110;
localparam POS = 3'b111;

initial begin
    mem[0] = 1;
    mem[1] = 2;
    mem[2] = 3;
    mem[3] = 4;
    mem[4] = 5;
    mem[5] = 6;
    mem[6] = 7;
    mem[7] = 8;
    mem[8] = 9;
    mem[9] = 10;
    mem[10] = 11;
    mem[11] = 12;


    // OPCODE, SOURCE TYPE, CC, SOURCE ADD/IMM VAL, DEST ADDR

    mem[4095 - 31] = {LD, 1'b1, ALW, 12'b0110, REG0};       // REG0 = 6
    mem[4095 - 30] = {LD, 1'b1, ALW, 12'b0, REG1};          // REG1 = 0
    mem[4095 - 29] = {LD, 1'b1, ALW, 12'b01011, REG2};      // REG2 = 11
    mem[4095 - 28] = {LD, 1'b1, 3'b0, 12'b111111100100, REG5};       // REG5 = ADDR

    mem[4095 - 27] = {LD, 1'b0, 3'b0, REG1, REG3};          // REG3 = mem[REG1]
    mem[4095 - 26] = {LD, 1'b0, 3'b0, REG2, REG4};          // REG4 = mem[REG2]
    mem[4095 - 25] = {STR, 1'b0, 3'b0, REG3, REG2};         // MEM[REG2] = REG3 
    mem[4095 - 24] = {STR, 1'b0, 3'b0, REG4, REG1};         // MEM[REG1] = REG4

    mem[4095 - 23] = {ADD, 1'b1, 3'b0, 12'b111111111111, REG0};     // REG0 = REG0 - 1
    mem[4095 - 23] = {ADD, 1'b1, 3'b0, 12'b111111111111, REG2};     // REG2 = REG2 - 1
    mem[4095 - 23] = {ADD, 1'b1, 3'b0, 12'b1, REG1};                // REG1 = REG1 + 1

    mem[4095 - 21] = {BRA, 1'b0, ZRO, 12'b0, REG5};     // BRANCH on REG0 = 0
    mem[4095 - 20] = {HLT, 1'b0, 3'b0, 12'b0, 12'b0};   // Halt
    mem[4095 - 22] = {BRA, 1'b0, ZRO, 12'b0, REG5};     // BRANCH on REG0 = 0

    // mem[4095 - 20] = {STR, 1'b0, 3'b0, 12'b0, 12'b01011}; // MEM[9] = REG0
    // mem[4095 - 19] = {STR, 1'b0, 3'b0, 12'b1, 12'b00000}; // MEM[2] = REG1

    // mem[4095 - 18] = {LD, 1'b0, 3'b0, 12'b00011, 12'b0};      // REG0 = mem[3]
    // mem[4095 - 17] = {LD, 1'b0, 3'b0, 12'b01011, 12'b1};  // REG1 = mem[8]
    // mem[4095 - 16] = {STR, 1'b0, 3'b0, 12'b0, 12'b01011}; // MEM[8] = REG0
    // mem[4095 - 15] = {STR, 1'b0, 3'b0, 12'b1, 12'b00000}; // MEM[3] = REG1

    // mem[4095 - 14] = {LD, 1'b0, 3'b0, 12'b00100, 12'b0};      // REG0 = mem[4]
    // mem[4095 - 13] = {LD, 1'b0, 3'b0, 12'b01011, 12'b1};  // REG1 = mem[7]
    // mem[4095 - 12] = {STR, 1'b0, 3'b0, 12'b0, 12'b01011}; // MEM[7] = REG0
    // mem[4095 - 11] = {STR, 1'b0, 3'b0, 12'b1, 12'b00000}; // MEM[4] = REG1

    // mem[4095 - 10] = {LD, 1'b0, 3'b0, 12'b101, 12'b0};      // REG0 = mem[5]
    // mem[4095 - 9] = {LD, 1'b0, 3'b0, 12'b01011, 12'b1};  // REG1 = mem[6]
    // mem[4095 - 8] = {STR, 1'b0, 3'b0, 12'b0, 12'b01011}; // MEM[6] = REG0
    // mem[4095 - 7] = {STR, 1'b0, 3'b0, 12'b1, 12'b00000}; // MEM[5] = REG1

end


initial begin
    $display("\t\tTime | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0 | mem0");
    $monitor($time,,"%b: %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", clock, mem[0], mem[1], mem[2], mem[3], mem[4], mem[5], mem[6], mem[7], mem[8], mem[9], mem[10], mem[11]);
    #1000;
    $finish;
end
endmodule