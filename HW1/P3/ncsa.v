module ncsa(In, Out);
parameter N = 4;
parameter K = 10;
input [N*K-1:0] In;
output [N+K-3:0] Out;

genvar i;
generate
	for(i=0; i<K-2; i=i+1)
	begin: stage
		wire [N-1+i:0] Carry, Sum;
	end

	csa #N CSA(In[N-1:0], In[2*N-1:N], In[3*N-1:2*N], stage[0].Carry, stage[0].Sum);

	for(i=3; i<K; i=i+1)
	begin
		wire [i-3:0] zeroes = 0;
		csa #(N+i-2) csas({stage[i-3].Carry, 1'b0}, {1'b0, stage[i-3].Sum}, {zeroes, In[N*(i+1)-1:N*i]}, stage[i-2].Carry, stage[i-2].Sum);
	end
endgenerate
wire [N+K-3:0] Cout;
adder add[N+K-3:0]({stage[K-3].Carry, 1'b0}, {1'b0, stage[K-3].Sum}, {Cout[N+K-4:0], 1'b0}, Cout, Out);
endmodule
