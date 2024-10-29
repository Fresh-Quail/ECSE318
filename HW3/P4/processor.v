module processor(clock);
input clock;

wire [31:0] in_data, out_data;
wire [10:0] shift_amt;

reg [11:0] address, PC;
reg [31:0] regFile [15:0], IR;
reg [4:0] PSR;
reg write;
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
assign shift_amt = (~IR[22:12]) + 1'b1;

memory mem(clock, write, address, out_data, in_data);

always @(posedge clock) begin
    // Fetch the next instruction by changing the address
    address <= PC;
    // Reset write signal
    write <= 1'b0;
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
        address <= IR[27] ? IR[23:12] : regFile[IR[23:12]];
        #1; 
        regFile[IR[3:0]] <= IR[27] ? IR[23:12] : in_data;

        setPSR(IR[27] ? IR[23:12] : in_data);
        PSR[0] <= 1'b0;
        PC <= PC + 1;
        
    end
    
    4'b0010: begin // STORE
        // Prep the address with the destination address
        // Which updates in_data in case it is utilized
        address <= regFile[IR[11:0]];
        #1;
        write <= 1'b1;
        PSR <= 5'b00000;
        PC <= PC + 1;
    end
    
    4'b0011: begin // BRANCH
        case(IR[26:24])
            3'b000: PC <= regFile[IR[11:0]];                 // Always
            3'b001: PC <= PSR[1] ? regFile[IR[11:0]]: PC + 1;    // Parity
            3'b010: PC <= PSR[2] ? regFile[IR[11:0]]: PC + 1;    // Even
            3'b011: PC <= PSR[0] ? regFile[IR[11:0]] : PC + 1;   // Carry
            3'b100: PC <= PSR[3] ? regFile[IR[11:0]] : PC + 1;   // Negative
            3'b101: PC <= PSR[4] ? regFile[IR[11:0]] : PC + 1;   // Zero
            3'b110: PC <= PSR[0] ? PC + 1 : regFile[IR[11:0]];   // No Carry
            3'b111: PC <= PSR[3] ? PC + 1 : regFile[IR[11:0]];   //Positive
        endcase
        // PC = PSR[IR[14:12]] ? in_data - 1 : PC;
    end
    
    4'b0100: begin // XOR
        // IR[27] == 1 -> immediate : register
        // Only need 4 bits for reg
        regFile[IR[3:0]] <= IR[27] ? regFile[IR[3:0]] ^ IR[23:12] : regFile[IR[3:0]] ^ regFile[IR[15:12]];

        setPSR(IR[27] ? regFile[IR[3:0]] ^ IR[23:12] : regFile[IR[3:0]] ^ regFile[IR[15:12]]);
        PSR[0] <= 1'b0;
        PC <= PC + 1;
    end
    
    4'b0101: begin // ADD
        {PSR[0], regFile[IR[3:0]]} <= IR[27] ? regFile[IR[3:0]] + IR[23:12] : regFile[IR[3:0]] + regFile[IR[23:12]];

        setPSR(IR[27] ? regFile[IR[3:0]] + IR[23:12] : regFile[IR[3:0]] + regFile[IR[23:12]]);
        PC <= PC + 1;
    end
    
    4'b0110: begin // ROTATE
        // IR[23] == 1 ? left : right
        regFile[IR[3:0]] <= IR[23] ? regFile[IR[3:0]] << shift_amt | regFile[IR[3:0]] >> 5'b11111 - shift_amt : 
            regFile[IR[3:0]] >> IR[22:12] | regFile[IR[3:0]] << 5'b11111 - IR[22:12];
       
        setPSR(IR[23] ? regFile[IR[3:0]] << IR[22:12] | regFile[IR[3:0]] >> 5'b11111 - IR[22:12] : 
            regFile[IR[3:0]] >> IR[22:12] | regFile[IR[3:0]] << 5'b11111 - IR[22:12]);
        PSR[0] <= 1'b0;
        PC <= PC + 1;
    end
    
    4'b0111: begin // SHIFT
        // IR[23] == 1 ? left : right
        {PSR[0], regFile[IR[3:0]]} <= IR[23] ? regFile[IR[3:0]] << shift_amt : regFile[IR[3:0]] >> IR[22:12];

        setPSR(IR[23] ? regFile[IR[3:0]] << IR[22:12] : regFile[IR[3:0]] >> IR[22:12]);
        PC <= PC + 1;
    end
    
    4'b1000: begin // HALT
        // PC = PC
    end
    
    4'b1001: begin // COMPLEMENT
        regFile[IR[3:0]] <= IR[27] ? ~IR[23:12] : ~regFile[IR[15:12]];

        setPSR(IR[27] ? ~IR[23:12] : ~regFile[IR[15:12]]);
        PSR[0] <= 1'b0;
        PC <= PC + 1;
    end
    endcase

end

task setPSR;
input [31:0] result;
    begin
        PSR[1] <= ~(^result);
        PSR[2] <= ~result[0];
        PSR[3] <= result[31];
        PSR[4] <= ~(|result);
    end
endtask
endmodule