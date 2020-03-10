module initialize(
	arena_0,
    rst
);

	output reg [99:0] arena_0;

    input rst;
    // output reg [1:0] healthB;
	reg [3:0] i,j;

    always @ (posedge rst)
    begin
        // initialize arena and bombs
        for (i = 0; i < 10; i = i+1) begin
	    	for (j = 0; j < 10; j = j+1) begin
                if (i == 0 || i == 9 || j == 0 || j == 9) begin
                    arena_0[i*10+j] <= 1;
                end
                else begin
                    arena_0[i*10+j] <= 0;
                end
	    	end
        end
 
        // initialize players and blcks
        arena_0[13] <= 1; // blocks
        arena_0[17] <= 1;
        arena_0[24] <= 1;
        arena_0[32] <= 1;
        arena_0[34] <= 1;
        arena_0[38] <= 1;
        arena_0[46] <= 1;
        arena_0[51] <= 1;
        arena_0[56] <= 1;
        arena_0[57] <= 1;
        arena_0[62] <= 1;
        arena_0[63] <= 1;
        arena_0[76] <= 1;
        arena_0[84] <= 1;
    end  

endmodule
