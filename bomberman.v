module bomberman(
    //output
    seg, an, hsync, vsync, red, green, blue,
    //input
    clk, sw, JA, btnS, btnR, btnL, btnD, btnU
);
	
    input [7:0] JA;
    input clk;
    input btnR;
    input btnS;
    input btnL;
    input btnU;
    input btnD;
    input [7:0] sw;
	
	wire reset_sw;
	assign reset_sw = sw[7];
	
	reg reset = 1;
	always @ (reset_sw)
	begin
		//if ()
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
    wire [1:0] playerAhealth;
    wire [1:0] playerBhealth;
	wire [1:0] o_playerAhealth;
    wire [1:0] o_playerBhealth;
    wire [3:0] playerAx;
    wire [3:0] playerAy;
    wire [3:0] playerBx;
    wire [3:0] playerBy;
    wire [3:0] o_playerAx;
    wire [3:0] o_playerAy;
    wire [3:0] o_playerBx;
    wire [3:0] o_playerBy;

    // arena and bombs status
    wire [1:0] game_state;

    // flattened array
	wire [99:0] arena_0;
	wire [99:0] arena_0_inter;
    wire [99:0] bombs_0;
	wire [99:0] bombs_1;
	wire [99:0] bombs_0_inter;
	wire [99:0] bombs_1_inter;
	wire [99:0] bombs_0_inter_2;
	wire [99:0] bombs_1_inter_2;
	wire [99:0] o_arena_0;
    wire [99:0] o_bombs_0;
    wire [99:0] o_bombs_1;

    // clock divider
    wire bomb_clk; // 1 Hz
    wire vga_clk; // 500 Hz
    wire faster_clk; // seven segment display

    genvar i; // for initialize

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
	
    for (i = 0; i < 100; i = i+1) begin
            assign arena_0[i] = o_arena_0[i];
			assign bombs_0[i] = o_bombs_0[i];
			assign bombs_1[i] = o_bombs_1[i];
    end
	
	assign playerAx = o_playerAx;
    assign playerAy = o_playerAy;
    assign playerBx = o_playerBx;
    assign playerBy = o_playerBy;
	assign playerAhealth = o_playerAhealth;
    assign playerBhealth = o_playerBhealth;
	
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

    initialize reset_(
        .arena_0      (arena_0_inter),
        .bombs_0      (bombs_0_inter),
        .bombs_1      (bombs_1_inter),
        .rst        (reset)
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
        .onedim_Arena          (arena_0_inter),
	    .Bomb_bit0          (bombs_0_inter),
	    .Bomb_bit1          (bombs_1_inter),
        .clk        (clk),
	    .crt_Arena_bit0  (o_arena_0),
	    .crt_Bomb_bit0   (bombs_0_inter_2),
	    .crt_Bomb_bit1   (bombs_1_inter_2),
        .bomb_clk   (bomb_clk),
        .playerAx   (playerAx),
	    .playerAy   (playerAy),
	    .playerBx   (playerBx),
	    .playerBy   (playerBy),
        .o_playerAx (o_playerAx),
        .o_playerAy (o_playerAy),
        .o_playerBx (o_playerBx),
        .o_playerBy (o_playerBy),
		.rst	(reset)
    );

    bomb bomb_(
        .o_updatedBombMap_0 (o_bombs_0),
        .o_updatedBombMap_1 (o_bombs_1), 
        .o_healthA      (o_playerAhealth), 
        .o_healthB      (o_playerBhealth),
        .i_curBombMap_0     (bombs_0_inter_2),
        .i_curBombMap_1     (bombs_1_inter_2),
        .healthA        (playerAhealth), 
        .healthB        (playerBhealth), 
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
	    .Bomb_bit0          (bombs_0),
	    .Bomb_bit1          (bombs_1),
        .game_over      (game_state), // three values: player 1 win, player 2 win, draw
        .hsync          (hsync), //horizontal sync out
        .vsync          (vsync), //vertical sync out
        .red            (red), //red vga output
        .green          (green), //green vga output
        .blue           (blue)//blue vga output
    );

endmodule


