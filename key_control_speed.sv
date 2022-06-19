module key_control_speed(clk_22khz,clk_44khz,clk_11khz,out_clk,speed_up_key,speed_down_key,speed_return_key,CLK_50M);
input clk_22khz,clk_44khz,clk_11khz,CLK_50M;
output reg out_clk;
reg  [2:0] state;
input  speed_up_key,speed_down_key,speed_return_key;
parameter speed_22khz =3'b000 ;
parameter speed_44khz =3'b001;
parameter  speed_11khz =3'b010 ;


always_ff @ (posedge CLK_50M ) 
begin
        if (speed_return_key)
             state<=speed_22khz;
           else
         begin
             case(state)
             speed_22khz:
            begin
            out_clk=clk_22khz;
            if(speed_down_key)
                 state<=speed_11khz; 
                else if(speed_up_key) 
                  state<=speed_44khz;
            end            
            speed_11khz:
            begin
                out_clk=clk_11khz;
                if(speed_up_key)
                state<=speed_22khz;
            end
            speed_44khz:
            begin
                 out_clk=clk_44khz;
                 if(speed_down_key)
                 state<=speed_22khz;
            end
            default:state<=speed_22khz;
             endcase
             end
 end
endmodule
             