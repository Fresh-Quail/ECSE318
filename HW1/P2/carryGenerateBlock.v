module carryGenerateBlock(
    input [3:0] P, G,  // propagate and generate
    input Cin,         // carry-in from first stage (C0)
    output [3:1] Cout     // carry-out for each stage
);  


    //implementing C1 = G0+P0*Cin
    wire c1_result;

    and #10 c1_wire(c1_result, Cin, P[0]);

    or #10  first_carry(Cout[1], c1_result, G[0]);

    //implementing C2 = G1+P1*G0+P1*P0*Cin
    wire [1:0] c2_result;

    and #10 c2_1st_wire(c2_result[0], P[1], P[0], Cin);

    and #10 c2_2st_wire(c2_result[1], P[1], G[0]);
    
    or #10 second_carry(Cout[2], c2_result[1], c2_result[0],G[1]);

    //implementing C3 = G2+ P2*G1+ P2*G1*G0 + P2*P1*P0*C0
    wire [2:0] c3_result;
    and #10 c3_1st_wire(c3_result[0], P[2], P[1], P[0], Cin);
    and #10 c3_2st_wire(c3_result[1], P[2], P[1], G[0]);
    and #10 c3_3rd_wire(c3_result[2], P[2], G[1]);

    or #10 third_carry(Cout[3], c3_result[2], c3_result[1], c3_result[0], G[2]);

endmodule



