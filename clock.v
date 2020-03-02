// Takes in the master clock, reset signal
// Outputs the new clock
// VGA clock 25MHz, 7-segment display clock 500 Hz
module clockDivider(
    // Inputs
    clk, rst,
    // Outputs
    VGAClock, segClock, oneHzClock
);

    input clk;
    input rst;
    output VGAClock;
    output segClock;
    output oneHzClock;

    reg [31:0] VGACounter, segCounter, oneHzCounter;
    reg VGATemp, segTemp, oneHzTemp;

    localparam VGA_MOD = 2; // 25MHz
    localparam SEG_MOD = 100000; // 500Hz
    localparam ONE_HZ_MOD = 100000000/2; // 1Hz

    always @ (posedge clk or posedge rst) begin
        if (rst == 1) begin
            VGACounter <= 0;
            VGATemp <= 0;
        end
        else if (VGACounter == VGA_MOD-1) begin
            VGACounter <= 0;
            VGATemp <= ~VGAClock;
        end
        else begin
            VGACounter <= VGACounter + 1;
            VGATemp <= VGAClock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1) begin
            segCounter <= 0;
            segTemp <= 0;
        end
        else if (segCounter == SEG_MOD-1) begin
            segCounter <= 0;
            segTemp <= ~segClock;
        end
        else begin
            segCounter <= segCounter + 1;
            segTemp <= segClock;
        end
    end

    always @ (posedge clk or posedge rst) begin
        if (rst == 1) begin
            oneHzCounter <= 0;
            oneHzTemp <= 0;
        end
        else if (oneHzCounter == ONE_HZ_MOD-1) begin
            oneHzCounter <= 0;
            oneHzTemp <= ~oneHzTemp;
        end
        else begin
            oneHzCounter <= oneHzCounter + 1;
            oneHzTemp <= oneHzClock;
        end
    end

    assign segClock = segTemp;
    assign VGAClock = VGATemp;
    assign oneHzClock = oneHzTemp;

endmodule