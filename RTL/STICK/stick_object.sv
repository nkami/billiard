// (c) Technion IIT, Department of Electrical Engineering 2019 
// Written By Natan Kaminsky and Nimrod Barazani June 2019

module stick_object	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input		logic	 [10:0] pixelX,
	input		logic	 [10:0] pixelY,
	input	   logic  [10:0] stickCenterX,
	input	   logic  [10:0] stickCenterY,
	input	   logic  [9:0] angle,
	input	   logic  game_state,
	input	   logic  no_moving_flag,
	input		logic	 startOfFrame,
	input 	logic	 space_pressed,
	output	logic	 [7:0] RGB_out,
	output 	logic drawingRequest,
	output	logic strike
	 
  ) ;

localparam int MAX_ANGLE = 359;
const logic [0:MAX_ANGLE] [15:0] tan_table = {16'h0000,16'h0008,16'h0011,16'h001A,16'h0023,16'h002C,16'h0035,16'h003E,16'h0047,16'h0051,16'h005A,16'h0063,
16'h006C,16'h0076,16'h007F,16'h0089,16'h0092,16'h009C,16'h00A6,16'h00B0,16'h00BA,16'h00C4,16'h00CE,16'h00D9,16'h00E3,16'h00EE,16'h00F9,16'h0104,16'h0110,
16'h011B,16'h0127,16'h0133,16'h013F,16'h014C,16'h0159,16'h0166,16'h0173,16'h0181,16'h0190,16'h019E,16'h01AD,16'h01BD,16'h01CD,16'h01DD,16'h01EE,16'h01FF,
16'h0212,16'h0225,16'h0238,16'h024C,16'h0262,16'h0278,16'h028F,16'h02A7,16'h02C0,16'h02DB,16'h02F7,16'h0314,16'h0333,16'h0354,16'h0376,16'h039B,16'h03C2,
16'h03EC,16'h0419,16'h0449,16'h047D,16'h04B6,16'h04F3,16'h0535,16'h057E,16'h05CE,16'h0627,16'h068A,16'h06F9,16'h0776,16'h0805,16'h08A9,16'h0968,16'h0A4A,
16'h0B57,16'h0CA0,16'h0E3B,16'h1049,16'h1307,16'h16DC,16'h1C99,16'h2629,16'h3945,16'h7294,16'h7800,16'h8D6C,16'hC6BB,16'hD9D7,16'hE367,16'hE924,16'hECF9,
16'hEFB7,16'hF1C5,16'hF360,16'hF4A9,16'hF5B6,16'hF698,16'hF757,16'hF7FB,16'hF88A,16'hF907,16'hF976,16'hF9D9,16'hFA32,16'hFA82,16'hFACB,16'hFB0D,16'hFB4A,
16'hFB83,16'hFBB7,16'hFBE7,16'hFC14,16'hFC3E,16'hFC65,16'hFC8A,16'hFCAC,16'hFCCD,16'hFCEC,16'hFD09,16'hFD25,16'hFD40,16'hFD59,16'hFD71,16'hFD88,16'hFD9E,
16'hFDB4,16'hFDC8,16'hFDDB,16'hFDEE,16'hFE00,16'hFE12,16'hFE23,16'hFE33,16'hFE43,16'hFE53,16'hFE62,16'hFE70,16'hFE7F,16'hFE8D,16'hFE9A,16'hFEA7,16'hFEB4,
16'hFEC1,16'hFECD,16'hFED9,16'hFEE5,16'hFEF0,16'hFEFC,16'hFF07,16'hFF12,16'hFF1D,16'hFF27,16'hFF32,16'hFF3C,16'hFF46,16'hFF50,16'hFF5A,16'hFF64,16'hFF6E,
16'hFF77,16'hFF81,16'hFF8A,16'hFF94,16'hFF9D,16'hFFA6,16'hFFAF,16'hFFB9,16'hFFC2,16'hFFCB,16'hFFD4,16'hFFDD,16'hFFE6,16'hFFEF,16'hFFF8,16'h0000,16'h0008,
16'h0011,16'h001A,16'h0023,16'h002C,16'h0035,16'h003E,16'h0047,16'h0051,16'h005A,16'h0063,16'h006C,16'h0076,16'h007F,16'h0089,16'h0092,16'h009C,16'h00A6,
16'h00B0,16'h00BA,16'h00C4,16'h00CE,16'h00D9,16'h00E3,16'h00EE,16'h00F9,16'h0104,16'h0110,16'h011B,16'h0127,16'h0133,16'h013F,16'h014C,16'h0159,16'h0166,
16'h0173,16'h0181,16'h0190,16'h019E,16'h01AD,16'h01BD,16'h01CD,16'h01DD,16'h01EE,16'h01FF,16'h0212,16'h0225,16'h0238,16'h024C,16'h0262,16'h0278,16'h028F,
16'h02A7,16'h02C0,16'h02DB,16'h02F7,16'h0314,16'h0333,16'h0354,16'h0376,16'h039B,16'h03C2,16'h03EC,16'h0419,16'h0449,16'h047D,16'h04B6,16'h04F3,16'h0535,
16'h057E,16'h05CE,16'h0627,16'h068A,16'h06F9,16'h0776,16'h0805,16'h08A9,16'h0968,16'h0A4A,16'h0B57,16'h0CA0,16'h0E3B,16'h1049,16'h1307,16'h16DC,16'h1C99,
16'h2629,16'h3945,16'h7294,16'h7800,16'h8D6C,16'hC6BB,16'hD9D7,16'hE367,16'hE924,16'hECF9,16'hEFB7,16'hF1C5,16'hF360,16'hF4A9,16'hF5B6,16'hF698,16'hF757,
16'hF7FB,16'hF88A,16'hF907,16'hF976,16'hF9D9,16'hFA32,16'hFA82,16'hFACB,16'hFB0D,16'hFB4A,16'hFB83,16'hFBB7,16'hFBE7,16'hFC14,16'hFC3E,16'hFC65,16'hFC8A,
16'hFCAC,16'hFCCD,16'hFCEC,16'hFD09,16'hFD25,16'hFD40,16'hFD59,16'hFD71,16'hFD88,16'hFD9E,16'hFDB4,16'hFDC8,16'hFDDB,16'hFDEE,16'hFE00,16'hFE12,16'hFE23,
16'hFE33,16'hFE43,16'hFE53,16'hFE62,16'hFE70,16'hFE7F,16'hFE8D,16'hFE9A,16'hFEA7,16'hFEB4,16'hFEC1,16'hFECD,16'hFED9,16'hFEE5,16'hFEF0,16'hFEFC,16'hFF07,
16'hFF12,16'hFF1D,16'hFF27,16'hFF32,16'hFF3C,16'hFF46,16'hFF50,16'hFF5A,16'hFF64,16'hFF6E,16'hFF77,16'hFF81,16'hFF8A,16'hFF94,16'hFF9D,16'hFFA6,16'hFFAF,
16'hFFB9,16'hFFC2,16'hFFCB,16'hFFD4,16'hFFDD,16'hFFE6,16'hFFEF,16'hFFF8 };
 
 //parameters for distance calculations
 const int INITIAL_DISTANCE = 10;
 parameter int DISTANCE_LIMIT = 100; //the number of times pressing space affect velocity and distance from center
 int CURRENT_DISTANCE,CURRENT_DISTANCE_D,MAX_DIST,MIN_DIST,BLUE_DIST;
 
 
 //parameters for line check
 const int THICKNESS = 1;
 const int MULTIPLIER = 512;
 int tempX, tempY, tempcenterX, tempcenterY;
 int line_equation1, line_equation2, difference;
 int slope;
 logic is_in_line;
 int pixel_distance;
 
 
 
 
 //this combinational part calculates distance of the pixel from stickcenter and checks if it is on the line equation
 always_comb begin
	pixel_distance = (pixelX - stickCenterX)*(pixelX - stickCenterX) + (pixelY - stickCenterY)*(pixelY - stickCenterY);
	
	
	slope = {{16{tan_table[angle][15]}},tan_table[angle]}; //assining to int to avoid sign problems
	tempY = pixelY*MULTIPLIER; tempcenterY = stickCenterY*MULTIPLIER; //assining to int to avoid sign problems
	tempX = pixelX*MULTIPLIER; tempcenterX = stickCenterX*MULTIPLIER; //assining to int to avoid sign problems
	
	line_equation1 = (tempY - tempcenterY); // calculating line equation part 1: Y-Y1
	line_equation2 =  ((slope*(tempX-tempcenterX))/512); // calculating line equation part 1: a(x-X1)
	difference = (line_equation1 - line_equation2)/MULTIPLIER;

	case (angle)
		9'd0: is_in_line = pixelY <= stickCenterY+THICKNESS && pixelY >= stickCenterY-THICKNESS && pixelX < stickCenterX;
		9'd90: is_in_line = pixelX <= stickCenterX+THICKNESS && pixelX >= stickCenterX-THICKNESS && pixelY < stickCenterY;
		9'd180: is_in_line = pixelY <= stickCenterY+THICKNESS && pixelY >= stickCenterY-THICKNESS && pixelX > stickCenterX;
		9'd270: is_in_line = pixelX <= stickCenterX+THICKNESS && pixelX >= stickCenterX-THICKNESS && pixelY > stickCenterY;
		default: begin
							is_in_line = ((angle < 90 && pixelX < stickCenterX	&& pixelY < stickCenterY) 
										|| (angle > 90 && angle < 180 && pixelX > stickCenterX	&& pixelY < stickCenterY)
										|| (angle > 180 && angle < 270 && pixelX > stickCenterX	&& pixelY > stickCenterY) 
										|| (angle > 270  && pixelX < stickCenterX	&& pixelY > stickCenterY));
							
							if ((angle <= 92 && angle >=88) || (angle <=272 && angle >=268))
								is_in_line = is_in_line && (difference>=-80 && difference <=80);
							else if ((angle <= 95 && angle >=85) || (angle <=275 && angle >=265))
								is_in_line = is_in_line && (difference>=-20 && difference <=20);
							else if ((angle <= 100 && angle >=80) || (angle <=280 && angle >=260))
								is_in_line = is_in_line && (difference>=-9 && difference <=9);		
							else if ((angle <= 110 && angle >=70) || (angle <=290 && angle >=250))
								is_in_line = is_in_line && (difference>=-3 && difference <=3);
							else
								is_in_line = is_in_line && (difference>=-1 && difference <=1);
					end // default
	endcase
 
 end// end_always comb
 
 


//CURRENT_DISTANCE + strike calculation
always_ff @(posedge clk or negedge resetN) begin

	if(!resetN) begin
		CURRENT_DISTANCE	<= INITIAL_DISTANCE;
	end
	
	else if (startOfFrame == 1'b1) begin
		CURRENT_DISTANCE_D <= CURRENT_DISTANCE;
		if (no_moving_flag == 1'b0 || game_state == 1'b0) begin
			CURRENT_DISTANCE	<= INITIAL_DISTANCE;
			strike <= 1'b0;
		end//end if there is a moving ball
		
		else if (space_pressed == 1'b1) begin
			CURRENT_DISTANCE	<= (CURRENT_DISTANCE >= INITIAL_DISTANCE+DISTANCE_LIMIT) ? CURRENT_DISTANCE : CURRENT_DISTANCE+1;
			strike <= 1'b0;
		end
			
		else begin
			if (CURRENT_DISTANCE > INITIAL_DISTANCE) begin
				if (CURRENT_DISTANCE <= INITIAL_DISTANCE+3 && CURRENT_DISTANCE != INITIAL_DISTANCE && CURRENT_DISTANCE_D > CURRENT_DISTANCE) begin
					strike <= game_state && no_moving_flag;
					CURRENT_DISTANCE <= INITIAL_DISTANCE;
				end//if current distance <= INITIAL_DISTANCE+3
				else begin
					CURRENT_DISTANCE <= CURRENT_DISTANCE-3;
					strike <= 1'b0;
				end//else
			end//if CURRENT_DISTANCE > INITIAL_DISTANCE
		end//else
		
	end// else if startOfFrame == 1'b1
	else begin
		strike <= 1'b0;
	end
	 
end // end always_ff 
 //calculating MIN and MAX and BLUE DIST
 assign MIN_DIST = CURRENT_DISTANCE*CURRENT_DISTANCE;
 assign MAX_DIST = (CURRENT_DISTANCE+100)*(CURRENT_DISTANCE+100);
 assign BLUE_DIST = (CURRENT_DISTANCE+3)*(CURRENT_DISTANCE+3);
 
 
 
  //drawing request signal sending
 always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		drawingRequest <= 1'b0;
	end
	else begin	

			if (is_in_line && pixel_distance >=MIN_DIST && pixel_distance<= MAX_DIST)
				drawingRequest <= game_state && no_moving_flag;
			else
				drawingRequest <= 1'b0;
			
		
	end
	 
end // end always_ff 


  //RGB_CALCULATION
 always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		RGB_out <= 8'b01000000; //maroon
	end
	else begin	

			if (pixel_distance<= BLUE_DIST)
				RGB_out <= 8'b00000001;
			else
				RGB_out <= 8'b01000000; //maroon
			
		
	end
end // end always_ff

 
 
 
 
 
 
 
endmodule

