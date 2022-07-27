	/*************** INSTRUCTION REGISTER ****************
	* inputs: 7-bit input data vector(busin), clock(clk)
	* 	control signals: clear(clr),write enable(wa),
	* 		output enable(oa),
	* outputs: 4 most significant bits of instruction
	*   (input to control unit)('instout')
	******************************************************/

	module instreg(
	input[7:0] busin,
	input clk, clr, wa, oa,
	output[3:0] addrout);
	reg[7:0] store;

	assign addrout = (oa)? store[3:0]: 4'hz;

	always@ (posedge clk)
	begin
		if(clr)
			store= 8'h00;
		else if(wa)
			store= busin;
	end
	endmodule
