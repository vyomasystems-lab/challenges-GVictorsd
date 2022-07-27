	/************************* CONTROL UNIT ***************************
	* input: 9 bit instruction...
		* first 4-bits[8:5] instruction
		* next 3-bits[4:2] control unit counter out
		* next 2-bits[1:0] carry flag,zero flag.
	* output: 16-bit control signals
	*******************************************************************/

	module controlunit(
		input[8:0] instin,
		output hlt,marwa,ramwa,ramoa,inregoa,inregwa,awa,aoa,sumout,sub,bwa,outregwa,pcinc,pcoe,pcjmp,flagsin);
	reg[15:0] controlword;

	assign hlt=controlword[15];
	assign marwa=controlword[14];	 
	assign ramwa=controlword[13];
	assign ramoa=controlword[12];
	assign inregoa=controlword[11];
	assign inregwa=controlword[10];
	assign awa=controlword[9];
	assign aoa=controlword[8];
	assign sumout=controlword[7];
	assign sub=controlword[6];
	assign bwa=controlword[5];
	assign outregwa=controlword[4];
	assign pcinc=controlword[3];
	assign pcoe=controlword[2];
	assign pcjmp=controlword[1];
	assign flagsin=controlword[0];

	always@ (instin)
	begin
		casez(instin)

			//******** fetch-cycle *************//
			9'bzzzz000zz : controlword<= 16'h4004;
			9'bzzzz001zz : controlword<= 16'h1408;
		
			//************** NOP ***************//
			9'b0000010zz : controlword<= 16'h0000;
			9'b0000011zz : controlword<= 16'h0000;
			9'b0000100zz : controlword<= 16'h0000;

			//************** LDA ***************//
			9'b0001010zz : controlword<= 16'h4800;
			9'b0001011zz : controlword<= 16'h1200;
			9'b0001100zz : controlword<= 16'h0000;

			//************** ADD ***************//
			9'b0010010zz : controlword<= 16'h4800;
			9'b0010011zz : controlword<= 16'h1020;
			9'b0010100zz : controlword<= 16'h0281;

			//************** SUB ***************//
			9'b0011010zz : controlword<= 16'h4800;
			9'b0011011zz : controlword<= 16'h1020;
			9'b0011100zz : controlword<= 16'h02c1;

			//************** STA ***************//
			9'b0100010zz : controlword<= 16'h4800;
			9'b0100011zz : controlword<= 16'h2100;
			9'b0100100zz : controlword<= 16'h0000;

			//************** LDI ***************//
			9'b0101010zz : controlword<= 16'h0a00;
			9'b0101011zz : controlword<= 16'h0000;
			9'b0101100zz : controlword<= 16'h0000;

			//************** JMP ***************//
			9'b0110010zz : controlword<= 16'h0802;
			9'b0110011zz : controlword<= 16'h0000;
			9'b0110100zz : controlword<= 16'h0000;

			//************** JC ****************//
			9'b01110100z : controlword<= 16'h0000;
			9'b01110101z : controlword<= 16'h0802;
			9'b0111011zz : controlword<= 16'h0000;
			9'b0111100zz : controlword<= 16'h0000;

			//************** JZ ****************//
			9'b1000010z0 : controlword<= 16'h0000;
			9'b1000010z1 : controlword<= 16'h0802;
			9'b1000011zz : controlword<= 16'h0000;
			9'b1000100zz : controlword<= 16'h0000;

			//************** OUT ***************//
			9'b1110010zz : controlword<= 16'h0110;
			9'b1110011zz : controlword<= 16'h0000;
			9'b1110100zz : controlword<= 16'h0000;

			//************** HLT ***************//
			9'b1111zzzzz : $finish;

			default: controlword<= 16'hxxxx;
		endcase
	end
	endmodule


/***************** 3-BIT COUNTER FOR CONTROL UNIT *******************
* input: clock(clk) and clear(clr)
* output: 3-bit vector(out) counting in binary in sync with clock...
*********************************************************************/

	module counter3b(
		output[2:0] out,
		input clk,clr);
	reg[2:0] store;

	assign out=store;

	always@ (posedge clk)
	begin
		if(clr)
			store<=3'b000;
		else
			store<=store+1;
	end	
	
	always@ (store)
	       	if(store== 3'b101)
			store<=3'b000;
	endmodule
	

