module PGgenerator(A, B, P, G);
  input A,B;
  output P, G;

  and  gen(G,A,B);

  xor  pro(P,A,B);

endmodule