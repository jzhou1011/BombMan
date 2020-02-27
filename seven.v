module seven(
	input [3:0] digit,
	output [7:0] seven_seg
    );

reg[7:0] seven;

always @ (*) begin
case(digit)    
	0: seven = 8'b11000000;
    1: seven = 8'b11111001;
    2: seven = 8'b10100100;
    3: seven = 8'b10110000;
    4: seven = 8'b10011001;
    5: seven = 8'b10010010;
    6: seven = 8'b10000010;
    7: seven = 8'b11111000;
    8: seven = 8'b10000000;
    9: seven = 8'b10010000;
    default: 
	seven = 8'b11111111;
endcase
end

assign seven_seg = seven;

endmodule