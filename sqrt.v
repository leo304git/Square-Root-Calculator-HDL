module sqrt (
	input clk,
	input rst_n,
	input [9:0] i_radicand,
	output o_finish,
	output [4:0] o_root,
	output [50:0] number
);
	wire [50:0] numbers0 [6:0];
	wire [5:0] t2_Q [4:0];
	wire [4:0] t3_Q [4:0];
	wire [3:0] r_Q [4:0];

	wire [5:0] t00_Q;
	REGP #(6) t00(.clk(clk), .rst_n(rst_n), .D(i_radicand[9:4]), .Q(t00_Q), .number(numbers0[0]));
	REGP #(4) r0(.clk(clk), .rst_n(rst_n), .D(i_radicand[3:0]), .Q(r_Q[0]), .number(numbers0[1]));
	wire sign1;
	wire [5:0] t00_s_16;
	wire [5:0] t20_D;
	wire [4:0] t30_D;
	Subtractor65 sub0(sign1, t00_s_16, t00_Q, 5'b10000, numbers0[2]);
	MUXP #(6) mux12(.A(t00_s_16), .B(t00_Q), .CTRL(sign1), .Z(t20_D), .number(numbers0[3]));
	MUXP #(5) mux13(.A(5'b10000), .B(5'b0), .CTRL(sign1), .Z(t30_D), .number(numbers0[4]));
	REGP #(6) t20(.clk(clk), .rst_n(rst_n), .D(t20_D), .Q(t2_Q[0]), .number(numbers0[5]));
	REGP #(5) t30(.clk(clk), .rst_n(rst_n), .D(t30_D), .Q(t3_Q[0]), .number(numbers0[6]));

	wire [6:0] t0 [4:0];
	wire [5:0] mt3 [4:0];
	wire [5:0] t1 [4:0];
	wire [4:0] pt3 [4:0];
	wire [5:0] two_expo6 [3:0];
	wire [4:0] two_expo5 [3:0];
	wire [4:0] sign_k;
	wire [5:0] t0_t1_k [4:0];
	wire [5:0] t2_kD [4:0];
	wire [4:0] t3_kD [4:0];
	wire [50:0] numbersmultik [3:0];
	wire [50:0] numbersfap1k [3:0];
	wire [50:0] numbersfap2k [3:0];
	wire [50:0] numberssubk [3:0];
	wire [50:0] numbersmux1k [3:0];
	wire [50:0] numbersmux2k [3:0];
	wire [50:0] numbersreg1k [3:0];
	wire [50:0] numbersreg2k [3:0];
	wire [50:0] numbersreg3k [2:0];
	assign two_expo6[0] = 6'b001000;
	assign two_expo6[1] = 6'b000100;
	assign two_expo6[2] = 6'b000010;
	assign two_expo6[3] = 6'b000001;
	assign two_expo5[0] = 5'b01000;
	assign two_expo5[1] = 5'b00100;
	assign two_expo5[2] = 5'b00010;
	assign two_expo5[3] = 5'b00001;
	genvar i;
	generate
		for(i=2; i<=5; i=i+1) begin
			assign t0[i-1] = {t2_Q[i-2], r_Q[i-2][5-i]};
			Multi2 m3(mt3[i-1], t3_Q[i-2], numbersmultik[i-2]);
			FAP #(6) plus_two_multi(.A(two_expo6[i-2]), .B(mt3[i-1]), .CI(1'b0), .S(t1[i-1]), .CO(), .number(numbersfap1k[i-2]));
			Subtractor76 subk(sign_k[i-1], t0_t1_k[i-1], t0[i-1], t1[i-1], numberssubk[i-2]);
			MUXP #(6) muxk2(.A(t0_t1_k[i-1]), .B(t0[i-1][5:0]), .CTRL(sign_k[i-1]), .Z(t2_kD[i-1]), .number(numbersmux1k[i-2]));
			FAP #(5) plus_two(.A(two_expo5[i-2]), .B(t3_Q[i-2]), .CI(1'b0), .S(pt3[i-1]), .CO(), .number(numbersfap2k[i-2]));
			MUXP #(5) muxk3(.A(pt3[i-1]), .B(t3_Q[i-2]), .CTRL(sign_k[i-1]), .Z(t3_kD[i-1]), .number(numbersmux2k[i-2]));
			REGP #(6) t2k(.clk(clk), .rst_n(rst_n), .D(t2_kD[i-1]), .Q(t2_Q[i-1]), .number(numbersreg1k[i-2]));
			REGP #(5) t3k(.clk(clk), .rst_n(rst_n), .D(t3_kD[i-1]), .Q(t3_Q[i-1]), .number(numbersreg2k[i-2]));
		end
		for(i=2; i<5; i=i+1) begin
			REGP #(5-i) rk(.clk(clk), .rst_n(rst_n), .D(r_Q[i-2][5-i-1:0]), .Q(r_Q[i-1][5-i-1:0]), .number(numbersreg3k[i-2]));
		end
	endgenerate
	assign o_root = t3_Q[4];

	wire [50:0] numbersfd2 [5:0];
	wire [6:0] fd_D;
	genvar i0;
	generate
		for (i0=0; i0<6; i0=i0+1) begin
			FD2 fd0(fd_D[i0+1], fd_D[i0], clk, rst_n, numbersfd2[i0]);
		end
	endgenerate
	assign fd_D[0] = 1'b1;
	assign o_finish = fd_D[6];

	reg [50:0] sum;
	integer j;
	always @(*) begin
		sum = 0;
		for (j=0; j<7; j=j+1) begin 
			sum = sum + numbers0[j];
		end
		for (j=0; j<4; j=j+1) begin 
			sum = sum + numbersmultik[j];
			sum = sum + numbersfap1k[j];
			sum = sum + numbersfap2k[j];
			sum = sum + numberssubk[j];
			sum = sum + numbersmux1k[j];
			sum = sum + numbersmux2k[j];
			sum = sum + numbersreg1k[j];
			sum = sum + numbersreg2k[j];
		end
		for (j=0; j<3; j=j+1) begin
			sum = sum + numbersreg3k[j];
		end
		for (j=0; j<6; j=j+1) begin
			sum = sum + numbersfd2[j];
		end
	end
	assign number = sum;
	

endmodule

module Multi2(Z, A, number);
	input [4:0] A;
	output [5:0] Z;
	output [50:0] number;

	assign Z[5:1] = A;
	assign Z[0] = 1'b0; 
	assign number = 51'b0;
endmodule

module Subtractor76(sign, t2_6b, t0, t1, number);
	input [6:0] t0;
	input [5:0] t1;
	output sign;
	output [5:0] t2_6b;
	output [50:0] number;

	wire [5:0] t1a;
	wire [7:0] t1b;
	wire [7:0] t0b;
	wire [50:0] numbersiv [5:0];
	genvar i;
	generate
		for(i=0; i<6; i=i+1) begin
			IV iv1(t1a[i], t1[i], numbersiv[i]);
		end
	endgenerate
	assign t1b[5:0] = t1a;
	assign t1b[7:6] = 2'b11;
	assign t0b[6:0] = t0;
	assign t0b[7] = 1'b0;

	wire [7:0] neg_t1;
	wire [7:0] t2p;
	wire [50:0] numbersfa [1:0];
	FAP #(8) t1_negator(.A(t1b), .B(8'b0), .CI(1'b1), .S(neg_t1), .CO(), .number(numbersfa[0]));
	FAP #(8) t0_t1(.A(t0b), .B(neg_t1), .CI(1'b0), .S(t2p), .CO(), .number(numbersfa[1]));

	assign sign = t2p[7];
	assign t2_6b = t2p[5:0];

	reg [50:0] sum;
	integer j;
	always @(*) begin
		sum = 0;
		for (j=0; j<6; j=j+1) begin 
			sum = sum + numbersiv[j];
		end
		for (j=0; j<2; j=j+1) begin 
			sum = sum + numbersfa[j];
		end
	end
	assign number = sum;
endmodule

module Subtractor65(sign, t2_6b, t0, t1, number);
	input [5:0] t0;
	input [4:0] t1;
	output sign;
	output [5:0] t2_6b;
	output [50:0] number;

	wire [4:0] t1a;
	wire [6:0] t1b;
	wire [6:0] t0b;
	wire [50:0] numbersiv [4:0];
	genvar i;
	generate
		for(i=0; i<5; i=i+1) begin
			IV iv1(t1a[i], t1[i], numbersiv[i]);
		end
	endgenerate
	assign t1b[4:0] = t1a;
	assign t1b[6:5] = 2'b11;
	assign t0b[5:0] = t0;
	assign t0b[6] = 1'b0;

	wire [6:0] neg_t1;
	wire [6:0] t2p;
	wire [50:0] numbersfa [1:0];
	FAP #(7) t1_negator(.A(t1b), .B(7'b0), .CI(1'b1), .S(neg_t1), .CO(), .number(numbersfa[0]));
	FAP #(7) t0_t1(.A(t0b), .B(neg_t1), .CI(1'b0), .S(t2p), .CO(), .number(numbersfa[1]));

	assign sign = t2p[6];
	assign t2_6b = t2p[5:0];

	reg [50:0] sum;
	integer j;
	always @(*) begin
		sum = 0;
		for (j=0; j<5; j=j+1) begin 
			sum = sum + numbersiv[j];
		end
		for (j=0; j<2; j=j+1) begin 
			sum = sum + numbersfa[j];
		end
	end
	assign number = sum;
endmodule

module FAP #(parameter BW = 8)
	(
		input [BW-1:0] A,
		input [BW-1:0] B,
		input CI,
		output [BW-1:0] S,
		output CO,
		output [50:0] number
	);

	wire [BW:0] c;
	wire [50:0] numbers [0:BW-1];
	genvar i;
	generate
		for(i=0; i<BW; i=i+1) begin
			FA1 fa0(c[i+1], S[i], A[i], B[i], c[i], numbers[i]);
		end
	endgenerate
	assign c[0] = CI;
	assign c[BW] = CO;

	reg [50:0] sum;
	integer j;
	always @(*) begin
		sum = 0;
		for (j=0; j<BW; j=j+1) begin 
			sum = sum + numbers[j];
		end
	end

	assign number = sum;

endmodule

module MUXP #(parameter BW = 6)
	(
		input [BW-1:0] A,
		input [BW-1:0] B,
		input CTRL,
		output [BW-1:0] Z,
		output [50:0] number
	);

	wire [50:0] numbers [0:BW-1];
	genvar i;
	generate
	for(i=0; i<BW; i=i+1) begin
		MUX21H mux0(Z[i], A[i], B[i], CTRL, numbers[i]);
	end
	endgenerate

	reg [50:0] sum;
	integer j;
	always @(*) begin
		sum = 0;
		for (j=0; j<BW; j=j+1) begin 
			sum = sum + numbers[j];
		end
	end

	assign number = sum;

endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input clk,
	input rst_n,
	output [BW-1:0] Q,
	input [BW-1:0] D,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule
