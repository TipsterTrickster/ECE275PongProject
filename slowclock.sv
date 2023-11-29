module slowclock(input wire fastclk,
                 input wire reset,
                 output reg slowclk) ;

   // Register block
   reg [2:0]                count; // State of the D-ffs
   wire [2:0]               d; // Input to the D-ffs
   always_ff @(posedge fastclk or posedge reset)
     begin
        if (reset) begin
           count <= 24'b0;
        end else begin
           count <= d;
        end
     end


   // input + current state -> ff input block
  assign d = (count == 24'd5000000) ? 24'b000 : count + 24'b001;

   // current state -> output block
   always_comb
     begin
       if (count == 24'b000)
          assign slowclk = 1'b1;
        else
          assign slowclk = 1'b0;
     end

endmodule
