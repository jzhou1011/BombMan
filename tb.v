  
`timescale 1ns/1ps

module test;
    reg clk;
    reg [7:0] JA;
    reg btnS, btnR, btnL, btnD, btnU;
	 //reg rst;
    
	 reg hsync;
	 reg vsync;
    reg [7:0] seg;
    reg [3:0] an;
	 reg [7:0] sw;
	 
	 localparam bombperiod = 100000;//100000000;
	 localparam debopeirod = 10000;

    bomberman uut(
        .seg(seg), .an(an), .clk(clk), .hsync(hsync),
		  .vsync(vsync), .sw(sw),
        .JA(JA), .btnD(btnD), .btnL(btnL),
        .btnR(btnR), .btnS(btnS), .btnU(btnU)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        //rst = 0;
        JA = 8'b00010000;
		  vsync = 0;
		  hsync = 0;
		  sw = 0;
        btnU = 0;
        btnS = 0;
        btnR = 0;
        btnL = 0;
        btnD = 0;

        // Wait 100 ns for global reset to finish
		#100;

        // Add stimulus here
        sw[7] = 1;
		  $display("sw is now 1");
        #100000 // bomb period
        sw[7] = 0;
		  $display("sw is now 0");
        // Start game
        #3000
        // Player A drops bomb at current position
        tskADropBomb;
        tskBDropBomb;
		  #300000 //3 * bomb period
		  tskAMovesD;
		  #1000
		  tskAMovesD;
		  #1000
		  tskAMovesR;
		  #1000
		  tskAMovesU;
		  #1000
		  tskADropBomb;
		  #300000 //3 * bomb period
        $display("Check: player A and B should both have health of 2 now.");
		  
		  $finish;
	 end

    always #5 clk = ~clk;

    task tskADropBomb;
        begin
            $display("...Player A drops a bomb");
            btnS = 1;
            #200000 //2*bomb period
            btnS = 0;
        end
    endtask

    task tskBDropBomb;
        begin
            $display("...Player B drops a bomb");
            JA = 8'b10110000;
            #200000 //2*bomb period
            JA = 8'b00010000;
        end
    endtask
	 
	 task tskAMovesD;
			begin
				$display("...Player A moves down");
				btnD = 1;
				#150000
				btnD = 0;
			end
	 endtask
				
	 task tskAMovesR;
			begin
				$display("...Player A moves right");
				btnR = 1;
				#150000
				btnR = 0;
			end
	 endtask
	 task tskAMovesU;
			begin
				$display("...Player A moves up");
				btnU = 1;
				#150000
				btnU = 0;
			end
	 endtask
	 
	 task tskAMovesL;
			begin
				$display("...Player A moves left");
				btnL = 1;
				#150000
				btnL = 0;
			end
	 endtask
endmodule