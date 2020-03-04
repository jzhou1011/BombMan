// Inputs the health score for player A and player B, the 7-segment display clock of 500 Hz
// Outputs seg and an for 7-segment display
module sevenSeg(
    // Inputs
    healthA, healthB, clk,
    // Outputs
    seg, an
);
    
    input [1:0] healthA, healthB;
    input clk;
    output reg [7:0] seg;
    output reg [3:0] an;

    localparam blank = 8'b11111111;

    wire [7:0] seven_o_0;
	wire [7:0] seven_o_3;
	
	seven seven_0 (
		.digit			(healthA),
		.seven_seg		(seven_o_0)
    );
	
	seven seven_3 (
		.digit			(healthB),
		.seven_seg		(seven_o_3)
    );

    reg [1:0] segment_act_counter = 2'b00;

    always @ (posedge clk) begin
        case (segment_act_counter)
            2'b00: begin
			    an <= 4'b0111;
                seg <= seven_o_3;
            end
			2'b01: begin
                an <= 4'b1011;
                seg <= 8'b11111111;
            end
            2'b10: begin
                an <= 4'b1101;
                seg <= 8'b11111111;
            end
            2'b11: begin
                an <= 4'b1110;
                seg <= seven_o_0;
            end
		endcase
        segment_act_counter <= segment_act_counter+1;
    end

endmodule