
module Machine(
input clk, rst, inc, dec, inc2, //these are implemented with on/off slide switches
output reg decf,incf,zf,
output [15:0]dataout
    );
parameter S_idle = 6'b000_001, 
          S_inc = 6'b000_010, 
			 S_inc2 = 6'b000_100, 
			 S_dec=6'b001_000,
			 Error=6'b010_000,
			 Reset=6'b100_000;
reg [15:0] A;
reg [5:0] State;
assign dataout = A;

always @ (posedge clk) begin
	if(rst) begin
		State <= Reset;
		A<=16'd0;
	end
	else begin
		case (State)
			
			Error: begin
				State <= Reset;
								
			end
			
			Reset: begin
				State <= S_idle;
				zf<=1'b1; //reset asserts a zero flag
			end
			//Idle state does nothing but redirects to each mode
			S_idle: begin
						if(inc == 1'b1) begin State <= S_inc; zf<=1'b0; end else 
						if(dec == 1'b1) begin State <= S_dec; zf<=1'b0; end else			
						if(inc2 == 1'b1) begin State <= S_inc2; zf<=1'b0; end
						else State <= S_idle;
					end
			//S_inc is the state were increment by 1 is happening and assertion of an increment flag
			S_inc:begin 
			         if (inc) begin  A<=A+1'b1; State <= S_inc; incf<=1'b1; end
						else begin State <= S_idle; incf<=1'b0; end
					end
			//S_dec is the state were decrement by 1 is happening and assertion of a decrement flag		
			S_dec:begin 
			         if (dec) begin  A<=A-1'b1; State <= S_dec; decf<=1'b1; end
						else begin State <= S_idle; decf<=1'b0; end
					end
			//S_inc2 is the state were increment by 2 is happening
			S_inc2:begin 
			         if (inc2) begin  A<=A+2'b10; State <= S_inc2; incf<=1'b1; end
						else begin State <= S_idle; incf<=1'b0; end
					end
			default: begin State <= Error; end 
endcase
end
end

endmodule
