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
    bombClk, rst, game_state
);

    input [99:0] i_curBombMap_0;
    input [99:0] i_curBombMap_1;
    input [3:0] playerAx, playerAy, playerBx, playerBy;
    input [1:0] healthA, healthB;
    input bombClk;
    input rst;
    output [99:0] o_updatedBombMap_0;
    output [99:0] o_updatedBombMap_1;
    output reg [1:0] o_healthA, o_healthB;
	output reg [1:0] game_state;
	
	integer x,y;
    
    wire [1:0] curBombMap[9:0][9:0];
    reg [1:0] updatedBombMap[9:0][9:0];
	
	genvar i,j;

    for (i = 1;i < 9; i = i+1) begin
        for (j= 1; j< 9; j= j+1) begin
            assign curBombMap[i][j] = {i_curBombMap_1[10 *i + j], i_curBombMap_0[10 * i + j]};
        end
    end


    always @ (posedge bombClk or posedge rst) begin
        if (rst) begin
            for (x = 1; x<9; x = x+1) begin
                for (y=1; y<9; y=y+1) begin
                    updatedBombMap[x][y] <= 0;
                end
            end
        end
        else begin
            for (x = 1; x<9; x = x+1) begin
                for (y=1; y<9; y=y+1) begin
                    // No bomb
                    if (curBombMap[x][y] == 0) begin
                        updatedBombMap[x][y] <= 0;
                    end
                    // Bomb exploding
                    else if (curBombMap[x][y] == 3) begin
                        updatedBombMap[x][y] <= 0;
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
                    else
                        updatedBombMap[x][y] <= curBombMap[x][y] + 1;
					
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
        end
    end

    for (i = 1;i < 9; i = i+1) begin
        for (j= 1; j< 9; j= j+1) begin
            assign o_updatedBombMap_0[10 * i + j] = updatedBombMap[i][j][0];
            assign o_updatedBombMap_1[10 * i + j] = updatedBombMap[i][j][1];
        end
    end

endmodule