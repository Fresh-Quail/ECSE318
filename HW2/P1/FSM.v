module FSM(A, B, alu_code, C, overflow)
input [15:0] A, B;
input [4:0] alu_code;
output [15:0] C;
output overflow;

case(alu_code[4:3])
    2'b00: begin
            ALU alu(A, B, alu_code[2:0], CIN, COE, C, VOUT, COUT);
    end

    2'b01: begin
        case(alu_code[2:0]): begin
            3'b000: assign C = A & B;
            3'b001: assign C = A | B;
            3'b010: assign C = A ^ B;
            3'b100: assign C = ~A;
        endcase
    end

    2'b10: begin
        case(alu_code[2:0]): begin
            3'b000: assign C = A << B[3:0];
            3'b001: assign C = A >> B[3:0];
            3'b010: assign C = A <<< B[3:0];
            3'b011: assign C = A >>> B[3:0];
        endcase
        end
    end

    2'b11: begin
        case(alu_code[2:0])
            wire [15:0] Sum_out;
            ALU alu(A, B, 3'b010, 1'b0, COE, Sum_out, VOUT, COUT); //Subtract B from A
            3'b000: assign C = {7'b0, }
            // 3'b001: assign C = 
            // 3'b010: assign C = 
            // 3'b011: assign C = 
            // 3'b100: assign C = 
            // 3'b101: assign C = 
        endcase
    end
endcase