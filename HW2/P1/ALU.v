module ALU(A, B, CODE, CIN, COE, C, VOUT, COUT);
input [15:0] A, B;
input [2:0] CODE;
input CIN, COE;  
output [15:0] C;
output COUT;
output VOUT;
wire cla_cout[3:0];
wire [15:0] Bop;

//NOTE: Overflow checking is different for signed and unsigned subtraction
reg [15:0] V, cout;
assign VOUT = V;
assign COUT = cout;
always @(*) begin
    case(CODE[2:0])
        //Done
        // signed addition
        3'b000: begin
            
            sumGenerator cla_0(.A(A[3:0]), .B(B[3:0]), .Cin(CIN), .sum(C[3:0]), .Cout_final(cla_cout[0]) );
            sumGenerator cla_1(.A(A[7:4]), .B(B[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
            sumGenerator cla_2(.A(A[11:8]), .B(B[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
            sumGenerator cla_3(.A(A[15:12]), .B(B[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );
            cout = COE ? 1'bx : cla_cout[3];
            V = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        //Done
        // unsigned addition
        3'b001: begin
            
            sumGenerator cla_0(.A(A[3:0]), .B(B[3:0]), .Cin(CIN), .sum(C[3:0]), .Cout_final(cla_cout[0]) ) ;
            sumGenerator cla_1(.A(A[7:4]), .B(B[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) ) ;
            sumGenerator cla_2(.A(A[11:8]), .B(B[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) ) ;
            sumGenerator cla_3(.A(A[15:12]), .B(B[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) ) ;
            cout = COE ? 1'bx : cla_cout[3];
            V = cout;
        end
        //NOTE: Can probably collapse signed addition and subtraction into one case
        // signed subtraction
        3'b010: begin
            wire [15:0] Bop = B ^ CODE[0];
           
            sumGenerator cla_0(.A(A[3:0]), .B(Bop[3:0]), .Cin(1'b1), .sum(C[3:0]), .Cout_final(cla_cout[0]) ); //Cin set to 1
            sumGenerator cla_1(.A(A[7:4]), .B(Bop[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
            sumGenerator cla_2(.A(A[11:8]), .B(Bop[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
            sumGenerator cla_3(.A(A[15:12]), .B(Bop[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );
            cout = COE ? 1'bx : cla_cout[3];
            V = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        // unsigned subtraction
        3'b011: begin
            wire [15:0] Bop = B ^ CODE[0];
            
            sumGenerator cla_0(.A(A[3:0]), .B(Bop[3:0]), .Cin(1'b1), .sum(C[3:0]), .Cout_final(cla_cout[0]) ); //Cin set to 1
            sumGenerator cla_1(.A(A[7:4]), .B(Bop[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
            sumGenerator cla_2(.A(A[11:8]), .B(Bop[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
            sumGenerator cla_3(.A(A[15:12]), .B(Bop[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) ) ;
            cout = COE ? 1'bx : cla_cout[3];
            V = ~cout;
        end
        // signed increment
        3'b100: begin
            wire [15:0] inc = 4'h0001;
            
            sumGenerator cla_0(.A(A[3:0]), .B(inc[3:0]), .Cin(CIN), .sum(C[3:0]), .Cout_final(cla_cout[0]) );
            sumGenerator cla_1(.A(A[7:4]), .B(inc[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
            sumGenerator cla_2(.A(A[11:8]), .B(inc[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
            sumGenerator cla_3(.A(A[15:12]), .B(inc[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );
            assign cout = COE ? 1'bx : cla_cout[3];
            assign V = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
        //signed decrement
        3'b101: begin
            wire [15:0] dec = 4'hFFFF;
           
            sumGenerator cla_0(.A(A[3:0]), .B(dec[3:0]), .Cin(CIN), .sum(C[3:0]), .Cout_final(cla_cout[0]) );
            sumGenerator cla_1(.A(A[7:4]), .B(dec[7:4]), .Cin(cla_cout[0]), .sum(C[7:4]), .Cout_final(cla_cout[1]) );
            sumGenerator cla_2(.A(A[11:8]), .B(dec[11:8]), .Cin(cla_cout[1]), .sum(C[11:8]), .Cout_final(cla_cout[2]) );
            sumGenerator cla_3(.A(A[15:12]), .B(dec[15:12]), .Cin(cla_cout[2]), .sum(C[15:12]), .Cout_final(cla_cout[3]) );
            cout = COE ? 1'bx : cla_cout[3];
            V = (A[15] & B[15] & (~C[15])) | ((~A[15] & ~B[15]) & C[15]);
        end
    endcase
end
endmodule