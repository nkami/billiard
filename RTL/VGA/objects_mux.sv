// (c) Technion IIT, Department of Electrical Engineering 2019 
// Written By Natan Kaminsky and Nimrod Barazani June 2019
//based on vga lab format

module	objects_mux	(	
					input		logic	clk,
					input		logic	resetN,
					input		logic game_state,
					// two set of inputs per unit - RGB + drawing request
					
					//all RGBs (balls and stick)
					input		logic	[10:0][7:0] RGB_ball, 
					input		logic	[7:0] RGB_stick,
					
					
					//all drawing requests (balls and stick)
					input logic 	[10:0] ball_request,
					input logic stick_request,
					 
					
					// background + strikes left
					input		logic	[7:0] RGB_backGround, 
					input		logic	[7:0] RGB_strikes_units,
					input		logic	[7:0] RGB_strikes_tens,
					input 	logic	strikes_units_request,
					input		logic	strikes_tens_request,

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (game_state == 1'b1) begin
			if (stick_request == 1'b1 )
				tmpRGB <= RGB_stick;
			else if (ball_request[0] == 1'b1 )
				tmpRGB <= RGB_ball[0];
			else if (ball_request[1] == 1'b1 )
				tmpRGB <= RGB_ball[1];
			else if (ball_request[2] == 1'b1 )
				tmpRGB <= RGB_ball[2];
			else if (ball_request[3] == 1'b1 )
				tmpRGB <= RGB_ball[3];
			else if (ball_request[4] == 1'b1 )
				tmpRGB <= RGB_ball[4];
			else if (ball_request[5] == 1'b1 )
				tmpRGB <= RGB_ball[5];
			else if (ball_request[6] == 1'b1 )
				tmpRGB <= RGB_ball[6];
			else if (ball_request[7] == 1'b1 )
				tmpRGB <= RGB_ball[7];
			else if (ball_request[8] == 1'b1 )
				tmpRGB <= RGB_ball[8];
			else if (ball_request[9] == 1'b1 )
				tmpRGB <= RGB_ball[9];
			else if (ball_request[10] == 1'b1 )
				tmpRGB <= RGB_ball[10];
			else if (strikes_tens_request == 1'b1)
				tmpRGB <= RGB_strikes_tens;
			else if (strikes_units_request == 1'b1)
				tmpRGB <= RGB_strikes_units;
			else
				tmpRGB <= RGB_backGround;
		end else begin
				tmpRGB <= RGB_backGround;
		end
		
	end
end

endmodule


