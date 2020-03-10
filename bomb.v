/*
Takes in the current bomb map, bomb clock of 1Hz and reset signal,
outputs the updated bomb map.
*/
module bomb(
    // Outputs
    o_updatedBombMap_0, o_updatedBombMap_1, o_healthA, o_healthB,
    // Inputs
    i_curBombMap_0, i_curBombMap_1, healthA, healthB,
    playerAx, playerAy, playerBx, playerBy,
    bombA_x, bombA_y, bombA_v, bombB_x, bombB_y, bombB_v,
    bombClk, rst, game_state
);

    input [99:0] i_curBombMap_0;
    input [99:0] i_curBombMap_1;
    input [3:0] playerAx, playerAy, playerBx, playerBy;
    input [1:0] healthA, healthB;
    input bombClk;
    input rst;
    input bombA_v, bombB_v;
    input [3:0] bombA_x, bombA_y, bombB_x, bombB_y;
    output reg [99:0] o_updatedBombMap_0;
    output reg [99:0] o_updatedBombMap_1;
    output reg [1:0] o_healthA, o_healthB;
	output reg [1:0] game_state;
	
	integer x,y;

    always @ (posedge bombClk) begin
        if (rst) begin
            for (x = 1; x<9; x = x+1) begin
                for (y=1; y<9; y=y+1) begin
                    o_updatedBombMap_0[10 * x + y] <= 0;
                    o_updatedBombMap_1[10 * x + y] <= 0;
                end
            end
			o_healthA <= 3;
			o_healthB <= 3;
			game_state <= 0;
        end
        else begin
            for (x = 1; x<9; x = x+1) begin
                for (y=1; y<9; y=y+1) begin
                    // No bomb
                    if (i_curBombMap_1[10 * x + y] == 0 && i_curBombMap_0[10 * x + y] == 0) begin
                        o_updatedBombMap_0[10 * x + y] <= 0;
                        o_updatedBombMap_1[10 * x + y] <= 0;
                    end
                    // Bomb exploding
                    else if (i_curBombMap_1[10 * x + y] == 1 && i_curBombMap_0[10 * x + y] == 1) begin
                        o_updatedBombMap_0[10 * x + y] <= 0;
                        o_updatedBombMap_1[10 * x + y] <= 0;
                        // Hit player A, no repetitive damage in one cycle
                        // It player A on the same line and y coord with radius of 2
                        if (playerAx == x && playerAy - y < 3 && y - playerAy > -3) begin
                            if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
                        end
                        else if (playerAy == y && playerAx - x < 3 && x - playerAx > -3) begin
                            if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
                        end
                        // Hit player B
                        if (playerBx == x && playerBy - y < 3 && y - playerBy > -3) begin
                            if (healthB != 0)
                                o_healthB <= healthB - 1;
                            else
                                o_healthB <= 0;
                        end
                        else if (playerBy == y && playerBx - x < 3 && x - playerBx > -3) begin
                            if (healthB != 0)
                                o_healthB <= healthB - 1;
                            else
                                o_healthB <= 0;
                        end
                    end
                    // Bomb state advancing
                    else begin
                        o_updatedBombMap_1[10 * x + y] <= o_updatedBombMap_0[10 * x + y] ^ o_updatedBombMap_1[10 * x + y];
                        o_updatedBombMap_0[10 * x + y] <= ~o_updatedBombMap_0[10 * x + y];
                    end
					
                end
            end
			if (o_healthA == 0)
			begin
				if (o_healthB == 0)
					game_state <= 3;
				else
					game_state <= 2;
			end
			else if(o_healthB == 0)
				game_state <= 1;
            if (bombA_v == 1) begin
                o_updatedBombMap_1[10 * bombA_x + bombA_y] <= 0;
                o_updatedBombMap_0[10 * bombA_x + bombA_y] <= 1;
            end
            if (bombB_v == 1) begin
                o_updatedBombMap_1[10 * bombB_x + bombB_y] <= 0;
                o_updatedBombMap_0[10 * bombB_x + bombB_y] <= 1;
            end
        end
    end

endmodule
