module mux(sel, A, B, Out);
parameter N = 1;
input sel;
input [N-1:0] A, B;
output [N-1:0] Out;

assign Out = sel ? B : A;
endmodule