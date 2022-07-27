	`timescale 10ns/1ns
	`include "GPR.v"

	module test;
	reg[7:0] data_in;
	reg clk,clr,wa,oa;
	wire[7:0] data_out;
	gpr register(data_out,data_in,clk,clr,wa,oa);
	
	initial
	begin
		clk=0;
		wa=0;oa=0;	
	end

	always #2 clk=~clk;
	
	initial
	begin
		$monitor($time,"	clr=%b	wa=%b	oa=%b	data_in=%h	data_out=%h	store=%h",clr,wa,oa,data_in,data_out,register.store);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
		
		oa=1;
		#1 clr=1'b1;
		#2 clr=1'b0;data_in=8'b01010101;wa=1;
		#4 wa=0;//oa=1;
		#4 oa=0; 
		#4 $finish;
	end
	endmodule
