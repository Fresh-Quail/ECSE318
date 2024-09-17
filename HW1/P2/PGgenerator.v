module PGgenerator(A, B, P, G);
  input A,B;
  output P, G;

  and #10 gen(G,A,B);

  xor #10 pro(P,A,B);



endmodule
