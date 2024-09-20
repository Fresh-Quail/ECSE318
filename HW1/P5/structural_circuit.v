module structural_circuit( x1,x2, s1, s2, z1, z2);

    input x1,x2;
    output s1, s2, z1, z2;

    wire s1_feedback;

    wire s2_feedback;

    assign s1_feedback = s1;
    assign s2_feedback = s2;

    assign s1 =  ( s1_feedback & (~x1) ) | ( x1 & x2) | ( s1_feedback & x2);

    assign s2 =  ( (s1_feedback) & (~x1)) | ( x1 & s2_feedback) | (s1_feedback & s2_feedback);

    assign z1 = s1;

    assign z2 = ( x1 & x2 & (~s2_feedback)) | ( x1 & (~x2) & s2_feedback);

endmodule  




