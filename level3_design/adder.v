	/*************** 1-BIT ADDER **************
	* inputs: 2 1-bit operands 'a' and 'b'
	* 	  1 bit carry in
	* outputs: 1 bit sum, 1 bit carry out
	*******************************************/

	module adder1b(
		output sum,
		output cout,
		input a,b,
		input cin);
	wire c,d,e;

	assign c=a^b;
	assign d=a&b;
	assign sum=c^cin;
	assign e=c&cin;
	assign cout=d|e;
	endmodule
	
	/****************** 4-BIT ADDER ****************
	* inputs: 2 4-bit operand vectors ('a' and 'b')
	* 	  1 bit carry in (cin)
	* outputs: a 4-bit output vector(sum)
	* 	   1 bit carry out(cout)
	*************************************************/

	module adder4b(
		output[3:0] sum,
		output cout,
		input[3:0] a,b,
		input cin);
	wire c0,c1,c2;	

       	adder1b ad0(sum[0],c0,a[0],b[0],cin);
	adder1b ad1(sum[1],c1,a[1],b[1],c0);
	adder1b ad2(sum[2],c2,a[2],b[2],c1);
	adder1b ad3(sum[3],cout,a[3],b[3],c2);
	endmodule

	/**************** 8-BIT ADDER ***************
	* inputs: 2 8-bit operand vectors('a','b')
	* 	  1 bit carryin(cin)
	* outputs: A 8-bit vector('sum')
	* 	   1 bit carry out('cout')
	********************************************/
	
       module adder8b(
		output[7:0] sum,
		output cout,
		input[7:0] a,b,
		input cin);
	wire c0;

	adder4b ad0(sum[3:0],c0,a[3:0],b[3:0],cin);
	adder4b ad1(sum[7:4],cout,a[7:4],b[7:4],c0);
	endmodule
