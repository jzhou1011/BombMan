// when we pass in the arena and bomb
// we get two 10*10 arrays
// then, each element in the array would be 64*48 pixels big
// it would then be:
// 0-63   / 0-47, 48-95, 96-143, 144-191, 192-239, 240-287, 288-335, 336-383, 384-431, 432-479
// 64-127
// 128-191
// 192-255
// 256-319
// 320-383
// 384-447
// 448-511
// 512-575
// 576-639
// We just simply make a new array 640*480 big
// make it equal to the corresponding value in arena
// if 0, check bomb to get new value if available

// Then we check if vc and hc are in one of the element in the above matrix
// If so, check the matrix's value, if 1, it's a player, and output red(for example)
// If we want to draw something, we can create a new module
// called painting_character: 
//			input: vc, hc
//			output: vgb color

// Note: if arena[x][y] is zero, display background color.


module vga640x480(

input wire pixel_clk, //pixel clock: 25MHz
input wire rst, //asynchronous reset
input player1_x,
input player1_y,
input player2_x,
input player2_y,
input [1:0] Arena [0:9][0:9],
input [1:0] Bomb [0:9][0:9],
input [1:0] game_over, // three values: player 1 win, player 2 win, draw

output wire hsync, //horizontal sync out
output wire vsync, //vertical sync out
output reg [2:0] red, //red vga output
output reg [2:0] green, //green vga output
output reg [1:0] blue //blue vga output
);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 80; 	// end of horizontal back porch
parameter hfp = 720; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480
reg [9:0] hc;
reg [9:0] vc;

always @(posedge pixel_clk or posedge rst)
begin
	// reset condition
	if (rst == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else

		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// Start parsing input 10*10 array

input [2:0] pixel_array [0:639][0:479];

reg i, j;
reg modulus_i, modules_j;

always @ (posedge pixel_clk)
begin

	for(i = 0, i <= 639, i = i + 1)
	begin
		for(j = 0, j <= 479, j = j + 1)
		begin
			modulus_i = i % 48;
			modulus_j = j % 48;
			
			pixel_array[i][j] = Arena[modulus_i][modulus_j];
			if (pixel_array[i][j] == 0)
			begin
				if (Bomb[modulus_i][modulus_j] != 0)
					pixel_array[i][j] = Bomb_pixel[modulus_i][modulus_j] + 3;
			end
		end
	end
end

////////////////////////////////////////


reg normalized_vc; // These are just for us to better retrieve value from pixel_arrays
reg normalized_hc;


always @(*)
begin

	// first check if we're within vertical active video range
	if (vc >= vbp && vc <= vfp && hc >= hbp && hc <= hfp && (game_over == 0))
	begin
		normalized_vc = vc - vbp
		normalized_hc = hc - vbp
		
		case(pixel_array[vc][hc]):
		0:	begin red = 3'b111; green = 3'b111; blue = 2'b11; end // background color
		1:  begin red = 3'b110; green = 3'b111; blue = 2'b11; end // block color
		2:  begin red = 3'b101; green = 3'b111; blue = 2'b11; end // player1 color
		//2: use a module called draw_player1
		3:  begin red = 3'b100; green = 3'b111; blue = 2'b11; end // player2 color
		//3: use a module called draw_player1
		4:  begin red = 3'b011; green = 3'b111; blue = 2'b11; end // new bomb color
		5:  begin red = 3'b010; green = 3'b111; blue = 2'b11; end // bomb after 1 sec color
		6:  begin red = 3'b001; green = 3'b111; blue = 2'b11; end // exploding color
	end
	
	else if ((game_over == 1))
	begin
		red = 0;
		green = 0;
		blue = 0;
		//use a module called draw "Player1 Win"
	end
	
	else if ((game_over == 2))
	begin
		red = 0;
		green = 0;
		blue = 0;
		//use a module called draw "Player2 Win"
	end
	
	// display black: we're outside game zone
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
