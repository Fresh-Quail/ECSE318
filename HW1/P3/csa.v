module csa(X, Y, Z, C, S);
parameter N = 4;
input [N-1:0] X, Y, Z;
output [N-1:0] C, S;

adder adder[N-1:0](X, Y, Z, C, S);
endmodule
