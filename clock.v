// Takes in the master clock, reset signal
// Outputs the new clock
// VGA clock 25MHz, 7-segment display clock 500 Hz
module clockDivider(
    // Inputs
    clk, rst,
    // Outputs
    VGAClock, segClock, oneHzClock, charClock
);

    input clk;
    input rst;
    output VGAClock;
    output segClock;
    output oneHzClock;
	 output charClock;

    reg [31:0] VGACounter = 0;
	 reg [31:0] segCounter = 0;
	 reg [31:0] oneHzCounter = 0;
	 reg [31:0] charCounter = 0;
    reg VGATemp = 0;
	 reg segTemp = 0;
	 reg oneHzTemp = 0;
	 reg charTemp = 0;
	 
	 localparam test = 0;
    localparam VGA_MOD = 2; // 25MHz
    localparam SEG_MOD = 100000/(1+test*999); // 500Hz
    localparam ONE_HZ_MOD = 100000000/(2+test*1998); // 1Hz
	 localparam CHAR_MOD = 10000000/(8+test*7992); // 4Hz

    always @ (posedge clk) begin
        if (VGACounter == VGA_MOD-1) begin
            VGACounter <= 0;
            VGATemp <= ~VGAClock;
        end
        else begin
            VGACounter <= VGACounter + 1;
            VGATemp <= VGAClock;
        end
    end

    always @ (posedge clk) begin
        if (segCounter == SEG_MOD-1) begin
            segCounter <= 0;
            segTemp <= ~segClock;
        end
        else begin
            segCounter <= segCounter + 1;
            segTemp <= segClock;
        end
    end

    always @ (posedge clk) begin
        if (oneHzCounter == ONE_HZ_MOD-1) begin
            oneHzCounter <= 0;
            oneHzTemp <= ~oneHzTemp;
        end
        else begin
            oneHzCounter <= oneHzCounter + 1;
            oneHzTemp <= oneHzClock;
        end
    end
	 
	 always @ (posedge clk) begin
        if (charCounter == CHAR_MOD-1) begin
            charCounter <= 0;
            charTemp <= ~charClock;
        end
        else begin
            charCounter <= charCounter + 1;
            charTemp <= charClock;
        end
    end

    assign segClock = segTemp;
    assign VGAClock = VGATemp;
    assign oneHzClock = oneHzTemp;
	 assign charClock = charTemp;

endmodule