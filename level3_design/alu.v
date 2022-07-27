	/************* 8-BIT ALU WITH ADD AND SUBTRACT ***************
	* inputs: 2 8-bit vector operands('a' and 'b')
	* 	a clock(clk), output enable(sumout), subtract control,
	* 	signal(sub)
	* outputs: 8-bit result vector(out)
	* 	output flags: carry flag(cf),zero flag(zf)
	* provides output at raising edge of clock 
	* ***********************************************************/
	
	`include "adder.v"

	module alu(
	output[7:0] out,
	output reg carryflg,zeroflg,
	input[7:0] a,b,
	input clk,sumout,sub,flagsin);
	
	wire[7:0] sum;
	wire[7:0] suminb;
	wire cin,cf1;
	adder8b addr(sum,cf1,a,suminb,cin);

	assign	suminb=sub?(~b):b;	//if sub is set output 1's compliment of b
	assign cin=sub? 1'b1:1'b0;	//..and carry in a 1 to form 2's compliment

	always@ (posedge clk)
	begin
		if(flagsin)
		begin
			carryflg <= cf1;
			zeroflg <= (sum==8'h00)? 1'b1: 1'b0;
		end
	end

	assign out = sumout? sum: 8'h00;

	endmodule
