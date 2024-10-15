module processor(clock, in_data, out_data, address);
input clock;
input [31:0] in_data;
output [31:0] out_data;
output [11:0] address;

reg [31:0] regFile [15:0];
reg [31:0] mem [31:0];
reg [31:0] IR;
reg PC;
reg [11:0] address;
reg [4:0] PSR;

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

always @(posedge clock) begin

    case(IR[31:28])

    4'b0000: begin
        
    end

    4'b0001: begin // LOAD
        // IR[23:12] source
        // IR[11:0] destination, only need 4 bits
        // IR[27] source type
        regFile[IR[3:0]] = IR[27] ? IR[23:12] : mem[IR[23:12]];
        PSR[0] = 1'b1;
    end
    
    4'b0010: begin // STORE
        // Only need 4 bits for reg
        mem[IR[11:0]] = regFile[IR[15:12]];
        PSR[0] = 0;
    end
    
    4'b0011: begin // BRANCH
        // Only need 3 bits for code
        // Subtract 
        case(IR[14:12])
            3'b000: PC = mem[IR[11:0]] - 1;                 // Always
            3'b001: PC = PSR[1] ? mem[IR[11:0]] - 1 : PC;   // Parity
            3'b010: PC = PSR[2] ? mem[IR[11:0]] - 1 : PC;   // Even
            3'b011: PC = PSR[0] ? mem[IR[11:0]] - 1 : PC;   // Carry
            3'b100: PC = PSR[3] ? mem[IR[11:0]] - 1 : PC;   // Negative
            3'b101: PC = PSR[4] ? mem[IR[11:0]] - 1 : PC;   // Zero
            3'b110: PC = PSR[0] ? PC : mem[IR[11:0]] - 1;   // No Carry
            3'b111: PC = PSR[3] ? PC : mem[IR[11:0]] - 1;   //Positive
        endcase
        PC = PSR[IR[14:12]] ? mem[IR[11:0]] - 1 : PC;
    end
    
    4'b0100: begin // XOR
        // IR[27] == 1 -> immediate : register
        // Only need 4 bits for reg
        regFile[IR[3:0]] = IR[27] ? regFile[IR[3:0]] ^ IR[23:12] : regFile[IR[3:0]] ^ regFile[IR[15:12]];
        PSR[0] = 1'b0;
    end
    
    4'b0101: begin // ADD
        {PSR[0], regFile[IR[3:0]]} = IR[27] ? regFile[IR[3:0]] + IR[23:12] : regFile[IR[3:0]] + IR[23:12]; 
    end
    
    4'b0110: begin // ROTATE
        // IR[23] == 1 ? left : right
        regFile[IR[3:0]] = IR[23] ? regFile[IR[3:0]] << IR[22:12] | regFile[IR[3:0]] >> 5'b11111 - IR[22:12] : 
            regFile[IR[3:0]] >> IR[22:12] | regFile[IR[3:0]] << 5'b11111 - IR[22:12];
    end
    
    4'b0111: begin // SHIFT
        // IR[23] == 1 ? left : right
        regFile[IR[3:0]] = IR[23] ? regFile[IR[3:0]] << IR[22:12] : regFile[IR[3:0]] >> IR[22:12];  
    end
    
    4'b1000: begin // HALT

    end
    
    4'b1001: begin // COMPLEMENT

    end
    
    endcase

end

always @ (posedge clock) begin

end
endmodule