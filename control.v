module chara_control(
	input Up,
	input Down,
	input Left,
	input Right,
	
	input [3:0] playerB,
	
	input Center,
	
	input [99:0] Arena_bit0,
	input [99:0] Arena_bit1,
	input [99:0] Bomb_bit0,
	input [99:0] Bomb_bit1,
	
	input clk,
	input bomb_clk,
	
	//output
	output [99:0] crt_Arena_bit0,
	output [99:0] crt_Arena_bit1,
	output [99:0] crt_Bomb_bit0,
	output [99:0] crt_Bomb_bit1,


	output [3:0] playerAx,
	output [3:0] playerAy,
	output [3:0] playerBx,
	output [3:0] playerBy
    );
	
	wire [1:0] onedim_Arena [0:99];
	wire [1:0] onedim_Bomb [0:99];
	
		
	genvar flatten_i, flatten_j;
		
	for (flatten_i = 0; flatten_i < 10; flatten_i = flatten_i+1)
	begin
		for (flatten_j = 0; flatten_j < 10; flatten_j = flatten_j+1)
		begin
			assign onedim_Arena[flatten_i*10+flatten_j] = {Arena_bit1[flatten_i*10+flatten_j], Arena_bit0[flatten_i*10+flatten_j]};
			assign onedim_Bomb[flatten_i*10+flatten_j] = {Bomb_bit1[flatten_i*10+flatten_j], Bomb_bit0[flatten_i*10+flatten_j]};
		end
	end	
	
		
	wire [1:0] Arena [0:9][0:9];
	wire [1:0] Bomb [0:9][0:9];
	
		
	for (flatten_i = 0; flatten_i < 10; flatten_i = flatten_i+1)
	begin
		for (flatten_j = 0; flatten_j < 10; flatten_j = flatten_j+1)
		begin
			assign Arena[flatten_i][flatten_j] = onedim_Arena[flatten_i*10+flatten_j];
			assign Bomb[flatten_i][flatten_j] = onedim_Bomb[flatten_i*10+flatten_j];
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

	always @ (posedge clk or posedge bomb_clk) begin
	
		if (bomb_clk) 
		begin
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
	
		else 
		begin 
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
			
	end
	
	genvar m, n;
	for (m = 0; m < 10; m = m+1)
	begin
		for (n = 0; n < 10; n = n+1) 
		begin
			assign crt_Arena_bit0[m*10 + n] = temp_Arena[m][n][0];
			assign crt_Arena_bit1[m*10 + n] = temp_Arena[m][n][1];
			assign crt_Bomb_bit0[m*10 + n] = temp_Bomb[m][n][0];
			assign crt_Bomb_bit1[m*10 + n] = temp_Bomb[m][n][1];
		end
	end
	
	
	
endmodule
