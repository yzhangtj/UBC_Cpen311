`define default_speed 32'h132
module speed_controller (input clk, speed_up, speed_down, reset, output logic [31:0] speed_out);
	logic [31:0] speed = `default_speed;
	
	always_ff @ (posedge clk) begin
		case ({speed_up, speed_down, reset})
			3'b100: speed <= speed+32'h2;
			3'b010: speed <= speed-32'h2;
			3'b001: speed <= `default_speed;
			default: speed<=speed;
		endcase
		
	end
	
	assign speed_out = speed;
endmodule
