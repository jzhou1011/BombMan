module reset(
    arena, bombs,
    rst, healthA, healthB, game_state
);

    inout reg [1:0] arena [9:0][9:0];
    inout reg [1:0] bombs [9:0][9:0];

    input rst;
    inout reg [1:0] healthA, healthB, game_state;

    always @ (posedge rst)
    begin
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

        healthA = 3;
        healthB = 3;
        game_state = 0;
    end  

endmodule