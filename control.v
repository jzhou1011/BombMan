module chara_control(
	input Up,
	input Down,
	input Left,
	input Right,
	
	input [3:0] playerB,
	
	input Center,
	
	input [1:0] Arena [0:9][0:9],
	input [1:0] Bomb [0:9][0:9],
	
	input clk,
	input bomb_clk,
	
	//output
	output [1:0] crt_Arena [0:9][0:9],
	output [1:0] crt_Bomb [0:9][0:9],

	output [3:0] playerAx,
	output [3:0] playerAy,
	output [3:0] playerBx,
	output [3:0] playerBy
    );

	reg [3:0] crt_position_1 [0:1]= 0;
	reg [3:0] crt_position_2 [0:1] = 0;
	reg [3:0] temp [0:1] = 0;
	
	reg [1:0] temp_Arena [0:9][0:9];
	reg [1:0] temp_Bomb [0:9][0:9];

	reg [0:3] playerAx;
	reg [0:3] playerAy;
	reg [0:3] playerBx;
	reg [0:3] playerBy;
	
	reg [4:0] i,j;
	
	always @ (posedge clk) begin
		for (i = 0; i < 10; i += 1)
		begin
			for (j = 0; j < 10; j += 1) 
			begin
				temp_Arena[i][j] = Arena[i][j];
				temp_Bomb[i][j] = Bomb[i][j];
				
				if Arena[i][j] == 2 begin
					crt_position_1[0] = i;
					crt_position_1[1] = j;
					playerAx = i;
					playerAy = j;
				end
				else if Arena[i][j] == 3 begin
					crt_position_2[0] = i;
					crt_position_2[1] = j;
					playerBx = i;
					playerBy = j;
				end
			end
		end
	end

	always @ (posedge clk) begin
		if (Up) begin
			temp[0] = crt_position_1[0] - 1;
			temp[1] = crt_position_1[1];
			if (temp[0] >= 0 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Down) begin
			temp[0] = crt_position_1[0] + 1;
			temp[1] = crt_position_1[1];
			if (temp[0] <= 9 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Left) begin
			temp[0] = crt_position_1[0];
			temp[1] = crt_position_1[1] - 1;
			if (temp[1] >= 0 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
		
		else if (Right) begin
			temp[0] = crt_position_1[0];
			temp[1] = crt_position_1[1] + 1;
			if (temp[1] <= 9 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_1[0]][crt_position_1[1]] <= 0;
				playerAx <= temp[0];
				playerAy <= temp[1];
			end
		end
			
	end

	always @ (posedge bomb_clk) begin
		if (Center) begin
			if (Bomb[crt_position_1[0]][crt_position_1[1]] == 0) 
			begin
				Bomb[crt_position_1[0]][crt_position_1[1]] = 3;
			end

		if (playerB == 4'b0101) begin // 5
			if (Bomb[crt_position_2[0]][crt_position_2[1]] == 0) 
			begin
				Bomb[crt_position_2[0]][crt_position_2[1]] = 3;
			end
	end
	
	always @ (posedge clk) begin
		if (playerB == 4'b0010) begin // 2
			temp[0] = crt_position_2[0] - 1;
			temp[1] = crt_position_2[1];
			if (temp[0] >= 0 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b1000) begin // 8
			temp[0] = crt_position_2[0] + 1;
			temp[1] = crt_position_2[1];
			if (temp[0] <= 9 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b0100) begin // 4
			temp[0] = crt_position_2[0];
			temp[1] = crt_position_2[1] - 1;
			if (temp[1] >= 0 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
		
		if (playerB == 4'b0110) begin // 6
			temp[0] = crt_position_2[0];
			temp[1] = crt_position_2[1] + 1;
			if (temp[1] <= 9 and Arena[temp[0]][temp[1]] == 0 and Bomb[temp[0]][temp[1]] == 0) 
			begin
				Arena[temp[0]][temp[1]] <= 2;
				Arena[crt_position_2[0]][crt_position_2[1]] <= 0;
				playerBx <= temp[0];
				playerBy <= temp[1];
			end
		end
			
	end
	
	for (i = 0; i < 10; i += 1)
	begin
		for (j = 0; j < 10; j += 1) 
		begin
			crt_Arena[i][j] = Arena[i][j];
			crt_Bomb[i][j] = Bomb[i][j];
		end
	end
	
endmodule
