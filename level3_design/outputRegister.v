	/**************** OUTPUT REGISTER *****************
	* --used to display computed output
	*  inputs: 7-bit input vector(busin)
	*  	clock(clk), 
	*	control signals:clear(clr), write enable(wa),
	*  output: display...
	***************************************************/

	module outputreg(
	input[7:0] busin,
	input clk, clr, wa,
	output[7:0] display);
	reg[7:0] store;

	assign display=store;

	always@ (posedge clk)
	begin
		if(clr)
			store=8'h00;
		else if(wa)
			store=busin;
	end
	endmodule
