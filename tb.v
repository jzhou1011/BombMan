  
`timescale 1ns/1ps

module test;
    reg clk;
    wire [7:0] JA;
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
		  vsync = 0;
		  hsync = 0;
		  sw = 0;
        btnU = 0;
        btnS = 0;
        btnR = 0;
        btnL = 0;
        btnD = 0;

        // Wait 100 ns for global reset to finish
		#1000;

        // Add stimulus here
        sw[7] = 1;
		  $display("sw is now 1");
        #50000
        sw[7] = 0;
		  $display("sw is now 0");
        // Start game
        #3000
        // Player A drops bomb at current position
        // tskADropBomb;
		  tskAMovesD;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesR;
		  #10000
		  tskAMovesR;
		  #10000
		  tskAMovesR;
		  #10000
		  tskAMovesR;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesD;
		  #10000
		  tskAMovesR;
		  #10000
		  tskADropBomb;
		  tskADropBomb;
		  tskADropBomb;
		  #200000
		  // tskADropBomb;
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
				#300000; //3 * bomb period
        end
    endtask

   
	 
	 task tskAMovesD;
			begin
				$display("...Player A moves down");
				btnD = 1;
				#200000
				btnD = 0;
			end
	 endtask
				
	 task tskAMovesR;
			begin
				$display("...Player A moves right");
				btnR = 1;
				#200000
				btnR = 0;
			end
	 endtask
	 task tskAMovesU;
			begin
				$display("...Player A moves up");
				btnU = 1;
				#200000
				btnU = 0;
			end
	 endtask
	 
	 task tskAMovesL;
			begin
				$display("...Player A moves left");
				btnL = 1;
				#200000
				btnL = 0;
			end
	 endtask
endmodule