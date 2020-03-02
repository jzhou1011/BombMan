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
    wire [3:0] playerAinput;  

    // player2: use buttons to control character
    wire btnS_crt;
    wire btnR_crt;
    wire btnL_crt;
    wire btnU_crt;
    wire btnD_crt;  

    // character status
    reg [1:0] playerAhealth = 1;
    reg [1:0] playerBhealth = 1;

    // arena and bombs status
    reg [1:0] arena [9:0][9:0];
    reg [1:0] bombs [9:0][9:0];

    // TODO: initialize?

    // clock divider
    wire bomb_clk; // 1 Hz
    wire vga_clk; // 500 Hz
    wire faster_clk; // seven segment display

    // clocks
    clockDivider clockDivider_(
	    .clk		(clk),
        .rst        (0),
	    .oneHzClock	(bomb_clk),
	    .VGAClock	(vga_clk),
        .segClock (faster_clk)
    );

    // read player1 input from keypad
    keypad keypad_(
        .clk    (clk),
        .row    (JA[7:4]),
	    .col    (JA[3:0]),
        .decode (playerAinput)
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
	    .playerA    (playerAinput),
        .Arena      (arena),
	    .Bomb       (bombs),
        .clk        (clk),
	    .crt_Arena  (arena),
	    .crt_Bomb   (bombs),
        .bomb_clk   (bomb_clk)
    );

    bomb bomb_(
        .updatedBombMap (bombs), 
        .o_healthA      (healthA), 
        .o_healthB      (healthB),
        .curBombMap     (bombs), 
        .curArena       (arena), 
        .healthA        (healthA), 
        .healthB        (healthB), 
        .bombClk        (bomb_clk), 
        .rst            (0)
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


