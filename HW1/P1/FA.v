module FA(A, B, Cin, C, S);
input A, B, Cin;
output C, S;

assign S = A ^ B ^ Cin;
assign C = ( A & B) | (A & Cin) | (B & Cin);
endmodule
