`include "./DE0_VGA.sv"
`include "./modules/make_box.sv"
`include "./modules/BCD_Display.sv"
`include "./modules/binaryToBCD.sv"
`include "./testslowclock.sv"

module Project(CLOCK_50, PushButton, HEX1_D, HEX0_D,
                VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

input	logic	CLOCK_50;

input logic [2:0] PushButton;
output logic [5:0] HEX1_D;
output logic [5:0] HEX0_D;


output	logic	[3:0]		VGA_R;		//Output Red
output	logic	[3:0]		VGA_G;		//Output Green
output	logic	[3:0]		VGA_B;		//Output Blue

output	logic	[0:0]		VGA_HS;			//Horizontal Sync
output	logic	[0:0]		VGA_VS;			//Vertical Sync

logic			[9:0]		X_pix;			//Location in X of the driver
logic			[9:0]		Y_pix;			//Location in Y of the driver

logic			[0:0]		H_visible;		//H_blank?
logic			[0:0]		V_visible;		//V_blank?

logic		[0:0]		pixel_clk;		//Pixel clock. Every clock a pixel is being drawn. 
logic			[9:0]		pixel_cnt;		//How many pixels have been output.

logic			[11:0]		pixel_color;	//12 Bits representing color of pixel, 4 bits for R, G, and B
										//4 bits for Blue are in most significant position, Red in least
// general variables
logic [9:0] ball_xv = 0;
logic [9:0] ball_yv = 0;
logic [9:0] player_1_paddle_yv = 3;
logic [9:0] player_2_paddle_yv = 3;
logic [2:0] player_1_score = 0;
logic [2:0] player_2_score = 0;
logic reset = 1;
										
// Draw the player one paddle
wire [9:0] player_1_paddle_width = 10;
wire [9:0] player_1_paddle_height = 50;
logic [9:0] player_1_paddle_x_location_logic = 20;
logic [9:0] player_1_paddle_y_location_logic = 220;

wire [9:0] player_1_paddle_x_location;
wire [9:0] player_1_paddle_y_location;

logic player_1_paddle;

assign player_1_paddle_x_location = player_1_paddle_x_location_logic;
assign player_1_paddle_y_location = player_1_paddle_y_location_logic;

make_box draw_player_1_paddle(
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(player_1_paddle_width),
	.box_height(player_1_paddle_height),
	.box_x_location(player_1_paddle_x_location),
	.box_y_location(player_1_paddle_y_location),
	.pixel_clk(CLOCK_50),
	.box(player_1_paddle)
);

wire [9:0] player_2_paddle_width = 10;
wire [9:0] player_2_paddle_height = 50;
logic [9:0] player_2_paddle_x_location_logic = 610;
logic [9:0] player_2_paddle_y_location_logic = 220;

wire [9:0] player_2_paddle_x_location;
wire [9:0] player_2_paddle_y_location;

logic player_2_paddle;

assign player_2_paddle_x_location = player_2_paddle_x_location_logic;
assign player_2_paddle_y_location = player_2_paddle_y_location_logic;


make_box draw_player_2_paddle(
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(player_2_paddle_width),
	.box_height(player_2_paddle_height),
	.box_x_location(player_2_paddle_x_location),
	.box_y_location(player_2_paddle_y_location),
	.pixel_clk(CLOCK_50),
	.box(player_2_paddle)
);

wire [9:0] ball_width = 8;
wire [9:0] ball_height = 8;
logic [9:0] ball_x_location_logic = 320;
logic [9:0] ball_y_location_logic = 240;

wire [9:0] ball_x_location;
wire [9:0] ball_y_location;

logic ball;

assign ball_x_location = ball_x_location_logic;
assign ball_y_location = ball_y_location_logic;


make_box draw_ball(
	.X_pix(X_pix),
	.Y_pix(Y_pix),
	.box_width(ball_width),
	.box_height(ball_height),
	.box_x_location(ball_x_location),
	.box_y_location(ball_y_location),
	.pixel_clk(CLOCK_50),
	.box(ball)
);

BCD_Display p1_score (player_1_score, HEX0_D);
BCD_Display p2_score (player_2_score, HEX1_D);

logic [19:0] i = 0;
logic [14:0] j = 0;


always_ff @(posedge CLOCK_50)
	begin
		if(player_1_paddle) pixel_color <= 12'b0000_0000_1111;
		else if(player_2_paddle) pixel_color <= 12'b0000_0000_0000;
		else if (ball) pixel_color <= 12'b1111_1111_1111;
		else pixel_color <= 12'b1111_0000_0000;
		
		i = i + 1;
		
		//Defines the functions of the Push Buttons and evaluates various cases
		if (i == 307200) begin
				if (reset == 1) begin 
					ball_y_location_logic = 240;
					ball_x_location_logic = 320;
					ball_xv = 0;
					ball_yv = 0;
					
			
				if(!PushButton[2] && j > 500) begin
					j = 0;
					reset = 0;
					ball_xv = 1;
					ball_yv = -1;
				end
				
				else if(!PushButton[0] && j > 500) begin
					j = 0;
					reset = 0;
					ball_xv = -1;
					ball_yv = -1;
				
				end
				
			end
			
			//Increase the balls speed in the x direction
			
			 if (j > 2000 && ((ball_x_location == player_1_paddle_x_location + player_1_paddle_width) || (ball_x_location == player_2_paddle_x_location)))begin 
			   j = 0;
				if (ball_xv < 0 && ball_xv<-1) begin
					ball_xv = ball_xv + 1;
				end
				else
				if (ball_xv > 0 && ball_xv > 1) begin 
	
					ball_xv = ball_xv - 1;
				end
			end

			//Describes the boundary cases for the ball to bounce once it hits the top and bottom edges of the screen or the paddles in x and y
			if (ball_x_location < 10) begin
				j = 0;
				reset = 1;
				player_2_score = player_2_score +1;
			end
			if (ball_x_location + ball_width > 630) begin
				j = 0;
				reset = 1;
				player_1_score = player_1_score +1;
			
			end
			
			else if (ball_y_location < player_1_paddle_y_location + player_1_paddle_height &&
						ball_y_location + ball_height > player_1_paddle_y_location && 
						(ball_x_location < 30))begin
						
				ball_xv = -ball_xv;
			end
			
			else if (ball_y_location < player_2_paddle_y_location + player_2_paddle_height &&
						ball_y_location + ball_height > player_2_paddle_y_location && 
						(ball_x_location + ball_width > 610)) begin
						
				ball_xv = -ball_xv;
			end

			if (ball_y_location > 480 || ball_y_location < 0) begin 
				
				ball_yv = -ball_yv;
			end
			
			// Defines the boundary conditions and actions for the player_1 and player_2 paddles
			if (!PushButton[2] && player_1_paddle_y_location + player_1_paddle_height < 479) begin 
			
				player_1_paddle_y_location_logic = player_1_paddle_y_location_logic + player_1_paddle_yv;
			end
			
			else if (player_1_paddle_y_location > 1) begin
			
				player_1_paddle_y_location_logic = player_1_paddle_y_location_logic - player_1_paddle_yv;
			end
			
			if (!PushButton[0] && player_2_paddle_y_location + player_2_paddle_height < 479) begin
			
				player_2_paddle_y_location_logic = player_2_paddle_y_location_logic + player_2_paddle_yv;
			end
			
			else if (player_2_paddle_y_location > 1) begin
				
				player_2_paddle_y_location_logic = player_2_paddle_y_location_logic - player_2_paddle_yv;
			end
			
			
			//Sets the respective x and y velocities of the ball
			ball_y_location_logic = ball_y_location_logic + ball_yv;
			ball_x_location_logic = ball_x_location_logic + ball_xv;
			
			i = 0;
			j = j + 1;
		end
	end
	
		//Pass pins and current pixel values to display driver
		DE0_VGA VGA_Driver
		(
			.clk_50(CLOCK_50),
			.pixel_color(pixel_color),
			.VGA_BUS_R(VGA_R), 
			.VGA_BUS_G(VGA_G), 
			.VGA_BUS_B(VGA_B), 
			.VGA_HS(VGA_HS), 
			.VGA_VS(VGA_VS), 
			.X_pix(X_pix), 
			.Y_pix(Y_pix), 
			.H_visible(H_visible),
			.V_visible(V_visible), 
			.pixel_clk(pixel_clk),
			.pixel_cnt(pixel_cnt)
		);

endmodule
