module ALU(A, B, CODE, CIN, COE, C, VOUT, COUT)
input [15:0] A, B;
input [2:0] CODE;
input CIN, COE;  
output [15:0] C;
output COUT;
output VOUT;

//NOTE: Overflow checking is different for signed and unsigned subtraction

case(CODE)
    3'b000: begin
        wire cla_cout[3:0];
        sumGenerator cla_0(.A(A[3:0]), .B(B[3:0]), .Cin(CIN), .sum(C[3:0], .Cout_final(cla_cout[0]) ) );
        sumGenerator cla_1(.A(A[7:4]), .B(B[7:4]), .Cin(cla_cout[0]), .sum(C[7:4], .Cout_final(cla_cout[1]) ) );
        sumGenerator cla_2(.A(A[11:8]), .B(B[11:8]), .Cin(cla_cout[1]), .sum(C[11:8], .Cout_final(cla_cout[2]) ) );
        sumGenerator cla_3(.A(A[15:12]), .B(B[15:12]), .Cin(cla_cout[2]), .sum(C[15:12], .Cout_final(cla_cout[3]) ) );
        COUT = cla_cout[3];

    end

    3'b001: begin
        
    end
    //NOTE: Can probably collapse signed addition and subtraction into one case
    3'b010: begin
        wire [15:0] Bop = B ^ CODE[0];

    end

    3'b011: begin
        wire [15:0] Bop = B ^ CODE[0];
    end

    3'b100: begin
        
    end

    3'b101: begin
        
    end