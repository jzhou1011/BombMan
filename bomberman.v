module bomberman(
    //output
    seg, an, // VGA!
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

	output reg [7:0] seg;
	output reg [3:0] an;

    // player1: use keypad to control character
    wire playerAinput;

    // player2: use buttons to control character
    wire btnS_crt;
	wire btnR_crt;
    wire btnL_crt;
	wire btnU_crt;
    wire btnD_crt;

    // character status
    reg [1:0] playerAhealth = 1;
    reg [1:0] playerBhealth = 1;

    // arena and bombs
    // reg [1:0] Arena [0:9]
    // reg [1:0] bombs [0:9]

    
    // read player1 input from keypad
    keypad keypad_(
        .clk    (clk),
        .JA     (JA),
        .decode (playerAinput)
    );

    // read player2 input from buttons: use debouncing
    // TODO: debouncing module input/ouput?
    debouncing debounce_S( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnS_crt)
    );

    debouncing debounce_R( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnR_crt)
    );

    debouncing debounce_L( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnL_crt)
    );

    debouncing debounce_U( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnU_crt)
    );

    debouncing debounce_D( 
	    //input
	    .btn		(btnS),
	    .the_clk	(clk),
	    //output
	    .btn_crt	(btnD_crt)
    );












