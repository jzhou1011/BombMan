/*
Takes in the current bomb map, bomb clock of 1Hz and reset signal,
outputs the updated bomb map.
*/
module bomb(
    // Outputs
    updatedBombMap, o_healthA, o_healthB,
    // Inputs
    curBombMap, curArena, healthA, healthB, bombClk, rst
);

    input [1:0] curBombMap[9:0][9:0];
    input [1:0] curArena[9:0][9:0];
    input [1:0] healthA, healthB;
    input bombClk;
    input rst;
    output reg [1:0] updatedBombMap[9:0][9:0];
    output reg [1:0] o_healthA, o_healthB;
    
    always @ (posedge bombClk or posedge rst) begin
        if (rst) begin
            for (x = 0; x<10; x = x+1) begin
                for (y=0; y<10; y=y+1) begin
                    updatedBombMap[y][x] <= 0;
                end
            end
        end
        else begin
            for (x = 0; x<10; x = x+1) begin
                for (y=0; y<10; y=y+1) begin
                    // No bomb
                    if (curBombMap[y][x] == 0) begin
                        updatedBombMap[y][x] <= 0;
                    end
                    // Bomb exploding
                    else if (curBombMap[y][x] == 3) begin
                        updatedBombMap[y][x] <= 0;
                        // Hit player A, no repetitive damage in one cycle
                        if (curArena[y][x] == 2) begin
                            if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
                        // Hit player B
                        if (curArena[y][x] == 3) begin
                            if (healthB != 0)
                                o_healthB <= healthB - 1;
                            else
                                o_healthB <= 0;
                        end
                    end
                    // Bomb state advancing
                    else
                        updatedBombMap[y][x] <= curBombMap[y][x] + 1;
                end
            end
        end
    end
    

endmodule