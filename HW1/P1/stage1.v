module stage1(A, B, Cin, C, S);
input Cin;
input [1:0] A, B;
output [1:0] S;
output C;

FA adder0 (A[0], B[0], Cin, C1, S0);

wire [1:0] Cout, Sout;
FA adder1 [1:0] (A[1], B[1], {1'b0  , 1'b1}, Cout, Sout);

mux #1 mux0 (C1, Cout[0], Cout[1], C);
mux #1 mux1 (C1, Sout[0], Sout[1], S);

concat #1 con(Sout, S0, S);
endmodule