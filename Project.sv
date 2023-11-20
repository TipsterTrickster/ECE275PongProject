`include "./DE0_VGA.sv"
`include "./modules/make_box.sv"

module Project(CLOCK_50, 
                VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

input	logic			CLOCK_50;

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

// Draw the player one paddle
wire [9:0] player_1_paddle_width = 10;
wire [9:0] player_1_paddle_height = 50;
logic [9:0] player_1_paddle_x_location_logic = 0;
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
logic [9:0] player_2_paddle_x_location_logic = 630;
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

wire [9:0] ball_width = 7;
wire [9:0] ball_height = 7;
logic [9:0] ball_x_location_logic = 300;
logic [9:0] ball_y_location_logic = 220;

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

logic [19:0] i = 0;

always_ff @(posedge CLOCK_50)
	begin
		if(player_1_paddle) pixel_color <= 12'b1111_1111_1111;
		else if(player_2_paddle) pixel_color <= 12'b1111_1111_1111;
		else if (ball) pixel_color <= 12'b1111_1111_1111;
		else pixel_color <= 12'b0000_0000_0000;
		
		i = i + 1;
		
		if (i == 307200) begin
			i <= 0;
			ball_y_location_logic = ball_y_location_logic + 1;
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
