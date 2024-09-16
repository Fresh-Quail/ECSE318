module stage3part(A, B, C, S);
input [1:0] A, B;
output [1:0] C;
output wire [3:0] S;

//First two adders with carryout and sum
FA adder00 (A[0], B[0], 1'b0, C00, S00);
FA adder01 (A[0], B[0], 1'b1, C01, S01);

//Second two adders with carryout and sum
FA adder10 (A[1], B[1], 1'b0, C10, S10);
FA adder11 (A[1], B[1], 1'b1, C11, S11);

//First two part mux using carry from adder0 with concat
mux #1 mux00 (C00, C10, C11, C[0]);
mux #1 mux01 (C00, S10, S11,  Sout0);

concat #1 concat0(Sout0, S00, S[1:0]);
//Second two part mux using carry from adder1 with concat
mux #1 mux10 (C01, C10, C11, C[1]);
mux #1 mux11 (C01, S10, S11, Sout1);

concat #1 concat1(Sout1, S01, S[3:2]);
endmodule
