module uart_top (/*AUTOARG*/
   // Outputs
   o_tx, o_tx_busy, o_rx_data, o_rx_valid,
   // Inputs
   i_rx, i_tx_data, i_tx_stb, clk, rst
   );

   parameter seq_dp_width = 100;
   output                   o_tx; // asynchronous UART TX
   input                    i_rx; // asynchronous UART RX
   
   output                   o_tx_busy;
   output [7:0]             o_rx_data;
   output                   o_rx_valid;
   
   input [seq_dp_width-1:0] i_tx_data;
   
   input                    clk;
   input                    rst;

   
   parameter uart_num_nib = seq_dp_width; // number of nibbles to send
   parameter stIdle = 0;
   parameter st10 = 11;
   parameter st20 = 22;
   parameter st30 = 33;
   parameter st40 = 44;
   parameter st50 = 55;
   parameter st60 = 66;
   parameter st70 = 77;
   parameter st80 = 88;
   parameter st90 = 99;
   parameter stNL   = uart_num_nib+10;
   parameter stCR   = uart_num_nib+11;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 tfifo_empty;            // From tfifo_ of uart_fifo.v
   wire                 tfifo_full;             // From tfifo_ of uart_fifo.v
   wire [7:0]           tfifo_out;              // From tfifo_ of uart_fifo.v
   // End of automatics

   reg [7:0]            tfifo_in;
   wire                 tx_active;
   wire                 tfifo_rd;
   reg                  tfifo_rd_z;
   reg [seq_dp_width-1:0]  tx_data;
   reg [3:0]               state;

   assign o_tx_busy = (state!=stIdle);
   
   always @ (posedge clk)
     if (rst)
       state <= stIdle;
     else
       case (state)
         stIdle:
            if (i_tx_stb) begin
                state   <= 1;
			    tx_data <= i_tx_data;
            end
         stCR:
           if (~tfifo_full) state <= stIdle;
         st10:
            state <= state + 1;
         st20:
            state <= state + 1;
         st30:
            state <= state + 1;
         st40:
            state <= state + 1;
         st50:
            state <= state + 1;
         st60:
            state <= state + 1;
         st70:
            state <= state + 1;
         st80:
            state <= state + 1;
         st90:
            state <= state + 1;
         default:
           if (~tfifo_full)
             begin
                state   <= state + 1;
				tx_data <= {tx_data,1'b0};
             end
       endcase // case (state)

   function [7:0] bombTranslate;
      input [3:0] din;
      begin
         case (din)
           0: bombTranslate = "0";  //nothing
           1: bombTranslate = "1";  //block
         endcase // case (char)
      end
   endfunction // bombTranslate

   always @*
     case (state)
       stNL:    tfifo_in = "\n";
       stCR:    tfifo_in = "\r";
       st10:    tfifo_in = "\n";
       st20:    tfifo_in = "\n";
       st30:    tfifo_in = "\n";
       st40:    tfifo_in = "\n";
       st50:    tfifo_in = "\n";
       st60:    tfifo_in = "\n";
       st70:    tfifo_in = "\n";
       st80:    tfifo_in = "\n";
       st90:    tfifo_in = "\n";
       default: tfifo_in = bombTranslate(tx_data[seq_dp_width-1:seq_dp_width-2]);
     endcase // case (state)
   
   assign tfifo_rd = ~tfifo_empty & ~tx_active & ~tfifo_rd_z;

   assign tfifo_wr = ~tfifo_full & (state!=stIdle);
   
   uart_fifo tfifo_ (// Outputs
                     .fifo_cnt          (),
                     .fifo_out          (tfifo_out[7:0]),
                     .fifo_full         (tfifo_full),
                     .fifo_empty        (tfifo_empty),
                     // Inputs
                     .fifo_in           (tfifo_in[7:0]),
                     .fifo_rd           (tfifo_rd),
                     .fifo_wr           (tfifo_wr),
                     /*AUTOINST*/
                     // Inputs
                     .clk               (clk),
                     .rst               (rst));

   always @ (posedge clk)
     if (rst)
       tfifo_rd_z <= 1'b0;
     else
       tfifo_rd_z <= tfifo_rd;

   uart uart_ (// Outputs
               .received                (o_rx_valid),
               .rx_byte                 (o_rx_data[7:0]),
               .is_receiving            (),
               .is_transmitting         (tx_active),
               .recv_error              (),
               .tx                      (o_tx),
               // Inputs
               .rx                      (i_rx),
               .transmit                (tfifo_rd_z),
               .tx_byte                 (tfifo_out[7:0]),
               /*AUTOINST*/
               // Inputs
               .clk                     (clk),
               .rst                     (rst));
   
endmodule // uart_top
// Local Variables:
// verilog-library-flags:("-y ../../osdvu/")
// End:
