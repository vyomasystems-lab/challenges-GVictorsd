	/******** 16-byte RAM MODULE with 8-bit words ***********
	* inputs: 4-bit address vector(addr),
	* 	clock signal(clk),
	* 	control signals: chip select(cs),output enable(oa),
	* 			write enable(wa)
	* 8-bit bi-directional bus
	********************************************************/

	module ram(
/*	output[7:0] data_out,<=== implemented as single bi-directional bus('bus')
	input[7:0] data_in,  <=== using tri-state buffer...
*/	inout[7:0] bus,
	input[3:0] addr,
	input clk,oa,wa,cs);
	reg[7:0] mem[15:0];
	
	tri[7:0] bus;
		wire[7:0] data_out,data_in;
		assign bus=oa?data_out:8'hzz;
		assign data_in=wa?bus:8'hzz;

	assign data_out=(cs & oa)? mem[addr]: 8'hzz;
	
	always@ (posedge clk)
		if(cs & wa & (~oa))
			mem[addr]=data_in;
	
	endmodule
	
