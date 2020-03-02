module bomberman(
    //output
    seg, an, // TODO: VGA!
    //input
    clk, JA, btnS, btnR, btnL, btnD, btnU
);

    input [7:0] JA;
    input clk;
    input btnR;
    input btnS;
    input btnL;
    input btnU;
    input btnD;

    output [7:0] seg;
    output [3:0] an;

    // player1: use keypad to control character
    wire [3:0] playerBinput;  

    // player2: use buttons to control character
    wire btnS_crt;
    wire btnR_crt;
    wire btnL_crt;
    wire btnU_crt;
    wire btnD_crt;  

    // character status
    reg [1:0] playerAhealth = 1;
    reg [1:0] playerBhealth = 1;
    wire [3:0] playerAx;
    wire [3:0] playerAy;
    wire [3:0] playerBx;
    wire [3:0] playerBy;

    // arena and bombs status
    reg [1:0] arena [9:0][9:0];
    reg [1:0] bombs [9:0][9:0];

    // clock divider
    wire bomb_clk; // 1 Hz
    wire vga_clk; // 500 Hz
    wire faster_clk; // seven segment display

    reg [4:0] i,j; // for initialize

    // clocks
    clockDivider clockDivider_(
	    .clk		(clk),
        .rst        (0),
	    .oneHzClock	(bomb_clk),
	    .VGAClock	(vga_clk),
        .segClock (faster_clk)
    );

    // initialize arena and bombs
    for (i = 0; i < 10; i += 1) begin
		for (j = 0; j < 10; j += 1) begin
            bombs[i][j] = 0;
            if (i == 0 || i == 9 || j == 0 || j == 9) begin
                arena[i][j] = 1; // block
            end
            else begin
                arena[i][j] = 0; // blank
            end
		end
    end

    // initialize players and blcks
    arena[1][1] = 2; // player A
    arena[8][8] = 3; // player B
    arena[1][3] = 1; // blocks
    arena[1][7] = 1;
    arena[2][4] = 1;
    arena[3][2] = 1;
    arena[3][4] = 1;
    arena[3][8] = 1;
    arena[4][6] = 1;
    arena[5][1] = 1;
    arena[5][6] = 1;
    arena[5][7] = 1;
    arena[6][2] = 1;
    arena[6][3] = 1;
    arena[7][6] = 1;
    arena[8][4] = 1;

    // read player1 input from keypad
    keypad keypad_(
        .clk    (clk),
        .row    (JA[7:4]),
	    .col    (JA[3:0]),
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
        .Arena      (arena),
	    .Bomb       (bombs),
        .clk        (clk),
	    .crt_Arena  (arena),
	    .crt_Bomb   (bombs),
        .bomb_clk   (bomb_clk),
        .playerAx   (playerAx),
	    .playerAy   (playerAy),
	    .playerBx   (playerBx),
	    .playerBy   (playerBy)
    );

    bomb bomb_(
        .updatedBombMap (bombs), 
        .o_healthA      (healthA), 
        .o_healthB      (healthB),
        .curBombMap     (bombs), 
        .healthA        (healthA), 
        .healthB        (healthB), 
        .bombClk        (bomb_clk), 
        .rst            (0),
        .playerAx   (playerAx),
	    .playerAy   (playerAy),
	    .playerBx   (playerBx),
	    .playerBy   (playerBy)
    );

    sevenSeg sevenSeg_(
        .healthA    (playerAhealth), 
        .healthB    (playerBhealth), 
        .clk        (faster_clk),
        .seg        (seg), 
        .an         (an)
    );

    // VGA

endmodule


