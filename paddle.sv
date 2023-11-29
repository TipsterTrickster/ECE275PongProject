module paddle(
	input clock,
	input reset,
	input [2:0] up_down,
	output logic [9:0] y
);

    // Internal signal to hold the next value of the counter
    logic [7:0] next_counter;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            // Reset condition
            next_counter <= 10'd220;
        end else begin
            // Normal operation
            if (up_down[0]) begin
                // Increase the value of the counter
                next_counter <= y + 1;
            end else if (up_down[1]) begin
                // Keep the current value
                next_counter <= y - 1;
            end else begin
					next_counter <= y;
				end
        end
    end

    // Assign the next_counter value to the counter at the end of the always_ff block
    always_comb begin
        y = next_counter;
    end

endmodule