	/*** test file to check if all modules are working correctly
	* before implementing the control unit !! *****************/

	`timescale 10ns/1ns

	`include "programcounter.v"
	`include "GPR.v"
	`include "alu.v"
	`include "memaddreg.v"
	`include "ram.v"
	`include "instructionreg.v"
	`include "outputRegister.v"

	module test;
	wire[7:0] Bus;
	reg clk,clr;

	assign Bus=8'hzz;
	
	initial clk=0;
	always #2 clk=~clk;

	reg pcoe,pcjmp,pcinc;
	counter pc(Bus[3:0],Bus[3:0],clk,clr,pcoe,pcjmp,pcinc);

	initial begin
		pcoe<=0;pcjmp<=0;pcinc<=0;
	end

	reg awa,aoa;
	gpr a(Bus,Bus,clk,clr,awa,aoa);
	initial begin awa<=0;aoa<=0; end

	reg bwa,boa;
	gpr b(Bus,Bus,clk,clr,bwa,boa);
	initial begin bwa<=0;boa<=0; end

	wire cf,zf;
	reg sumout,sub,flagsin;
	alu alunit(Bus,cf,zf,a.store,b.store,clk,sumout,sub,flagsin);
	initial begin sumout<=0;sub<=0;flagsin<=0; end

	reg marwa;
	wire[3:0] addrout;
	memaddreg mar(Bus[3:0],clk,clr,marwa,addrout);
	initial marwa<=0;

	reg ramoa,ramwa,ramcs;
	ram rm(Bus,addrout,clk,ramoa,ramwa,ramcs);
	initial begin ramcs<=1; ramwa<=0; ramoa<=0; end

	reg inregwa,inregoa;
	instreg instructionreg(Bus,clk,clr,inregwa,inregoa,Bus[3:0]);
	initial begin inregwa<=0; inregoa<=0; end	

	reg outregwa;
	wire[7:0] display;
	outputreg out(Bus,clk,clr,outregwa,display);
	initial outregwa<=0;
	
/************* Ram programming ******************/
	reg[7:0] Buss;
	reg[3:0] addr;
	reg control;
	assign Bus = control? Buss: 8'hzz;

	initial
	begin
		control<=0;
		 clr<=1;
		#4 clr<=0;
		control<=1;Buss<=8'h38; mar.store<=4'he; ramoa<=0; ramwa<=1;

		#3 ramwa<=0;
		#1 Buss<=8'h23;mar.store<=4'hf;ramwa<=1;

		#3 ramwa<=0;
		#1 ramwa<=1;Buss<=8'h1e;mar.store<=4'h0;
		
		#3 ramwa<=0;
		#1 ramwa<=1;Buss<=8'h2f;mar.store<=4'h1;

		#4 ramwa<=0;control<=0;
		
		mar.store<=4'he;ramoa<=1;
		 $display($time,"%h	%h",Bus,rm.mem[mar.store]);
	
	 	 #3 ramoa<=0;
		#1 mar.store<=4'hf;ramoa<=1;
		 $display($time,"%h	%h",Bus,rm.mem[mar.store]);
		
		 #3 ramoa<=0;
		#1 mar.store<=4'h0;ramoa<=1;
		 $display($time,"%h	%h",Bus,rm.mem[mar.store]);
		
		 #3 ramoa<=0;
		#1 mar.store<=4'h1;ramoa<=1;
		 $display($time,"%h	%h",Bus,rm.mem[mar.store]);
		
		 #4 ramoa<=0;
		
		/*************** lda**************************/
		
		#4 pcoe<=1;marwa<=1;
	        #4 pcoe<=0;marwa<=0;ramoa<=1;inregwa<=1;pcinc<=1;
		#4 ramoa<=0;inregwa<=0;pcinc<=0;inregoa<=1;marwa<=1;
		#4 inregoa<=0;marwa<=0;ramoa<=1;awa<=1;
		#4 ramoa<=0;awa<=0; $display($time,"a=%h",a.store);

		#4 pcoe<=1;marwa<=1;
	        #4 pcoe<=0;marwa<=0;ramoa<=1;inregwa<=1;pcinc<=1;
		#4 ramoa<=0;inregwa<=0;pcinc<=0;inregoa<=1;marwa<=1;
		#4 inregoa<=0;marwa<=0;ramoa<=1;bwa<=1;$display("***address=%h,  bus=%h",mar.store,Bus);
		#4 ramoa<=0;bwa<=0;sumout<=1;awa<=1; $display($time,"b=%h",b.store);
		#4 sumout<=0;awa<=0; $display($time,"b= %h	a= %h",b.store,a.store);
		
		#4 pcoe<=1;marwa<=1;
	        #4 pcoe<=0;marwa<=0;ramoa<=1;inregwa<=1;pcinc<=1;
		#4 ramoa<=0;inregwa<=0;pcinc<=0;aoa<=1;outregwa<=1;
		#4 aoa<=0;outregwa<=0; $display("\n******* out =%h *******\n",out.display);
		#1 $finish;
	end
	initial 
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end

	endmodule
