module sumGenerator(
    input [3:0] A, B,   
    input Cin,          
    output [3:0] sum,   
    output Cout_final         
);

    wire [3:0] P, G;    
    wire [3:1] Cout;  

    PGgenerator pg0 (.A(A[0]), 
                    .B(B[0]), 
                    .P(P[0]), 
                    .G(G[0]));
    PGgenerator pg1 (.A(A[1]), 
                    .B(B[1]), 
                    .P(P[1]), 
                    .G(G[1]));
    PGgenerator pg2 (.A(A[2]), 
                    .B(B[2]),
                    .P(P[2]), 
                    .G(G[2]));
    PGgenerator pg3 (.A(A[3]), 
                    .B(B[3]), 
                    .P(P[3]), 
                    .G(G[3]));     

    carryGenerateBlock cla(
        .P(P),
        .G(G),
        .Cin(Cin),
        .Cout(Cout)
    );

    // sum[0]
    xor #10 sum_0(sum[0], P[0], Cin);

    // sum[1]
    xor #10 sum_1(sum[1], P[1], Cout[1]);

    // sum[2]
    xor #10 sum_2(sum[2], P[2], Cout[2]);

    // sum[3]
    xor #10 sum_3(sum[3], P[3], Cout[3]);

    //Cout for 4th stage

    wire [3:0] c4_result;
    and #10 c4_1st_wire(c4_result[0], P[3], P[2], P[1], P[0], Cin);
    and #10 c4_2st_wire(c4_result[1], P[3], P[2], P[1], G[0]);
    and #10 c4_3rd_wire(c4_result[2], P[3], P[2], G[1]);
    and #10 c4_4th_wire(c4_result[3], P[3],G[2]);
    or #10 fourth_carry(Cout_final, c4_result[3], c4_result[2], c4_result[1], c4_result[0], G[3]);

endmodule



 
