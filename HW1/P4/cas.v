module cas(control, A, B, Cin, C, S);
input A, B, Cin, control;
output C, S;

wire operand2 = B ^ control;

adder add(A, operand2, Cin, C, S);
endmodule
