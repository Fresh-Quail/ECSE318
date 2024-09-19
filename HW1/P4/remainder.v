module remainder(control, A, B, Cin, C, S);
input A, B, Cin, control;
output C, S;

wire operand = control & B;
adder add(A, operand, Cin, C, S);
endmodule
