  
module LFSR (
    input clock,
    input reset,
    output [3:0] rnd 
    );
 
wire feedback = random[12] ^ random[3] ^ random[2] ^ random[0]; 
 
reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts
reg [3:0] final_num;
reg temp;
 
always @ (posedge clock)
begin
 if (reset)
 begin
  random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
 end
 
 random_next <= random; //default state stays the same
 count_next <= count;
   
  random_next <= {random[11:0], feedback}; //shift left the xor'd every posedge clock
  count_next <= count + 1;
 
 if (count == 13)
 begin
  count <= 0;
  random_done <= random; //assign the random number to output after 13 shifts
 end
 
 temp <= random_done % 5;

  case(temp)
  0: begin final_num <= 2; end
  1: begin final_num <= 4; end
  2: begin final_num <= 8; end
  3: begin final_num <= 6; end
  4: begin final_num <= 5; end
  default: begin final_num <= 5; end
  endcase
end
 
assign rnd = final_num;
 
endmodule