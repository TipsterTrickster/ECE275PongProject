module BCD_Display(
	input [3:0] BCDValue,
	output [6:0] LED_Segment
);
	wire D0;
	wire D1;
	wire D2;
	wire D3;
	assign D0 = BCDValue[3];
	assign D1 = BCDValue[2];
	assign D2 = BCDValue[1];
	assign D3 = BCDValue[0];
	assign LED_Segment[0] = (!D0*!D1*!D2*D3) + (!D0*D1*!D2*!D3);
	assign LED_Segment[1] = (!D0*D1*!D2*D3)+(D1*D2*!D3);
	assign LED_Segment[2] = (!D0*!D1*D2*!D3);
	assign LED_Segment[3] = (!D0*D1*!D2*!D3)+(!D0*!D1*!D2*D3)+(D1*D2*D3);
	assign LED_Segment[4] = (!D0*!D1*!D2*D3)+(!D0*!D1*D2*D3)+(!D0*D1*!D2*!D3)+(!D0*D1*!D2*D3)+(!D0*D1*D2*D3)+(D0*!D1*!D2*D3);
	assign LED_Segment[5] = (D2*D3)+(!D0*!D1*D3)+(!D0*!D1*D2);
	assign LED_Segment[6] = (!D0*!D1*!D2)+(D1*D2*D3);
endmodule