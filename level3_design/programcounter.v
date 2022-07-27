	/*
	************ 4-BIT COUNTER *************
     	* works in sync with a clock(clk)
	* inputs: accepts a 4 bit binary value
	* outputs: outputs a 4 bit binary value
	* control signals: 
		* clear(clr): Resets the value of the counter to 0x00
		* output enable(oe):Outputs the value of counter on output line
		* jump(jmp):Latches in value set on input lines
		* increment(inc):Increments the value in counter  
*/
       module counter(
		output[3:0] out,
		input[3:0] in,
		input clk,clr,oe,jmp,inc);
	reg[3:0] store; 

	assign out= oe? store: 4'hz;

	always @(posedge clk)
	begin
		if(clr)
			store<=4'b0;
		else if(jmp)
			store<=in;
		else if(inc)
                        store<=store+1;
	end
	
	endmodule
