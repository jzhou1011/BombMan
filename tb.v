`timescale 1ns/1ps

module test;
    reg clk;
    reg [7:0] JA;
    reg btnS, btnR, btnL, btnD, btnU;
    
    reg [7:0] seg;
    reg [3:0] an;

    bomberman uut(
        .seg(seg), .an(an), .clk(clk),
        .JA(JA), .btnD(btnD), .btnL(btnL),
        .btnR(btnR), btnS(btnS), btnU(btnU), .rst(rst)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        JA = 8'b00010000;
        btnU = 0;
        btnS = 0;
        btnR = 0;
        btnL = 0;
        btnD = 0;

        // Wait 100 ns for global reset to finish
		#100;

        // Add stimulus here
        #50
        rst = 1;
        #50
        rst = 0;
        // Start game
        #100
        // Player A drops bomb at current position
        tskADropBomb;
        tskBDropBomb;
        $display("Check: player A and B should both have health of 2 now.");
    end

    always #5 clk = ~clk;

    task tskADropBomb;
        begin
            $display("...Player A drops a bomb");
            btnS = 1;
            #2000000000
            btnS = 0;
        end
    endtask

    task tskBDropBomb;
        begin
            $display("...Player B drops a bomb");
            JA = 8'b10110000;
            #2000000000
            JA = 8'b00010000;
        end
    endtask

endmodule