module stage3(A, B, Cin, Sin, C, S);
input Cin;
input [3:0] A, B, Sin;
output C;
output [7:0] S;

//First two adders with carryout and sum
wire [1:0] C0, C1;
wire [1:0] S0 [1:0], S1 [1:0];
stage3part stage1(A[1:0], B[1:0], C0, {S0[1], S0[0]});
stage3part stage2(A[3:2], B[3:2], C1, {S1[1], S1[0]});

//First two part mux with concat
wire [1:0] Sout0, Sout1;
wire [3:0] Sx, Sy;
mux #1 mux00(C0[0], C1[0], C1[1], Cout0);
mux #2 mux01(C0[0], S1[0], S1[1], Sout0);
concat #2 con0(Sout0, S0[0], Sx);

//Second two part mux with concat
mux #1 mux10(C0[1], C1[0], C1[1], Cout1);
mux #2 mux11(C0[1], S1[0], S1[1], Sout1);
concat #2 con1(Sout1, S0[1], Sy);

//Last mux of stage
wire [3:0] Sout;
mux #1 Cmux(Cin, Cout0, Cout1, C);
mux #4 Smux(Cin, Sx, Sy, Sout);
concat #4 con(Sout, Sin, S);
endmodule
