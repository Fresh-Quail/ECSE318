module processor(clock, PC);
input clock;
output [11:0] PC;

wire [31:0] in_data;
wire [31:0] out_data;

reg write;
reg [31:0] regFile [15:0];
reg [31:0] IR;
reg [11:0] PC;
reg [4:0] PSR;
reg [11:0] address;
/** IR[31:28] : Opcode
*   IR[27:24] : CC
*   IR[27] : source type 0=reg(mem),1=imm
*   IR[26] : destination type 0=reg, 1=imm
*   IR[23:12] : Source address
*   IR[23:12] : shift/rotate count
*   IR[11:0] : destination address
**/

/**
*   PSR[0] : Carry
*   PSR[1] : Parity
*   PSR[2] : Even   
*   PSR[3] : Negative
*   PSR[4] : Zero
**/

// Don't need output to only be written on write signal
assign out_data = IR[27] ? IR[23:12] : regFile[IR[23:12]];

memory mem(clock, write, address, out_data, in_data);

always @(posedge clock) begin
    // Fetch the next instruction by changing the address
    address = PC;
    // Reset write signal
    write = 1'b0;
    // Assign IR to the new instruction
    #1 IR = in_data;
    #1;
    // After the instruction is fetched, assign the destination address
    // This should make it so in_data is equal to the source address in memory if needed  
    case(IR[31:28])
    4'b0000: begin
        PC = PC + 1;
    end

    4'b0001: begin // LOAD
        // IR[23:12] source
        // IR[11:0] destination, only need 4 bits
        // IR[27] source type
        // Prep the address with the source address
        // Which updates in_data in case it is utilized
        address = IR[27] ? IR[23:12] : regFile[IR[23:12]];
        #1; 
        regFile[IR[3:0]] = IR[27] ? IR[23:12] : in_data;
        PSR = 5'b11110;
        PC = PC + 1;
        
    end
    
    4'b0010: begin // STORE
        // Prep the address with the destination address
        // Which updates in_data in case it is utilized
        address = regFile[IR[11:0]];
        #1;
        write = 1'b1;
        PSR = 5'b00000;
        PC = PC + 1;
    end
    
    4'b0011: begin // BRANCH
        // Only need 3 bits for code
        // Subtract
        address = regFile[IR[11:0]];
        #1;
        case(IR[14:12])
            3'b000: PC = in_data;                 // Always
            3'b001: PC = PSR[1] ? in_data: PC;    // Parity
            3'b010: PC = PSR[2] ? in_data: PC;    // Even
            3'b011: PC = PSR[0] ? in_data : PC;   // Carry
            3'b100: PC = PSR[3] ? in_data : PC;   // Negative
            3'b101: PC = PSR[4] ? in_data : PC;   // Zero
            3'b110: PC = PSR[0] ? PC : in_data;   // No Carry
            3'b111: PC = PSR[3] ? PC : in_data;   //Positive
        endcase
        // PC = PSR[IR[14:12]] ? in_data - 1 : PC;
    end
    
    4'b0100: begin // XOR
        // IR[27] == 1 -> immediate : register
        // Only need 4 bits for reg
        regFile[IR[3:0]] = IR[27] ? regFile[IR[3:0]] ^ IR[23:12] : regFile[IR[3:0]] ^ regFile[IR[15:12]];
        PSR = 5'b11110;
        PC = PC + 1;
    end
    
    4'b0101: begin // ADD
        regFile[IR[3:0]] = IR[27] ? regFile[IR[3:0]] + IR[23:12] : regFile[IR[3:0]] + IR[23:12]; 
        PSR = 5'b11111;
        PC = PC + 1;
    end
    
    4'b0110: begin // ROTATE
        // IR[23] == 1 ? left : right
        regFile[IR[3:0]] = IR[23] ? regFile[IR[3:0]] << IR[22:12] | regFile[IR[3:0]] >> 5'b11111 - IR[22:12] : 
            regFile[IR[3:0]] >> IR[22:12] | regFile[IR[3:0]] << 5'b11111 - IR[22:12];
        PSR = 5'b11111;
        PC = PC + 1;
    end
    
    4'b0111: begin // SHIFT
        // IR[23] == 1 ? left : right
        regFile[IR[3:0]] = IR[23] ? regFile[IR[3:0]] << IR[22:12] : regFile[IR[3:0]] >> IR[22:12];  
        PSR = 5'b11111;
        PC = PC + 1;
    end
    
    4'b1000: begin // HALT
        // PC = PC
    end
    
    4'b1001: begin // COMPLEMENT
        regFile[IR[3:0]] = IR[27] ? ~IR[23:12] : ~regFile[IR[15:12]]; 
        PSR = 5'b11110;
        PC = PC + 1;
    end
    endcase

end

initial begin
    PC = 4095 - 31;
end
endmodule