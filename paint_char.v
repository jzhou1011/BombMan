module paint_char(

input [9:0] hc,
input [9:0] vc,

input [9:0] p_x, // check how x and y are calculated
input [9:0] p_y, // what this function need is that [3][2] is x = 2, y = 3

input which, //0 is player1, 1 is player2


output reg [2:0] red, //red vga output
output reg [2:0] green, //green vga output
output reg [1:0] blue //blue vga output
);

reg [2:0] char_red [3071:0] ;
reg [2:0] char_green [3071:0] ;
reg [1:0] char_blu [3071:0] ;

case(which):
0: begin $readmemb("char_red.txt", char_red); $readmemb("char_green.txt", char_green); $readmemb("char_blue.txt", char_blu); end
1: begin $readmemb("char_red.txt", char_red); $readmemb("char_green2.txt", char_green); $readmemb("char_blue2.txt", char_blu); end




wire x, y, location;

assign y = hc - p_y;
assign x = vc - p_x;

assign location = x + y*64;

red = char_red[location]
green = char_green[location]
blue = char_blue[location]

endmodule
