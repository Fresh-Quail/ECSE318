module stage2(A, B, Cin, Sin, C, S);
input Cin;
input [1:0] A, B, Sin;
output [3:0] S;
output C;

//First two adders with carryout and sum
wire [1:0] Cout0, Sout0;
FA adder0 (A[0], B[0], 1'b0, Cout0[0], Sout0[0]);
FA adder1 (A[0], B[0], 1'b1, Cout0[1], Sout0[1]);

//Second two adders with carryout and sum
wire [1:0] Cout1, Sout1;
FA adder2 (A[1], B[1], 1'b0, Cout1[0], Sout1[0]);
FA adder3 (A[1], B[1], 1'b1, Cout1[1], Sout1[1]);

//First two part mux using carry from adder0 with concat
mux #1 mux00 (Cout0[0], Cout1[0], Cout1[1], Cout2);
mux #1 mux01 (Cout0[0], Sout1[0], Sout1[1], Sout2);
wire [1:0] Sout4;
concat #1 con0(Sout2, Sout0[0], Sout4);
//Second two part mux using carry from adder1 with concat
mux #1 mux10 (Cout0[1], Cout1[0], Cout1[1], Cout3);
mux #1 mux11 (Cout0[1], Sout1[0], Sout1[1], Sout3);
wire [1:0] Sout5;
concat #1 con1(Sout3, Sout0[1], Sout5);

mux #1 mux5(Cin, Cout2, Cout3, C);
wire [1:0] S1;
mux #2 mux6(Cin, Sout4, Sout5, S1);

concat #2 con(S1, Sin, S);
endmodule
