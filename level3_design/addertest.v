	/**************** TEST-BENCH FOR ADDER.V ************/

	`timescale 10ns/1ns
	`include "adder.v"

	module test;
        reg[0:7] a,b;
        reg cin;
	wire[0:7] sum;
	wire cout;
	reg clk;
	adder8b adder(sum,cout,a,b,cin);

	initial clk=0;
	always #1 clk=~clk;
	initial begin
		#2 cin<=1;a<=8'b00000011;b<=8'b00000100;
		#2 a<=8'b00000100;b<=8'b00001000;
		#2 cin<=0;a<=8'b00001101;b<=8'b00000001;
		#5 $finish;
	end
	initial begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
