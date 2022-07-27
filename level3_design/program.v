`include "board.v"
	
module program;
	board bord();
	reg[7:0] Buss;
	reg[3:0] addr;
	reg clr,ramoa,ramwa;

	wire outval;
	assign outval = bord.display;

	parameter
		nop=4'h0, lda=4'h1,
		add=4'h2, sub=4'h3,
		sta=4'h4, ldi=4'h5,
		jmp=4'h6, jc=4'h7,
		jz=4'h8, out=4'he, hlt=4'hf;
	
	assign bord.hlt=0;	

	initial
	begin
	//**** clear all registers to reset the computer ****//

		bord.clr<=1; 
		#4 bord.clr<=0;

/***************** program to add two numbers at address 0xe and 0xf ***************/

		bord.rm.mem[4'he]<= 8'h38;	//store 0x38 at 0xe in ram
		bord.rm.mem[4'hf]<= 8'h23;	//store 0x23 at 0xf in ram

		bord.rm.mem[4'h0]<= {lda,4'he};//8'h1e;	//mem-0x0 LDA 14
		bord.rm.mem[4'h1]<= {add,4'hf};//8'h2f;	//mem-0x1 ADD 15
		bord.rm.mem[4'h2]<= {out,4'h0};//8'he0;	//mem-0x2 OUT
		bord.rm.mem[4'h3]<= {hlt,4'h0};//8'hf0;	//mem-0x3 HLT

	end

	// always@ (bord.display)
	// begin
	// 	$display("out=  %h",bord.display);
	// end

	endmodule
	
