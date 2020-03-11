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
	
	integer x,y,i;

    always @ (posedge bombClk) begin
        if (rst) begin
            for (x = 0; x<10; x = x+1) begin
                for (y=0; y<10; y=y+1) begin
                    o_updatedBombMap_0[10 * x + y] <= 0;
                    o_updatedBombMap_1[10 * x + y] <= 0;
                end
            end
			o_healthA <= 3;
			o_healthB <= 3;
			game_state <= 0;
        end
        else begin
            for (x = 0; x<10; x = x+1) begin
                for (y=0; y<10; y=y+1) begin
                    // No bomb
                    if (i_curBombMap_1[10 * x + y] == 0 && i_curBombMap_0[10 * x + y] == 0) begin
                        o_updatedBombMap_0[10 * x + y] <= 0;
                        o_updatedBombMap_1[10 * x + y] <= 0;
                    end
                    // Bomb exploding
                    else if (i_curBombMap_1[10 * x + y] == 1 && i_curBombMap_0[10 * x + y] == 1) begin
                        o_updatedBombMap_0[10 * x + y] <= 0;
                        o_updatedBombMap_1[10 * x + y] <= 0;
								if (playerAx == x && playerAy == y) begin
									if (healthA != 0)
                                o_healthA <= healthA - 1;
                            else
                                o_healthA <= 0;
								end
								if (playerBx == x && playerBy == y) begin
									if (healthB != 0)
                                o_healthB <= healthB - 1;
                            else
                                o_healthB <= 0;
								end
                    end
						 end
					end
            // Bomb state advancing
			for (x = 0; x<10; x = x+1) begin
            for (y=0; y<10; y=y+1) begin
					if (i_curBombMap_1[10 * x + y] == 1 && i_curBombMap_0[10 * x + y] == 0) 
					begin
						o_updatedBombMap_0[x*10+y] <= 1;
						o_updatedBombMap_1[x*10+y] <= 1;
						for (i = 1; i < 3; i = i+1)
						begin
							if ((x + i) < 10) begin
								o_updatedBombMap_0[(x+i)*10+y] <= 1;
								o_updatedBombMap_1[(x+i)*10+y] <= 1;
							end
							if ((x - i) >= 0) begin
								o_updatedBombMap_0[(x-i)*10+y] <= 1;
								o_updatedBombMap_1[(x-i)*10+y] <= 1;
							end
							if ((y + i) < 10) begin
								o_updatedBombMap_0[x*10+y+i] <= 1;
								o_updatedBombMap_1[x*10+y+i] <= 1;
							end
							if ((y - i) >= 0) begin
								o_updatedBombMap_0[x*10+y-i] <= 1;
								o_updatedBombMap_1[x*10+y-i] <= 1;
							end
						end
					end
               else if (i_curBombMap_1[10 * x + y] == 0 && i_curBombMap_0[10 * x + y] == 1) begin
                  //o_updatedBombMap_1[10 * x + y] <= o_updatedBombMap_0[10 * x + y] ^ o_updatedBombMap_1[10 * x + y];
                  //o_updatedBombMap_0[10 * x + y] <= ~o_updatedBombMap_0[10 * x + y];
						o_updatedBombMap_1[10 * x + y] <= 1;
                  o_updatedBombMap_0[10 * x + y] <= 0;
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
            if (bombA_v == 1 && game_state == 0) begin
                o_updatedBombMap_1[10 * bombA_x + bombA_y] <= 0;
                o_updatedBombMap_0[10 * bombA_x + bombA_y] <= 1;
            end
            if (bombB_v == 1 && game_state == 0) begin
                o_updatedBombMap_1[10 * bombB_x + bombB_y] <= 0;
                o_updatedBombMap_0[10 * bombB_x + bombB_y] <= 1;
            end
        end
    end

endmodule