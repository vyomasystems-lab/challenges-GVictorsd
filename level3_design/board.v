	`include "programcounter.v"
	`include "GPR.v"
	`include "alu.v"
	`include "memaddreg.v"
	`include "ram.v"
	`include "instructionreg.v"
	`include "outputRegister.v"
	`include "controlunit.v"

module board(clk);
	input clk;

	wire[7:0] Bus;
	reg clr;
	wire hlt,marwa,ramwa,ramoa,inregoa,inregwa,awa,aoa,sumout,sub,bwa,outregwa,pcinc,pcoe,pcjmp,flagsin;
	assign Bus=8'h00;
	
	// initial 
	// begin
	// 	$display("___initial");
	// 	clk<=0;
	// end
	
	// always #2 if(~hlt)
	// 	clk = ~clk;
	
	counter pc(Bus[3:0],Bus[3:0],clk,clr,pcoe,pcjmp,pcinc);

	gpr a(Bus,Bus,clk,clr,awa,aoa);

	reg boa;
	gpr b(Bus,Bus,clk,clr,bwa,boa);
	initial boa<=0;

	wire cf,zf;
	alu alunit(Bus,cf,zf,a.store,b.store,clk,sumout,sub,flagsin);

	wire[3:0] addrout;
	memaddreg mar(Bus[3:0],clk,clr,marwa,addrout);

	reg ramcs;
	ram rm(Bus,addrout,clk,ramoa,ramwa,ramcs);
	initial ramcs<=1;

	instreg instructionreg(Bus,clk,clr,inregwa,inregoa,Bus[3:0]);

	wire[7:0] display;
	outputreg out(Bus,clk,clr,outregwa,display);

	wire[2:0] cucountout;
	counter3b cucounter(cucountout,~clk,clr);
	wire[8:0] instin;
	assign instin[8:5]= instructionreg.store[7:4];
	assign instin[4:2]= cucountout;
	assign instin[1]= cf;
        assign instin[0]= zf;
	controlunit ctrlunit(instin,hlt,marwa,ramwa,ramoa,inregoa,inregwa,awa,aoa,sumout,sub,bwa,outregwa,pcinc,pcoe,pcjmp,flagsin);
	
	endmodule

