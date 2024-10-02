module FSM(A, B, alu_code, C, overflow);
input [15:0] A, B;
input [4:0] alu_code;
output [15:0] C;
output overflow;

// always@(*) begin
case(alu_code[4:3])
    2'b00: begin
            ALU alu(A, B, alu_code[2:0], 1'b0, 1'b0, C, VOUT, COUT); //Cin set to 0 - COE set to 1 (inactive High)
    end

    2'b01: begin
        case(alu_code[2:0])
            3'b000: assign C = A & B;
            3'b001: assign C = A | B;
            3'b010: assign C = A ^ B;
            3'b100: assign C = ~A;
        endcase
    end

    2'b10: begin
        case(alu_code[2:0])
            3'b000: assign C = A << B[3:0];
            3'b001: assign C = A >> B[3:0];
            3'b010: assign C = A <<< B[3:0];
            3'b011: assign C = A >>> B[3:0];
        endcase
    end

    2'b11: begin
        case(alu_code[2:0])
            wire compare;
            wire [15:0] Sum_out;
            ALU alu(A, B, 3'b010, 1'b0, COE, Sum_out, VOUT, COUT); //Subtract B from A
            // A <= B
            3'b000: begin 
                assign C = A[15] ^ B[15] ? (A[15]) : ((Sum_out[15]) | ~|Sum_out);
               
            end

            3'b001: // A < B
                // If MSB of A & B are different A[15] ^ B[15] = 1
                // And B is negative (1), then A > B and A = 1 = B 
                assign C = A[15] ^ B[15] ? (A[15]) : (Sum_out[15]);

            // A >= B
            3'b010: begin 
                // If MSB of A & B are different A[15] ^ B[15] = 1
                // And B is negative (1), then A > B and A = 1 = B 
                // ~|Sum_out == A == B
                assign C = A[15] ^ B[15] ? (B[15]) : ~(Sum_out[15]);
            end
            
            // A > B
            3'b011: begin
                // If MSB of A & B are different A[15] ^ B[15] = 1
                // And B is negative (1), then A > B and A = 1 = B 
                assign C = A[15] ^ B[15] ? (B[15]) : ~(Sum_out[15]) & |Sum_out;
            end

            // A = B
            3'b100: assign C = ~|Sum_out;
            // A != B
            3'b101: assign C = |Sum_out;
        endcase
    end
// end
endmodule