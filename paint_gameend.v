module paint_gameend(

input [9:0] hc,
input [9:0] vc,

input [9:0] p_x, // check how x and y are calculated
input [9:0] p_y, // what this function need is that [3][2] is x = 2, y = 3

input [1:0] which, //0 is player1, 1 is player2


output [2:0] red, //red vga output
output [2:0] green, //green vga output
output [1:0] blue //blue vga output
);

reg [2:0] end_red [640*480:0] ;
reg [2:0] end_green [640*480:0] ;
reg [1:0] end_blu [640*480:0] ;

initial begin
	case(which)
	0: begin $readmemb("win1_red.txt", end_red); $readmemb("win1_green.txt", end_green); $readmemb("win1_blue.txt", end_blu); end
	1: begin $readmemb("win2_red.txt", end_red); $readmemb("win2_green.txt", end_green); $readmemb("win2_blue.txt", end_blu); end
	2: begin $readmemb("draw_red.txt", end_red); $readmemb("draw_green.txt", end_green); $readmemb("draw_blue.txt", end_blu); end
endcase

end

wire x, y, location;

assign y = hc - p_y;
assign x = vc - p_x;

assign location = x + y*640;

assign red = end_red[location];
assign green = end_green[location];
assign blue = end_blue[location];

endmodule
