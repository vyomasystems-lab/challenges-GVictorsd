	/*
	******GENERAL PURPOSE 8-BIT REGISTER*******
        *works in sync with a clock signal(clk) with async reset(clr)
	* accepts 8 bit data and gives out 8 bit output
	* control bits: clear(clc), write enable(wa), output enable(oa)
	* output: 8 bit data(data_out)
	* input: 8 bit data(data_in), clk, clr, wa, oa.	
*/
	module gpr(
		output[7:0] data_out,
		input[7:0] data_in,
		input clk,clr,wa,oa);
	reg[7:0] store;
	
	always @(posedge clk)
	begin
		if(clr==1'b1)
			store<=8'b0;
		else if(wa==1'b1)
			store<=data_in;
		
	end

	assign data_out= oa? store: 8'hzz;

	endmodule
