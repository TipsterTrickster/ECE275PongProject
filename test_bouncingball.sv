`include "./bouncing_ball.sv"
module Testbench_top(
	input wire x,
	output y
);
assign y=~x;
test_bouncingball test ();
endmodule

`timescale 10ms/1ms

module test_bouncingball();
	reg clk;
   reg rst;
   wire [9:0] ballx;
   wire [9:0] bally;
	reg[9:0] paddle_y;
	
	initial begin
		clk = 0;
		paddle_y = 10'd240;
		#5 rst = 1;
		#15 rst = 0;
	end

	always #5 clk = ~clk;

	bouncingball uut (
        .clk(clk),
        .rst(rst),
        .ballx(ballx),
        .bally(bally)
    );
endmodule

//, paddle_y, ball_x_location_logic, ball_y_location_logic