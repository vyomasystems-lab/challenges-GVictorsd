	`timescale 10ns/1ns
	`include "controlunit.v"

	module testcu;
	reg[8:0] instin;
	reg pmode;
	wire a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;
	controlunit cunit(instin,pmode,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p);

	initial
	begin
		pmode<=1; instin<=9'b011010001;
		#4 instin<=9'b101110001;
		#4 instin<=9'b000110010;
		#4 pmode<=0;instin<=9'b001100011;
		#4 instin<=9'b010100100;
		#4 instin<=9'b000001010;
		#4 instin<=9'b000101011;
		#4 instin<=9'b001001000;
		#4 $finish;
	end

	initial 
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,testcu);
	end

	endmodule
