/*
Takes in the current bomb map, bomb clock of 1Hz and reset signal,
outputs the updated bomb map.
*/
module bomb(
    // Outputs
    updatedBombMap, o_healthA, o_healthB,
    // Inputs
    curBombMap, healthA, healthB,
    playerAx, playerAy, playerBx, playerBy,
    bombClk, rst
);

    input [1:0] curBombMap[9:0][9:0];
    input [3:0] playerAx, playerAy, playerBx, playerBy;
    input [1:0] healthA, healthB;
    input bombClk;
    input rst;
    output reg [1:0] updatedBombMap[9:0][9:0];
    output reg [1:0] o_healthA, o_healthB;
    
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
                        if (playerAx == x and playerAy - y < 3 and y - playerAy > -3) begin
                            if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
                        end
                        else if (playerAy == y and playerAx - x < 3 and x - playerAx > -3) begin
                            if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
                        end
                        // Hit player B
                        if (playerBx == x and playerBy - y < 3 and y - playerBy > -3) begin
                            if (healthB != 0)
                                o_healthB <= healthB - 1;
                            else
                                o_healthB <= 0;
                        end
                        else if (playerBy == y and playerBx - x < 3 and x - playerBx > -3) begin
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
        end
    end

endmodule