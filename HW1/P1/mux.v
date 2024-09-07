module MUX(Cin, C1, C2, S1, S2, C, S);
input Cin, C1, C2, S1, S2;
output C, S;

assign C = Cin ? C1 : C2;
assign S = Cin ? S1 : S2;
endmodule