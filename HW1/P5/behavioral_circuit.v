module behavioral_circuit( x1,x2, s1, s2, z1, z2);
    input x1, x2; 
    output reg s1, s2;
    output reg z1, z2;

    reg s1_feedback, s2_feedback;

    always @(x1 or x2) begin

    s1_feedback = s1;
    s2_feedback = s2;

    s1 =  ( s1_feedback & (~x1) ) | ( x1 & x2) | ( s1_feedback & x2);

    s2 =  ( (s1_feedback) & (~x1)) | ( x1 & s2_feedback) | (s1_feedback & s2_feedback);

    z1 = s1;

    z2 = ( x1 & x2 & (~s2_feedback)) | ( x1 & (~x2) & s2_feedback);

    end

endmodule


