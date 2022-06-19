module kbd_control (clk,  key, forward, play);

	input logic clk;
	input logic [7:0] key;
	output logic forward, play;
	logic [3:0] state;
	
	parameter character_B =8'h42;
	parameter character_D =8'h44;
	parameter character_E =8'h45;
	parameter character_F =8'h46;
	parameter character_R =8'h52;

	parameter character_lowercase_b= 8'h62;
	parameter character_lowercase_d= 8'h64;
	parameter character_lowercase_e= 8'h65;
	parameter character_lowercase_f= 8'h66;
	parameter character_lowercase_r= 8'h72;
	
	
	 always @(key) begin
       case(key)
		  character_E: begin 
			  play  <= 1;
		      forward<=forward;end

		  character_lowercase_e: begin 
			  play  <= 1;
		      forward<=forward;end

		  character_D: begin 
			  play 	<= 0;
		      forward<=forward;end
		  character_lowercase_d:  begin 
			  play 	<= 0;
		      forward<=forward;end

		  character_F: begin 
			  forward  <= 1;
	          play<=play;	end
		 character_lowercase_f:begin 
			  forward  <= 1;
	          play<=play;	end

		  character_B: begin 
			  forward  <= 0;
	          play<=play;   end
		 character_lowercase_b:begin 
			  forward  <= 0;
	          play<=play;   end

		 endcase
	  end

	

endmodule
		