`include "./shiftAddThree.sv"

module binaryToBCD(
	input [7:0] binary,
	output [11:0] BCD
);
	wire [27:0] s;
	shiftAddThree first ({1'b0, binary[7:5]}, s[3:0]);
	shiftAddThree second ({s[2:0], binary[4]}, s[7:4]);
	shiftAddThree third ({s[6:4], binary[3]}, s[11:8]);
	shiftAddThree fourth ({s[10:8], binary[2]}, s[15:12]);
	shiftAddThree fifth ({s[14:12], binary[1]}, s[19:16]);
	shiftAddThree sixth ({1'b0, s[3], s[7], s[11]}, s[23:20]);
	shiftAddThree seventh ({s[22:20], s[15]}, s[27:24]);
	assign BCD[11:10] = 1'b0;
	assign BCD[9] = s[23];
	assign BCD[8:5] = s[27:24];
	assign BCD[4:1] = s[19:16];
	assign BCD[0] = binary[0];
endmodule