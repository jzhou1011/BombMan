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

    // arena and bombs status
    reg [1:0] arena [9:0][9:0];
    reg [1:0] bombs [9:0][9:0];
    // TODO: initialize?
    
    // clock divider
	wire bomb_clk; // 1 Hz
	wire vga_clk; // 500 Hz
    wire faster_clk; // seven segment display
    // wire move_clk; use Debouncer instead

    // seven segment display
    wire [7:0] seven_o;

    // clocks
    clock_select clock_selector_(
	    .clk		(clk),
	    .bomb_clk	(bomb_clk),
	    .vga_clk	(vga_clk),
        .faster_clk (faster_clk)
    );

    // read player1 input from keypad
    keypad keypad_(
        .clk    (clk),
        .row    (JA[7:4]),
	    .col    (JA[3:0]),
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

    movement movement_(
        .btnS       (btnS_crt),
        .btnD       (btnD_crt),
        .btnR       (btnR_crt),
        .btnL       (btnL_crt),
        .btnU       (btnU_crt),
        .playerA    (playerAinput),
        .arena_map  (arena),
        .bomb_map   (bombs)
    );

    bombTimer bombTimer_(
        .bomb_clk   (bomb_clk),
        .arena_map  (arena),
        .bomb_map   (bombs)
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







    














