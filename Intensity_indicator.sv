module Averaging_leds (clk, interrupt_flag, out_data, LED);

     input clk, interrupt_flag;
     input [7:0] out_data;
     output logic [7:0] LED;

     logic [15:0] accumulator = 0;
     logic [8:0]  count = 0;
     logic [7:0]  average;
     logic [7:0]  data_preserved;

     logic [6:0] state;
     logic  addition, POS_or_NEG, finished;

     assign addition             = state[0];
     assign POS_or_NEG = state[1];
     assign finished             = state[2];

     parameter IDLE                          =7'b0000_000;
     parameter determine_POS_NEG   =7'b1001_000;
     parameter POS                      =7'b0010_000;
     parameter NEG                      =7'b1011_010;
     parameter SUM                     =7'B0100_001;
     parameter COUNTING                      =7'B1101_000;
     parameter DONE                        =7'B0111_100;


     always_ff @ (posedge clk) begin
         case (state)
         IDLE:   if(interrupt_flag) 
                state <=determine_POS_NEG;
                else state <= IDLE;
        
         determine_POS_NEG:
                if (out_data[7]) 
                state <= NEG;
                else state <= POS;

         POS: begin 
                data_preserved <= out_data;
                state <= SUM; end
        
         NEG: begin
                data_preserved <= ~out_data;
                state <= SUM; end

         SUM:  if (count == 9'd255) 
                    state <= DONE;
                    else state <= COUNTING;

         COUNTING: begin
                accumulator <= accumulator + data_preserved; 
					 count <=count + 1'b1;
                state <= IDLE; end
        
         DONE: begin
                average <= accumulator[15:8]; 
					 accumulator <= 0; 
					 count <= 0;
                state <= IDLE; end 
        
         default: state <=IDLE;

         endcase
     end

     always @(*) begin
        if      (average[7]) LED <= 8'b1111_1111;
        else if (average[6]) LED <= 8'b1111_1110;
        else if (average[5]) LED <= 8'b1111_1100;  
        else if (average[4]) LED <= 8'b1111_1000;
        else if (average[3]) LED <= 8'b1111_0000;
        else if (average[2]) LED <= 8'b1110_0000;
        else if (average[1]) LED <= 8'b1100_0000;
        else if (average[0]) LED <= 8'b1000_0000;
        else                 LED <= 8'b0000_0000;
     end

endmodule  