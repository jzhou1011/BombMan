module debouncing(
	//input
	btn,
	the_clk,
	//output
	btn_crt
    );
	
	input btn;
	input the_clk;
	output btn_crt;
		
	reg temp = 0;
	
	reg [15:0] counter;
	
	//use fast clk to check the button state and recog it only when time is enough
	
	always @ (posedge the_clk)
	begin
		if(btn == 0)
		begin
			counter <= 0;
			temp <= 0;
		end
		else
		begin
			counter <= counter + 1;
			if(counter == 16'b1111111111111111) // only when counter is max we recog this button
			begin
				temp <= 1;
				counter <= counter + 1;
			end
		end
	end
	
	assign btn_crt = temp;

endmodule