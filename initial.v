module reset(
	arena_0, arena_1, bombs_0, bombs_1, 
    rst, healthA, healthB, game_state
);

	output reg [99:0] arena_0;
    output reg [99:0] bombs_0;
    output reg [99:0] arena_1;
    output reg [99:0] bombs_1;

    input rst;
    output reg [1:0] healthA, healthB, game_state;
	reg [3:0] i,j;

    always @ (posedge rst)
    begin
        // initialize arena and bombs
        for (i = 0; i < 10; i = i+1) begin
	    	for (j = 0; j < 10; j = j+1) begin
                bombs_0[i*10+j] <= 0;
                bombs_1[i*10+j] <= 0;
                if (i == 0 || i == 9 || j == 0 || j == 9) begin
                    arena_0[i*10+j] <= 1;
                    arena_1[i*10+j] <= 0; // block
                end
                else begin
                    arena_0[i*10+j] <= 0;
                    arena_1[i*10+j] <= 0;  // blank
                end
	    	end
        end

        // initialize players and blcks
        arena_0[11] <= 0; // player A
        arena_0[88] <= 1; // player B
        arena_0[13] <= 1; // blocks
        arena_0[17] <= 1;
        arena_0[24] <= 1;
        arena_0[32] <= 1;
        arena_0[34] <= 1;
        arena_0[38] <= 1;
        arena_0[46] <= 1;
        arena_0[51] <= 1;
        arena_0[56] <= 1;
        arena_0[57] <= 1;
        arena_0[62] <= 1;
        arena_0[63] <= 1;
        arena_0[76] <= 1;
        arena_0[84] <= 1;
        
        arena_1[11] <= 1; // player A
        arena_1[88] <= 1; // player B
        arena_1[13] <= 0; // blocks
        arena_1[17] <= 0;
        arena_1[24] <= 0;
        arena_1[32] <= 0;
        arena_1[34] <= 0;
        arena_1[38] <= 0;
        arena_1[46] <= 0;
        arena_1[51] <= 0;
        arena_1[56] <= 0;
        arena_1[57] <= 0;
        arena_1[62] <= 0;
        arena_1[63] <= 0;
        arena_1[76] <= 0;
        arena_1[84] <= 0;

        healthA <= 3;
        healthB <= 3;
        game_state <= 0;
    end  

endmodule