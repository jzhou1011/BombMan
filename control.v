module chara_control(
	input Up,
	input Down,
	input Left,
	input Right,
	
	input [3:0] playerB,
	
	input Center,
	
	input [1:0] onedim_Arena [0:99],
	input [1:0] onedim_Bomb [0:99],
	
	input clk,
	input bomb_clk,
	
	//output
	output [1:0] crt_Arena [0:99],
	output [1:0] crt_Bomb [0:99],

	output [3:0] playerAx,
	output [3:0] playerAy,
	output [3:0] playerBx,
	output [3:0] playerBy
    );
	
	reg [1:0] Arena [0:9][0:9],
	reg [1:0] Bomb [0:9][0:9],
	
	genvar flatten_i, flatten_j;
	
	for (flatten_i = 0; flatten_i < 10; flatten_i = flatten_i+1)
	begin
		for (flatten_j = 0; flatten_j < 10; flatten_j = flatten_j+1)
		begin
			assign Arena[i][j] = onedim_Arena[i*10+j]
			assign Bomb[i][j] = onedim_Bomb[i*10+j]
		end
	end

	reg [3:0] crt_position_1 [0:1];
	reg [3:0] crt_position_2 [0:1];
	reg [3:0] temp [0:1];
	
	reg [1:0] temp_Arena [0:9][0:9];
	reg [1:0] temp_Bomb [0:9][0:9];

	reg [0:3] playerAx;
	reg [0:3] playerAy;
	reg [0:3] playerBx;
	reg [0:3] playerBy;
	
	integer i,j;
	
	always @ (posedge clk) begin
		for (i = 0; i < 10; i = i+1)
		begin
			for (j = 0; j < 10; j = j+1) 
			begin
				temp_Arena[i][j] <= Arena[i][j];
				temp_Bomb[i][j] <= Bomb[i][j];
				
				if (Arena[i][j] == 2) begin
					crt_position_1[0] <= i;
					crt_position_1[1] <= j;
					playerAx <= i;
					playerAy <= j;
				end
				else if (Arena[i][j] == 3) begin
					crt_position_2[0] <= i;
					crt_position_2[1] <= j;
					playerBx <= i;
					playerBy <= j;
				end
			end
		end
	end

	always @ (posedge clk) begin
		if (Up) begin
			temp[0] <= crt_position_1[0] - 1;
			temp[1] <= crt_position_1[1];
			if (temp[0] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Down) begin
			temp[0] <= crt_position_1[0] + 1;
			temp[1] <= crt_position_1[1];
			if (temp[0] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Left) begin
			temp[0] <= crt_position_1[0];
			temp[1] <= crt_position_1[1] - 1;
			if (temp[1] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Right) begin
			temp[0] <= crt_position_1[0];
			temp[1] <= crt_position_1[1] + 1;
			if (temp[1] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
			
	end

	always @ (posedge bomb_clk) begin
		if (Center) begin
			if (temp_Bomb[crt_position_1[0]][crt_position_1[1]] == 0) 
			begin
				temp_Bomb[crt_position_1[0]][crt_position_1[1]] <= 3;
			end
		end

		if (playerB == 4'b0101) begin // 5
			if (temp_Bomb[crt_position_2[0]][crt_position_2[1]] == 0) 
			begin
				temp_Bomb[crt_position_2[0]][crt_position_2[1]] <= 3;
			end
		end
	end
	
	always @ (posedge clk) begin
		if (playerB == 4'b0010) begin // 2
			temp[0] <= crt_position_2[0] - 1;
			temp[1] <= crt_position_2[1];
			if (temp[0] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b1000) begin // 8
			temp[0] <= crt_position_2[0] + 1;
			temp[1] <= crt_position_2[1];
			if (temp[0] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b0100) begin // 4
			temp[0] <= crt_position_2[0];
			temp[1] <= crt_position_2[1] - 1;
			if (temp[1] >= 0 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b0110) begin // 6
			temp[0] <= crt_position_2[0];
			temp[1] <= crt_position_2[1] + 1;
			if (temp[1] < 10 && Arena[temp[0]][temp[1]] == 0 && Bomb[temp[0]][temp[1]] == 0) 
			begin
				temp_Arena[temp[0]][temp[1]] <= 2;
				temp_Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
			
	end
	
	
	genvar m, n;
	for (m = 0; m < 10; m = m+1)
	begin
		for (n = 0; n < 10; n = n+1) 
		begin
			assign crt_Arena[m*10 + n] = temp_Arena[m][n];
			assign crt_Bomb[m*10 + n] = temp_Bomb[m][n];
		end
	end
	
endmodule
