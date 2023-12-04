module bouncingball (
    input wire clk,
    input wire rst,
    output reg [9:0] ballx,
    output reg [9:0] bally
);

    reg [9:0] x_velocity = 1;  // Initial velocity in the x-direction
    reg [9:0] y_velocity = 1;  // Initial velocity in the y-direction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the ball position to the center of the screen
            ballx <= 320;
            bally <= 240;
        end else begin
            // Move the ball based on the velocities
            if (ballx > 639 || ballx < 1)begin
					x_velocity=-x_velocity;
				end
            if (bally > 479 || bally < 1)begin
					y_velocity=-y_velocity;
				end
				
				ballx <= ballx + x_velocity;
				bally <= bally + y_velocity;
        end
    end	 
endmodule
