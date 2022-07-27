	`timescale 10ns/1ns
	`include "outputRegister.v"

	module test;
	reg[7:0] busin;
	reg clk,clr,wa;
	wire[7:0] display;
	outputreg outreg(busin,clk,clr,wa,display);

	initial clk=0;
	
	always #2 clk=~clk;

	initial
	begin
		clr=1;busin=8'h22;wa=0;
		#3 clr=0;
		#1 wa=1;
		#4 wa=0;busin=8'h67;
		#1 wa=1;
		#5 $finish;
	end

	initial
	begin
		$monitor($time,"	busin=%h	display=%h	clr=%b	wa=%b",busin,display,clr,wa);
	$dumpfile("vars.vcd");
	$dumpvars(0,test);
	end
	endmodule	
