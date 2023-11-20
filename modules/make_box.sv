module make_box(
    input logic [9:0] X_pix,
    input logic [9:0] Y_pix,
    input logic [9:0] box_width,
    input logic [9:0] box_height,
    input logic [9:0] box_x_location,
    input logic [9:0] box_y_location,
    input logic pixel_clk,
    output logic box
);

always_ff @(posedge pixel_clk)
    if ((X_pix > box_x_location) && (X_pix < (box_x_location + box_width)) &&
        (Y_pix > box_y_location) && (Y_pix < (box_y_location + box_height)))
        box <= 1;
    else
        box <= 0;

endmodule
