	`timescale 10ns/1ns
	`include "ram.v"
	
	module test;
	wire[7:0] bus;
	reg[7:0] busin;
	reg[3:0] addr;
	reg clk,oa,wa,cs;
	ram randmem(bus,addr,clk,oa,wa,cs);

	initial clk=0;
	always #2 clk=~clk;
	
	assign bus=(cs & wa)?busin:8'hzz;
	integer i;
	initial
	begin
/*		addr<=4'b0000;busin<=8'h01;cs<=1;wa<=1;oa<=0;
		#3 cs<=0;wa<=0;
		#1 addr<=4'b0001;busin<=8'h02;
		#1 cs<=1;wa<=1;
		#2 cs<=0;wa<=0;
		#1 addr<=4'b0000;
		#1 cs<=1;oa<=1;
		#2 oa<=0;cs<=0;
		#4 $finish;
*/
		cs<=1;oa<=0;wa<=0;i<=8'h00;
		for(addr=4'h0;addr < 4'h8;addr=addr+1)
		begin
			wa=1;busin=i;
			#4 i=i+1;wa=0;
		end
		for(addr=4'h0;addr < 4'h8;addr=addr+1)
		begin
			#2 oa=1;
		end
		#60 $finish;
	end

	initial	
	begin
		$monitor($time,"	bus=%h	addr=%4b	oa=%b	wa=%b	cs=%b",bus,addr,oa,wa,cs);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
