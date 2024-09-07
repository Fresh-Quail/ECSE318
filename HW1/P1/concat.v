module concat(A, B, Out);
parameter N = 2;
input [N-1:0] A, B;
output [2*N:0] Out;

assign Out = {A, B};
endmodule