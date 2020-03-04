module reset(
	arena, bombs,
    rst, healthA, healthB, game_state
);

	output reg [1:0] arena [99:0];
    output reg [1:0] bombs [99:0];

    input rst;
    output reg [1:0] healthA, healthB, game_state;
	reg [3:0] i,j;

    always @ (posedge rst)
    begin
        // initialize arena and bombs
        for (i = 0; i < 10; i = i+1) begin
	    	for (j = 0; j < 10; j = j+1) begin
                bombs[i*10+j] <= 0;
                if (i == 0 || i == 9 || j == 0 || j == 9) begin
                    arena[i*10+j] <= 1; // block
                end
                else begin
                    arena[i*10+j] <= 0; // blank
                end
	    	end
        end

        // initialize players and blcks
        arena[11] <= 2; // player A
        arena[88] <= 3; // player B
        arena[13] <= 1; // blocks
        arena[17] <= 1;
        arena[24] <= 1;
        arena[32] <= 1;
        arena[34] <= 1;
        arena[38] <= 1;
        arena[46] <= 1;
        arena[51] <= 1;
        arena[56] <= 1;
        arena[57] <= 1;
        arena[62] <= 1;
        arena[63] <= 1;
        arena[76] <= 1;
        arena[84] <= 1;

        healthA <= 3;
        healthB <= 3;
        game_state <= 0;
    end  

endmodule