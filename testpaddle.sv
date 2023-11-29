`timescale 10ms/1ms
module testpaddle();
	reg clock;
	reg reset;
	reg [1:0] up_down;
	wire [9:0] paddle_y;
	initial begin
		clock = 0;
		reset = 0;
		up_down = 2'b00;
		#1 reset = 1;
		#2 reset = 0;
		#10 up_down = 2'b10;
		#10 up_down = 2'b01;
		#10 up_down = 2'b00;
	end
	always #1 clock = ~clock;
	
	paddle pdl(clock, reset, up_down, paddle_y);
endmodule