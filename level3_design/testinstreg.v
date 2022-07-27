	`timescale 10ns/1ns
	`include "instructionreg.v"

	module test;
	reg[7:0] busin;
	reg clk, clr, wa, oa;
	wire[3:0] instout;
	instreg instructreg(busin,clk,clr,wa,oa,instout);

	initial clk=0;

	always #2 clk=~clk;
	
	initial
	begin
		clr<=1; busin<=8'h78; wa<=0 ;oa<=0;
		#4 clr<=0; wa<=1;
		#4 busin<=8'h29; wa<=0; oa<=1;
		#4 wa<=1; oa<=0;
		#4 wa<=0; oa<=1;
		#5 $finish;
	end		

	initial
	begin
		$monitor($time, "	busin=%h	instout=%h	clr=%b	wa=%b	oa=%b",busin,instout,clr,wa,oa);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
