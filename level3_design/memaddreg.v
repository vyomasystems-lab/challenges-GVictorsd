	/*************** MEMORY ADDRESS REGISTER ***************
	* input: 4-bit (lower half of the instruction) input
	*	 vector(busin), clock(clk)
	*	 control signals: clear(clr), write enable(wa),
	* output: 4-bit vector(address to ram module)('addrout')
	********************************************************/

	module memaddreg(
	input[3:0] busin,
	input clk, clr, wa,
	output[3:0] addrout);
	reg[3:0] store;

	assign addrout= store;

	always@ (posedge clk)
	begin
		if(clr)
			store= 4'h0;
		else if(wa)
			store= busin;
	end
	endmodule
