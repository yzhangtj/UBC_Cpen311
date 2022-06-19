module flash_fsm (CLK_50M, clock_22kHz,  play,  readdatavalid, addr_out, 
				data_in,new_addr,  flash_m_read,  data_out,finished);
		
		input CLK_50M, clock_22kHz,  play,  readdatavalid, addr_out;	
		input [31:0] data_in;
		
		output  flash_m_read;
		output logic [7:0] data_out;
		output logic new_addr,finished;

		logic  [6:0] state;

		logic flag1 = 1'b0;
		logic flag2 = 0;
		logic flag3 = 0;

		assign flash_m_read 	= state [0];
		assign new_addr 	= state[1];		
		assign finished = state[2];
		
		parameter idle      	 	= 7'b0000_000;
		parameter Frequency_Check_1   = 7'b0001_000;
		parameter Frequency_Check_2  = 7'b0010_000;
		parameter Data_Byte 	   = 7'b0011_000;
		parameter wait_state 		= 7'b0100_001;
		parameter addr_on    		= 7'b0101_010;
		parameter First_Data  		= 7'b0110_100;
		parameter Fourth_Data   	= 7'b0111_100;
		parameter Second_Data   	= 7'b1000_100;
		parameter Third_Data  	    = 7'b1001_100;
	
		
		always_ff @ (posedge CLK_50M ) begin
		
				
			case(state)
				idle: begin					  		
					if( play) state <= Frequency_Check_1;
					else state <= idle;
					end			
				Frequency_Check_1: if(!clock_22kHz) state <= Frequency_Check_2;
					         else state <= Frequency_Check_1;
							 
			    Frequency_Check_2: if(clock_22kHz) state <= Data_Byte; // waiting for the sychronized frequency
							 	 else state <= Frequency_Check_2;
					
				Data_Byte: begin 
						    if(!flag1) begin //flag 1=1 indicates that [7:0] has been read
							state<=wait_state; end
					            
							else if(!flag2&!flag3)begin
                                    state<=Second_Data;
								end

							else if(flag2&!flag3) begin //flag 2=1 indicates that [15:8] has been read
									state<=Third_Data;
								    end

							else if(flag2&flag3)begin //flag 3=1 indicates that [23:16] has been read
									state<=addr_on; 
								end

							else begin state<=idle;
									flag2<=0;flag3<=0; end
                     end
											 
				wait_state: if(play & readdatavalid) state <= First_Data;
							else state <= wait_state;
				addr_on:   begin 
					        if(addr_out) 
					        state<= Fourth_Data;
                            else 
					        state<=addr_on; end
					
				First_Data:begin					
					    data_out=data_in[7:0];
						flag1=~flag1;
						state <= idle; end		
		
				Second_Data: begin
					    flag2<=1;      
					    data_out=data_in[15:8];						      
						state <= idle; end

				Third_Data: begin
					     flag3<=1;     
						data_out=data_in[23:16];						   
						state <= idle; end			

				Fourth_Data: begin 				
					    data_out=data_in[31:24];
						flag1=~flag1;
						flag2=0;flag3=0;
					    state <= idle; end

					default: state <= idle;
					endcase
					
		end
		
endmodule