module bomberman(
    //output
    seg, an, hsync, vsync, red, green, blue,
    //input
    clk, reset_sw, JA, btnS, btnR, btnL, btnD, btnU
);

    input [7:0] JA;
    input clk;
    input btnR;
    input btnS;
    input btnL;
    input btnU;
    input btnD;
    input reset_sw;
	
	reg reset = 1;
	always @ (posedge reset_sw)
	begin
		reset = ~reset;
	end

    output [7:0] seg;
    output [3:0] an;

    // vga
    output hsync;//horizontal sync out
    output vsync; //vertical sync out
    output [2:0] red; //red vga output
    output [2:0] green; //green vga output
    output [1:0] blue; //blue vga output

    // player1: use keypad to control character
    wire [3:0] playerBinput;  

    // player2: use buttons to control character
    wire btnS_crt;
    wire btnR_crt;
    wire btnL_crt;
    wire btnU_crt;
    wire btnD_crt;  

    // character status
    reg [1:0] playerAhealth = 3;
    reg [1:0] playerBhealth = 3;
    wire [3:0] playerAx;
    wire [3:0] playerAy;
    wire [3:0] playerBx;
    wire [3:0] playerBy;

    // arena and bombs status
    reg [1:0] game_state = 0;

    // flattened array
	wire arena_0 [99:0];
    wire arena_1 [99:0];
    wire bombs_0 [99:0];
	wire bombs_1 [99:0];
	reg o_arena_0 [99:0];
    reg o_bombs_0 [99:0];
    reg o_arena_1 [99:0];
    reg o_bombs_1 [99:0];

    // clock divider
    wire bomb_clk; // 1 Hz
    wire vga_clk; // 500 Hz
    wire faster_clk; // seven segment display

    genvar i,j; // for initialize

    // clocks
    clockDivider clockDivider_(
	    .clk		(clk),
        .rst        (reset),
	    .oneHzClock	(bomb_clk),
	    .VGAClock	(vga_clk),
        .segClock (faster_clk)
    );

    // //initialize health
    // assign playerAhealth = 3;
    // assign playerBhealth = 3;

    // initialize arena and bombs
	
    for (i = 0; i < 10; i = i+1) begin
		for (j = 0; j < 10; j = j+1) begin
            assign arena_0[i][j] = o_arena_0[i][j];
			assign bombs_0[i][j] = o_bombs_0[i][j];
            assign arena_1[i][j] = o_arena_1[i][j];
			assign bombs_1[i][j] = o_bombs_1[i][j];
		end
    end
	
	/*
    // initialize players and blcks
    assign arena[11] = 2; // player A
    assign arena[88] = 3; // player B
    assign arena[13] = 1; // blocks
    assign arena[17] = 1;
    assign arena[24] = 1;
    assign arena[32] = 1;
    assign arena[34] = 1;
    assign arena[38] = 1;
    assign arena[46] = 1;
    assign arena[51] = 1;
    assign arena[56] = 1;
    assign arena[57] = 1;
    assign arena[62] = 1;
    assign arena[63] = 1;
    assign arena[76] = 1;
    assign arena[84] = 1; */

    reset reset_(
        .arena_0      (o_arena_0),
        .bombs_0      (o_bombs_0),
        .arena_1      (o_arena_1),
        .bombs_1      (o_bombs_1),
        .rst        (reset),
        .healthA    (playerAhealth),
        .healthB    (playerBhealth),
        .game_state (game_state)
    );

    // read player1 input from keypad
    keypad keypad_(
        .clk    (clk),
        .row    (JA[7:4]),
	    //.col    (JA[3:0]),
        .decode (playerBinput)
    );

    // read player2 input from buttons: use debouncing
    debouncing debounce_S( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnS_crt)
    );

    debouncing debounce_R( 
	    //input
	    .btn		(btnR),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnR_crt)
    );

    debouncing debounce_L( 
	    //input
	    .btn		(btnL),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnL_crt)
    );

    debouncing debounce_U( 
	    //input
	    .btn		(btnU),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnU_crt)
    );

    debouncing debounce_D( 
	    //input
	    .btn		(btnD),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnD_crt)
    );

    chara_control chara_control_(
        .Up         (btnU_crt),
	    .Down       (btnD_crt),
	    .Left       (btnL_crt),
	    .Right      (btnR_crt),
        .Center     (btnS_crt),
	    .playerB    (playerBinput),
        .Arena_bit0          (arena_0),
	    .Arena_bit1          (arena_1),
	.Bomb_bit0          (bomb_0),
	    .Bomb_bit1          (bomb_1),
        .clk        (clk),
	.crt_Arena_bit0  (o_arena_0),
	    .crt_Arena_bit1  (o_arena_1),
	.crt_Bomb_bit0   (o_bombs_0),
	    .crt_Bomb_bit1   (o_bombs_1),
        .bomb_clk   (bomb_clk),
        .playerAx   (playerAx),
	    .playerAy   (playerAy),
	    .playerBx   (playerBx),
	    .playerBy   (playerBy)
    );

    bomb bomb_(
        .o_updatedBombMap_0 (o_bombs_0),
        .o_updatedBombMap_1 (o_bombs_1), 
        .o_healthA      (healthA), 
        .o_healthB      (healthB),
        .i_curBombMap_0     (bombs_0),
        .i_curBombMap_1     (bombs_1),
        .healthA        (healthA), 
        .healthB        (healthB), 
        .bombClk        (bomb_clk), 
        .rst            (reset),
        .playerAx       (playerAx),
	    .playerAy       (playerAy),
	    .playerBx       (playerBx),
	    .playerBy       (playerBy),
		.game_state		(game_state)
    );

    sevenSeg sevenSeg_(
        .healthA    (playerAhealth), 
        .healthB    (playerBhealth), 
        .clk        (faster_clk),
        .seg        (seg), 
        .an         (an)
    );

    // VGA
    vga640x480 vga_(
        .pixel_clk      (vga_clk), //pixel clock: 25MHz
        .rst            (reset), //asynchronous reset
        .player1_x      (playerAx),
        .player1_y      (playerAy),
        .player2_x      (playerBx),
        .player2_y      (playerBy),
	.Arena_bit0          (arena_0),
	    .Arena_bit1          (arena_1),
	.Bomb_bit0          (bomb_0),
	    .Bomb_bit1          (bomb_1),
        .game_over      (game_state), // three values: player 1 win, player 2 win, draw
        .hsync          (hsync), //horizontal sync out
        .vsync          (vsync), //vertical sync out
        .red            (red), //red vga output
        .green          (green), //green vga output
        .blue           (blue)//blue vga output
    );

endmodule


