module clock_divider (CLK_50M, reset, count_to, out);
		input CLK_50M;
		input reset;
		input [31:0] count_to;
		output reg [31:0] out;
		reg [31:0] count;
		
		always@(posedge CLK_50M) begin
			if(reset) begin
				count = 0;
				out = 0;
			end
			
			else begin
				if(count<count_to) begin
					count=count+1;
				end
				else begin
					 out = ~out;
					 count=0;
					 end
				end
		end
	endmodule