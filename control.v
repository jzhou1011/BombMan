module chara_control(
	input Up,
	input Down,
	input Left,
	input Right,
	
	input rst,
	
	input [3:0] playerB,
	
	input Center,
	
	input [99:0] onedim_Arena,
	
	input clk,
	
	//output
	output [99:0] crt_Arena_bit0,
 

	input [3:0] playerAx,
	input [3:0] playerAy,
	input [3:0] playerBx,
	input [3:0] playerBy,

	output reg [3:0] o_playerAx,
	output reg [3:0] o_playerAy,
	output reg [3:0] o_playerBx,
	output reg [3:0] o_playerBy,

	output reg [3:0] bombA_x,
	output reg [3:0] bombA_y,
	output reg [3:0] bombA_v,
	output reg [3:0] bombB_x,
	output reg [3:0] bombB_y,
	output reg [3:0] bombB_v,

	input [99:0] Bomb_bit0,
	input [99:0] Bomb_bit1

    );
	
	wire [1:0] onedim_Bomb [0:99];
	
		
	genvar flatten_i, flatten_j;
		
	for (flatten_i = 0; flatten_i < 10; flatten_i = flatten_i+1)
	begin
		for (flatten_j = 0; flatten_j < 10; flatten_j = flatten_j+1)
		begin
			assign onedim_Bomb[flatten_i*10+flatten_j] = {Bomb_bit1[flatten_i*10+flatten_j], Bomb_bit0[flatten_i*10+flatten_j]};
		end
	end	
	
		
	wire Arena [0:9][0:9];
	wire [1:0] Bomb [0:9][0:9];
	
		
	for (flatten_i = 0; flatten_i < 10; flatten_i = flatten_i+1)
	begin
		for (flatten_j = 0; flatten_j < 10; flatten_j = flatten_j+1)
		begin
			assign Arena[flatten_i][flatten_j] = onedim_Arena[flatten_i*10+flatten_j];
			assign Bomb[flatten_i][flatten_j] = onedim_Bomb[flatten_i*10+flatten_j];
		end
	end	
	
	reg [3:0] temp [0:1];
	
	reg temp_Arena [0:9][0:9];
	
	integer i,j;

	always @ (posedge clk) begin
	
		if (rst) begin
			o_playerAx <= 1;
			o_playerBx <= 8;
			o_playerAy <= 1;
			o_playerBy <= 8;
		end
			
		else 
		begin
			// place bombs
			if (Center && (Bomb[playerAx][playerAy] == 0))
			begin
				bombA_v <= 1;
				bombA_x <= playerAx;
				bombA_y <= playerAy;
			end
			else
				bombA_v <= 0;
				
			if ((playerB == 4'b0101) && (Bomb[playerBx][playerBy] == 0))
			begin
				bombB_v <= 1;
				bombB_x <= playerBx;
				bombB_y <= playerBy;
			end
			else
				bombB_v <= 0;

			// players
			for (i = 0; i < 10; i = i+1)
			begin
				for (j = 0; j < 10; j = j+1) 
				begin
					temp_Arena[i][j] <= Arena[i][j];
					// temp_Bomb[i][j] <= Bomb[i][j];
				end
			end
		
			if (playerB == 4'b0010) begin // 2
				temp[0] <= playerBx - 1;
				temp[1] <= playerBy;
				if (temp[0] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerBx <= temp[0];
					o_playerBy <= temp[1];
				end
			end
			
			if (playerB == 4'b1000) begin // 8
				temp[0] <= playerBx + 1;
				temp[1] <= playerBy;
				if (temp[0] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerBx <= temp[0];
					o_playerBy <= temp[1];
				end
			end
			
			if (playerB == 4'b0100) begin // 4
				temp[0] <= playerBx;
				temp[1] <= playerBy - 1;
				if (temp[1] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerBx <= temp[0];
					o_playerBy <= temp[1];
				end
			end
			
			if (playerB == 4'b0110) begin // 6
				temp[0] <= playerBx;
				temp[1] <= playerBy + 1;
				if (temp[1] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerBx <= temp[0];
					o_playerBy <= temp[1];
				end
			end
		
		
			if (Up) begin
				temp[0] <= playerAx - 1;
				temp[1] <= playerAy;
				if (temp[0] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerAx <= temp[0];
					o_playerAy <= temp[1];
				end
			end
			
			else if (Down) begin
				temp[0] <= playerAx + 1;
				temp[1] <= playerAy;
				if (temp[0] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerAx <= temp[0];
					o_playerAy <= temp[1];
				end
			end
			
			else if (Left) begin
				temp[0] <= playerAx;
				temp[1] <= playerAy - 1;
				if (temp[1] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerAx <= temp[0];
					o_playerAy <= temp[1];
				end
			end
			
			else if (Right) begin
				temp[0] <= playerAx;
				temp[1] <= playerAy + 1;
				if (temp[1] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
				begin
					o_playerAx <= temp[0];
					o_playerAy <= temp[1];
				end
			end
		end
			
	end
	
	genvar m, n;
	for (m = 0; m < 10; m = m+1)
	begin
		for (n = 0; n < 10; n = n+1) 
		begin
			assign crt_Arena_bit0[m*10 + n] = temp_Arena[m][n];
		end
	end
	
	
	
endmodule
