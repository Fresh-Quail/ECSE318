module conditonalAdder(A, B, Cin, C, S);
input [7:0] A, B;
input Cin;
output [7:0] S;
output C;

wire [1:0] S1;
wire [3:0] S2;
stage1 stage1(A[1:0], B[1:0], Cin, C2, S1);
stage2 stage2(A[3:2], B[3:2], C2, S1, C4, S2);
stage3 stage3(A[7:4], B[7:4], C4, S2, C, S); 
endmodule
