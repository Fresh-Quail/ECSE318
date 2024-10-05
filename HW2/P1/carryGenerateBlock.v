module carryGenerateBlock(P, G, Cin, Cout);
    input [3:0] P, G;
    input Cin;
    output [3:1] Cout;

    //implementing C1 = G0+P0*Cin
    wire c1_result;

    and  c1_wire(c1_result, Cin, P[0]);

    or   first_carry(Cout[1], c1_result, G[0]);

    //implementing C2 = G1+P1*G0+P1*P0*Cin
    wire [1:0] c2_result;

    and c2_1st_wire(c2_result[0], P[1], P[0], Cin);

    and c2_2st_wire(c2_result[1], P[1], G[0]);
    
    or second_carry(Cout[2], c2_result[1], c2_result[0],G[1]);

    //implementing C3 = G2+ P2*G1+ P2*G1*G0 + P2*P1*P0*C0
    wire [2:0] c3_result;
    and c3_1st_wire(c3_result[0], P[2], P[1], P[0], Cin);
    and c3_2st_wire(c3_result[1], P[2], P[1], G[0]);
    and c3_3rd_wire(c3_result[2], P[2], G[1]);

    or third_carry(Cout[3], c3_result[2], c3_result[1], c3_result[0], G[2]);

endmodule