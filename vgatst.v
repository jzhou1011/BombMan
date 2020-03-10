`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:10:50 03/09/2020
// Design Name:   vga640x480
// Module Name:   C:/Users/152/Documents/tst2/tsrt.v
// Project Name:  tst2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga640x480
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tsrt;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] player1_x;
	reg [3:0] player1_y;
	reg [3:0] player2_x;
	reg [3:0] player2_y;
	reg [99:0] Arena_bit0;
	reg [99:0] Bomb_bit0;
	reg [99:0] Bomb_bit1;
	reg [1:0] game_over;

	// Outputs
	wire hsync;
	wire vsync;
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	// Instantiate the Unit Under Test (UUT)
	vga640x480 uut (
		.pixel_clk(clk), 
		.rst(rst), 
		.player1_x(player1_x), 
		.player1_y(player1_y), 
		.player2_x(player2_x), 
		.player2_y(player2_y), 
		.Arena_bit0(Arena_bit0), 
		.Bomb_bit0(Bomb_bit0), 
		.Bomb_bit1(Bomb_bit1), 
		.game_over(game_over), 
		.hsync(hsync), 
		.vsync(vsync), 
		.red(red), 
		.green(green), 
		.blue(blue)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		player1_x = 0;
		player1_y = 0;
		player2_x = 0;
		player2_y = 0;
		Arena_bit0 = 100'b0000000000000101010001110101000101010100000001010000000000000000000000000000000000000000000000000000;
		Bomb_bit0 = 100'b0000000000000000000000000000000000000000000000000000000000000000100000000010100000100001000000000000;
		Bomb_bit1 = 100'b0000000000000000000000000000000000000000000000000000000000000000100000000010100000100001000000000000;
		game_over = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$finish
	end
	
	always #5 clk = ~clk;
      
endmodule

