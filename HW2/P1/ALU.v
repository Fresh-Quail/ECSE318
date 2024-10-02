module ALU(A, B, CODE, CIN, COE, C, VOUT, COUT);
input [15:0] A, B;
input [2:0] CODE;
input CIN, COE;  
output [15:0] C;
output COUT;
output VOUT;

//NOTE: Overflow checking is different for signed and unsigned subtraction
wire cla_cout[3:0];
wire [15:0] Bop;
reg [15:0] VOUT, COUT;

assign Bop = CODE[2] ? (CODE[0] ?  16'h0001 : 16'hFFFF) : B ^ CODE[1];

sumGenerator cla_0(.A(A[3:0]), .B(Bop[3:0]), .Cin(CODE[1]), .sum(C[3:0]), .Cout_final(cla_cout[0]) ); 
sumGenerator cla_1(.A(A[7:4]), .B(Bop[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
sumGenerator cla_2(.A(A[11:8]), .B(Bop[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
sumGenerator cla_3(.A(A[15:12]), .B(Bop[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );

always @(*) begin
    case(CODE[2:0])
        //Done
        // signed addition
        3'b000: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        //Done
        // unsigned addition
        3'b001: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = COUT;
        end
        //NOTE: Can probably collapse signed addition and subtraction into one case
        // signed subtraction
        3'b010: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        // unsigned subtraction
        3'b011: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = ~COUT;
        end
        // signed increment
        3'b100: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        //signed decrement
        3'b101: begin
            COUT = COE ? 1'bx : cla_cout[3];
            VOUT = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
    endcase
end
endmodule