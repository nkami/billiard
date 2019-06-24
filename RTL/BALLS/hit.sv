

module	hit	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  
					input logic [10:0] ball_requests,
					input logic [5:0] hole_requests,					
					input int velocitiesX[0:10],
					input int velocitiesY[0:10],
					
					input [0:10] [10:0] topLeftXs,
					input [0:10] [10:0] topLeftYs,
					
//					input int slice_lim,
//					input int recoil,
//					
					
					output logic [10:0] collisions,		
					output logic [10:0] ball_scored,
					output int newVelocitiesX[0:10],
					output int newVelocitiesY[0:10],				
					output logic ballIn,
					output logic no_moving_flag
);

localparam int NUMBER_OF_BALLS = 11; //number of balls in the game
localparam int NUMBER_OF_HOLES = 6;	 // number of holes in the game	
//localparam int slice_lim = 5;
localparam int recoil = 20;	
localparam int overlap_recoil = 30;				  						  

int all_zeros[NUMBER_OF_BALLS] = '{default:0}; //an array used to check if all balls stopped moving

assign no_moving_flag = (velocitiesX == all_zeros && velocitiesY == all_zeros);

int first_ball_request, second_ball_request, hole_request; //flags for determining the relevant balls requests

int slice, diffX, diffY; // determines the angle the balls collided, can only recieve 8 options

logic frame_flag; //insures that hit takes care of a collision once per frame
			  
always_comb begin
	
	first_ball_request = -1;
	second_ball_request = -1;
	hole_request = -1;
	slice = -1;
	diffX = -1;
	diffY = -1;

	// find the first pair of balls colliding
	for (int i = 0; i < NUMBER_OF_BALLS; i++) begin 
		if (ball_requests[i] == 1'b1) begin
			if (first_ball_request == -1) begin
				first_ball_request = i;
			end else if (second_ball_request == -1) begin
				second_ball_request = i;
			end
		end
	end
	
	//if no balls collision, check if a ball scored
	if (first_ball_request != -1 && second_ball_request == -1) begin
		for (int i = 0; i < NUMBER_OF_HOLES; i++) begin
			if (hole_requests[i] == 1'b1 && hole_request == -1) begin
				hole_request = i;
			end
		end
	end

//	if (first_ball_request != -1 && second_ball_request != -1) begin
//		// diff range: (-16, 16)
//		diffX = topLeftXs[first_ball_request] - topLeftXs[second_ball_request];
//		diffY = topLeftYs[first_ball_request] - topLeftYs[second_ball_request];
//		if ((diffX <= -slice_lim || diffX >= slice_lim) && diffY >= -slice_lim && diffY <= slice_lim) begin
//			slice = 1; // 9 or 3 a clock
//		end else if (diffX >= -slice_lim && diffX <= slice_lim && (diffY <= -slice_lim || diffY >= slice_lim)) begin
//			slice = 2; // 12 or 6 a clock
//		end else if (diffX < -slice_lim && diffY > slice_lim) begin
//			slice = 3; // 10:30 a clock
//		end else if (diffX > slice_lim && diffY > slice_lim) begin
//			slice = 4; // 1:30 a clock
//		end else if (diffX > slice_lim && diffY < -slice_lim) begin
//			slice = 5; // 4:30 a clock
//		end else if (diffX < -slice_lim && diffY < -slice_lim) begin
//			slice = 6; // 7:30 a clock
//		end
//		else begin
//			slice = 1;
//		end
//	end 
end
					  
//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin
		ball_scored <= 11'b00_000_000_000;
		collisions <= 11'b00_000_000_000;
		ballIn <= 1'b0;
		frame_flag <= 1'b1  ;
	end else begin	
		//default values
		ball_scored <= 11'b00_000_000_000;
		collisions <= 11'b00_000_000_000;
		ballIn <= 1'b0;
	
		if (first_ball_request != -1 && second_ball_request != -1 && frame_flag == 1'b1) begin //in case of balls colliding
			frame_flag <= 1'b0;
			collisions[first_ball_request] <= 1'b1;
			collisions[second_ball_request] <= 1'b1;
			
			if (velocitiesX[first_ball_request] == 0 && velocitiesX[first_ball_request] == 0 &&
				 velocitiesY[second_ball_request] == 0 && velocitiesY[second_ball_request] == 0) begin	//prevent balls overlapping
				 				 
				if (topLeftXs[first_ball_request] < topLeftXs[second_ball_request] ) begin
					newVelocitiesX[first_ball_request] <= -overlap_recoil;
					newVelocitiesX[second_ball_request] <= overlap_recoil;
				end else begin
					newVelocitiesX[first_ball_request] <= overlap_recoil;
					newVelocitiesX[second_ball_request] <= -overlap_recoil;
				end
				
				if (topLeftYs[first_ball_request] < topLeftYs[second_ball_request] ) begin
					newVelocitiesY[first_ball_request] <= -overlap_recoil;
					newVelocitiesY[second_ball_request] <= overlap_recoil;
				end else begin
					newVelocitiesY[first_ball_request] <= overlap_recoil;
					newVelocitiesY[second_ball_request] <= -overlap_recoil;
				end
				
			end else begin //swap velocities between balls according to slice
				
				if (topLeftXs[first_ball_request] < topLeftXs[second_ball_request]) begin
					newVelocitiesX[first_ball_request] <= velocitiesX[second_ball_request] - recoil;
					newVelocitiesX[second_ball_request] <= velocitiesX[first_ball_request];
				end else begin
					newVelocitiesX[first_ball_request] <= velocitiesX[second_ball_request] + recoil;
					newVelocitiesX[second_ball_request] <= velocitiesX[first_ball_request];
				end
				
				if (topLeftYs[first_ball_request] < topLeftYs[second_ball_request] ) begin
					newVelocitiesY[first_ball_request] <= velocitiesY[second_ball_request] - recoil;
					newVelocitiesY[second_ball_request] <= velocitiesY[first_ball_request];
				end else begin
					newVelocitiesY[first_ball_request] <= velocitiesY[second_ball_request] + recoil;
					newVelocitiesY[second_ball_request] <= velocitiesY[first_ball_request];
				end

//				if (slice == 3) begin //10:30
//					newVelocitiesX[first_ball_request] <= ((velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) - recoil;
//					newVelocitiesX[second_ball_request] <= ((velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//			
//					newVelocitiesY[first_ball_request] <= ((velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) - recoil;
//					newVelocitiesY[second_ball_request] <= ((velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//				end else if (slice == 4) begin //1:30
//					newVelocitiesX[first_ball_request] <= ((velocitiesX[second_ball_request]/2) - (velocitiesY[second_ball_request]/2)) + recoil;
//					newVelocitiesX[second_ball_request] <= ((velocitiesX[first_ball_request]/2) - (velocitiesY[first_ball_request]/2));
//			
//					newVelocitiesY[first_ball_request] <= ((-velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) - recoil;
//					newVelocitiesY[second_ball_request] <= ((-velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//				end else if (slice == 5) begin //4:30
//					newVelocitiesX[first_ball_request] <= ((velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) + recoil;
//					newVelocitiesX[second_ball_request] <= ((velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//			
//					newVelocitiesY[first_ball_request] <= ((velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) + recoil;
//					newVelocitiesY[second_ball_request] <= ((velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//				end else if (slice == 6) begin //7:30
//					newVelocitiesX[first_ball_request] <= ((velocitiesX[second_ball_request]/2) - (velocitiesY[second_ball_request]/2)) - recoil;
//					newVelocitiesX[second_ball_request] <= ((velocitiesX[first_ball_request]/2) - (velocitiesY[first_ball_request]/2));
//			
//					newVelocitiesY[first_ball_request] <= ((-velocitiesX[second_ball_request]/2) + (velocitiesY[second_ball_request]/2)) + recoil;
//					newVelocitiesY[second_ball_request] <= ((-velocitiesX[first_ball_request]/2) + (velocitiesY[first_ball_request]/2));
//				end else if (slice == 1 || slice == 2) begin
//					newVelocitiesX[first_ball_request] <= velocitiesX[second_ball_request];
//					newVelocitiesX[second_ball_request] <= velocitiesX[first_ball_request];
//			
//					newVelocitiesY[first_ball_request] <= velocitiesY[second_ball_request];
//					newVelocitiesY[second_ball_request] <= velocitiesY[first_ball_request];
//				end
				
			end
		end else if (hole_request != -1 && frame_flag == 1'b1) begin //in case a ball is scored
			ball_scored[first_ball_request] <= 1'b1;	
			if (first_ball_request != 0)
				ballIn <= 1'b1;
			else
				ballIn <= 1'b0;
			frame_flag <= 1'b0;
	end	
	if (startOfFrame == 1'b1) begin
		frame_flag <= 1'b1;
	end
	
	
	end
end

endmodule
