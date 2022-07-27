	`timescale 10ns/1ns
	
	module test;
	reg clk,clr;
	wire[2:0] out;
	
	counter3b count(out,clk,clr);

	initial clk=0;
	always #2 clk=~clk;

	initial
	begin
		clr<=1;
		#4 clr<=0;
		#40 $finish;
	end

	initial 
	begin
		$monitor($time,"	clr=%b	out=%3b",clr,out);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
