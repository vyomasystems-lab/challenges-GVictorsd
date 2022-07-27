	`timescale 10ns/1ns
	`include "memaddreg.v"

	module test;
	reg[3:0] busin;
	reg clk, clr, wa;
	wire[3:0] addrout;
	memaddreg addreg(busin,clk,clr,wa,addrout);

	initial clk=0;
	always #2 clk=~clk;

	initial
	begin
		clr<=1; busin<=4'ha; wa<=0;
		#4 clr<=0; wa<=1; 
		#4 busin<=4'h7; wa<=0;
		#1 wa<=1;
		#5 $finish;
	end

	initial 
	begin
		$monitor($time, "busin=%h	clr=%b	wa=%b	addrout=%h",busin,clr,wa,addrout);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
