module FSM(A, B, alu_code, C, overflow);
input [15:0] A, B;
input [4:0] alu_code;
output [15:0] C;
output overflow;
wire [15:0] Sum_out;


reg [15:0] C;
reg overflow;
reg [15:0] shift_result;

wire [2:0] code;
assign code = &alu_code[4:3] ? 3'b010 : alu_code[2:0];
ALU alu(A, B, code, 1'b0, 1'b0, Sum_out, VOUT, COUT); //Cin set to 0 - COE set to 1 (inactive High)

always @(*) begin
    case(alu_code[4:3])
        2'b00: begin
            C = Sum_out;
            overflow = VOUT;
        end

        2'b01: begin
            overflow = 1'b0;
            case(alu_code[2:0])
                3'b000: C = A & B;
                3'b001: C = A | B;
                3'b010: C = A ^ B;
                3'b100: C = ~A;
            endcase
        end

        2'b10: begin
            overflow = 1'b0;
            case(alu_code[2:0])
                3'b000: C = A[15:0] << B[3:0];
                3'b001: C = A[15:0] >> B[3:0];
                3'b010: C = {A[15], A[14:0] << B[3:0]}; // A <<< B[3:0];
                3'b011: begin
                    shift_result = A >> B[3:0];
                    assign C = A & 16'h8000 ? shift_result | (16'hFFFF << (16-B[3:0])) : A >> B[3:0];
                    
                end
            endcase
        end

        2'b11: begin
            overflow = 1'b0;
            case(alu_code[2:0])
                // ALU alu(A, B, 3'b010, 1'b0, COE, Sum_out, VOUT, COUT); //Subtract B from A
                // A <= B
                3'b000: begin 
                    C = {15'b000, A[15] ^ B[15] ? (A[15]) : ((Sum_out[15]) | ~|Sum_out)};
                end

                3'b001: // A < B
                    // If MSB of A & B are different A[15] ^ B[15] = 1
                    // And B is negative (1), then A > B and A = 1 = B 
                    C = {15'b000, A[15] ^ B[15] ? (A[15]) : (Sum_out[15])};

                // A >= B
                3'b010: begin
                    // If MSB of A & B are different A[15] ^ B[15] = 1
                    // And B is negative (1), then A > B and A = 1 = B 
                    // ~|Sum_out == A == B
                    C = {15'b000, A[15] ^ B[15] ? (B[15]) : ~(Sum_out[15])};
                end
                
                // A > B
                3'b011: begin
                    // If MSB of A & B are different A[15] ^ B[15] = 1
                    // And B is negative (1), then A > B and A = 1 = B 
                    C = {15'b000, A[15] ^ B[15] ? (B[15]) : ~(Sum_out[15]) & |Sum_out};
                end

                // A = B
                3'b100: C = {15'b000, ~|Sum_out};
                // A != B
                3'b101: C = {15'b000, |Sum_out};
            endcase
        end
    endcase
end
endmodule