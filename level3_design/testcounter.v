	`timescale 10ns/1ns
	`include "programcounter.v"

	module test;
	wire[3:0] out;
	reg[3:0] in;
	reg clr,oe,jmp,inc,clk;
	counter ctr(out,in,clk,clr,oe,jmp,inc);
	
	initial begin
		clk=0;oe=0;jmp=0;inc=0;
       	end

	always	#1 clk=~clk;

	initial
	begin
		clr=1;
		#2 clr=0;oe=1;in=4'b1100;
		#2 inc=1;in=4'b1010;
		#4 inc=0;jmp=1;
		#4 $finish;
	end
	initial
	begin
		$monitor($time,"	clr=%b	oe=%b	jmp=%b	inc=%b	in=%h	out=%h store=%h",clr,oe,jmp,inc,in,out,ctr.store);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
				

