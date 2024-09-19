module division(M, D, Q, R);
parameter N = 4;
input [N-1:0] M, D;
output [N-1:0] Q, R;

wire [N-2:0] C1;
wire [N-1:0] S1;

cas cas1[N-1:0](1'b1, {3'b0, D[3]}, M, {C1[2:0], 1'b1}, {Q[3], C1}, S1);

wire [N-2:0] C2;
wire [N-1:0] S2;
cas cas2[N-1:0](Q[3], {S1[2:0], D[2]}, M, {C2[2:0], Q[3]}, {Q[2], C2}, S2);

wire [N-2:0] C3;
wire [N-1:0] S3;
cas cas3[N-1:0](Q[2], {S2[2:0], D[1]}, M, {C3[2:0], Q[2]}, {Q[1], C3}, S3);

wire [N-2:0] C4;
wire [N-1:0] S4;
cas cas4[N-1:0](Q[1], {S3[2:0], D[0]}, M, {C4[2:0], Q[1]}, {Q[0], C4}, S4);

wire [3:0] C;
remainder correction[N-1:0](S4[3], S4, M, {C[2:0], 1'b0}, C, R);
endmodule
