module seven(
	input [1:0] digit,
	output [7:0] seven_seg
    );

    reg [7:0] seven;

    always @ (*) begin
    case(digit)    
    	0: seven = 8'b11000000;
        1: seven = 8'b11111001;
        2: seven = 8'b10100100;
        3: seven = 8'b10110000;
        default: 
    	seven = 8'b11111111;
    endcase
    end

    assign seven_seg = seven;

endmodule