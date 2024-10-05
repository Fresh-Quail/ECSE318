
module PGgenerator(A, B, P, G);
  input A,B;
  output P, G;

  and  gen(G,A,B);

  xor  pro(P,A,B);

endmodule
module carryGenerateBlock(P, G, Cin, Cout);
    input [3:0] P, G;
    input Cin;
    output [3:1] Cout;

    //implementing C1 = G0+P0*Cin
    wire c1_result;

    and  c1_wire(c1_result, Cin, P[0]);

    or   first_carry(Cout[1], c1_result, G[0]);

    //implementing C2 = G1+P1*G0+P1*P0*Cin
    wire [1:0] c2_result;

    and c2_1st_wire(c2_result[0], P[1], P[0], Cin);

    and c2_2st_wire(c2_result[1], P[1], G[0]);
    
    or second_carry(Cout[2], c2_result[1], c2_result[0],G[1]);

    //implementing C3 = G2+ P2*G1+ P2*G1*G0 + P2*P1*P0*C0
    wire [2:0] c3_result;
    and c3_1st_wire(c3_result[0], P[2], P[1], P[0], Cin);
    and c3_2st_wire(c3_result[1], P[2], P[1], G[0]);
    and c3_3rd_wire(c3_result[2], P[2], G[1]);

    or third_carry(Cout[3], c3_result[2], c3_result[1], c3_result[0], G[2]);

endmodule
module sumGenerator(A, B, Cin, sum, Cout_final);
    input [3:0] A, B;   
    input Cin;   
    output [3:0] sum;
    output Cout_final;

    wire [3:0] P, G;    
    wire [3:1] Cout;  

    PGgenerator pg0 (.A(A[0]), 
                    .B(B[0]), 
                    .P(P[0]), 
                    .G(G[0]));
    PGgenerator pg1 (.A(A[1]), 
                    .B(B[1]), 
                    .P(P[1]), 
                    .G(G[1]));
    PGgenerator pg2 (.A(A[2]), 
                    .B(B[2]),
                    .P(P[2]), 
                    .G(G[2]));
    PGgenerator pg3 (.A(A[3]), 
                    .B(B[3]), 
                    .P(P[3]), 
                    .G(G[3]));     

    carryGenerateBlock cla(
        .P(P),
        .G(G),
        .Cin(Cin),
        .Cout(Cout)
    );

    // sum[0]
    xor sum_0(sum[0], P[0], Cin);

    // sum[1]
    xor sum_1(sum[1], P[1], Cout[1]);

    // sum[2]
    xor sum_2(sum[2], P[2], Cout[2]);

    // sum[3]
    xor sum_3(sum[3], P[3], Cout[3]);

    //Cout for 4th stage

    wire [3:0] c4_result;
    and c4_1st_wire(c4_result[0], P[3], P[2], P[1], P[0], Cin);
    and c4_2st_wire(c4_result[1], P[3], P[2], P[1], G[0]);
    and c4_3rd_wire(c4_result[2], P[3], P[2], G[1]);
    and c4_4th_wire(c4_result[3], P[3],G[2]);
    or fourth_carry(Cout_final, c4_result[3], c4_result[2], c4_result[1], c4_result[0], G[3]);

endmodule
module ALU(A, B, CODE, CIN, COE, C, VOUT, COUT);
input [15:0] A, B;
input [2:0] CODE;
input CIN, COE; 
output [15:0] C;
output COUT;
output VOUT;

//NOTE: Overflow checking is different for signed and unsigned subtraction
wire [3:0] cla_cout;
wire [15:0] Bop;
reg VOUT, COUT;

/** 
if CODE[2] == 1, then 
    if CODE[0] == 1, then 
        Bop = 16'hFFFF //CODE = 101 - subtract 1
    else
        Bop = 16'h0001 // CODE = 100 - add 1
else
// perform addition or subtraction
If CODE[1], flip the bits in B and assign to Bop so that subtraction can be perfomed
else
perform addition

**/ 
assign Bop = CODE[2] ? (CODE[0] ? 16'hFFFF : 16'h0001) : B[15:0] ^ {16{CODE[1]}};

sumGenerator cla_0(.A(A[3:0]), .B(Bop[3:0]), .Cin(CODE[1]), .sum(C[3:0]), .Cout_final(cla_cout[0]) ); 
sumGenerator cla_1(.A(A[7:4]), .B(Bop[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
sumGenerator cla_2(.A(A[11:8]), .B(Bop[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
sumGenerator cla_3(.A(A[15:12]), .B(Bop[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );

always @(A or B or CODE or CIN or COE) begin
    case(CODE[2:0])
        //Done
        // signed addition
        3'b000: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & Bop[15] & (~C[15])) | ((~A[15] & ~Bop[15]) & C[15]);
        end
        //Done
        // unsigned addition
        3'b001: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = COUT;
        end
        //NOTE: Can probably collapse signed addition and subtraction into one case
        // signed subtraction
        3'b010: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & Bop[15] & (~C[15])) | ((~A[15] & ~Bop[15]) & C[15]);
        end
        // unsigned subtraction
        3'b011: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = ~COUT;
        end
        // signed increment
        3'b100: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & Bop[15] & (~C[15])) | ((~A[15] & ~Bop[15]) & C[15]);
        end
        //signed decrement
        3'b101: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & Bop[15] & (~C[15])) | ((~A[15] & ~Bop[15]) & C[15]);
        end
    endcase
end
endmodule
module FSM(A, B, alu_code, C, overflow);
input [15:0] A, B;
input [4:0] alu_code;
output [15:0] C;
output overflow;
wire [15:0] Sum_out;


reg [15:0] C;
reg overflow;
wire [2:0] code;
assign code = &alu_code[4:3] ? 3'b010 : alu_code[2:0];

ALU alu(A, B, code, 1'b0, 1'b0, Sum_out, VOUT, COUT); //Cin set to 0 - COE set to 1 (inactive High)

always @(A or B or alu_code) begin
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
                3'b000: C = A << B[3:0];
                3'b001: C = A >> B[3:0];
                3'b010: C = {A[15], A[13:0], 1'b0}; // A <<< B[3:0];
                3'b011: C = {A[15], A[15:1]}; // C = A >>> B[3:0];
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