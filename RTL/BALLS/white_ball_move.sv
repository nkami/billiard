

module	white_ball_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,
					input logic strike,
					input int collision_velocityX,
					input int collision_velocityY,
					input int strike_velocityX,
					input int strike_velocityY,
					input logic scored,
					
					
					output logic [10:0] topLeftX,// output the top left corner 
					output logic [10:0] topLeftY,
					output int velocityX,
					output int velocityY
					
);


// a module used to generate a ball trajectory.  


parameter int INITIAL_X = 100;
parameter int INITIAL_Y = 207;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int X_ACCEL = 1;
parameter int Y_ACCEL = 1;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n
parameter int	p_topLeftTableX = 60;
parameter int	p_topLeftTableY = 90;
parameter int	p_tableWidth = 520;
parameter int	p_tableHeight = 270;
parameter int	p_woodWidth = 20;

const int BALL_SIZE = 16 * MULTIPLIER;

const int speed_smoother = 2;
const int speed_lim = 25;
int frame_counterX = 0;
int frame_counterY = 0;

int topLeftTableX = p_topLeftTableX * MULTIPLIER;
int topLeftTableY = p_topLeftTableY * MULTIPLIER;
int tableWidth = p_tableWidth * MULTIPLIER;
int tableHeight = p_tableHeight * MULTIPLIER;
int woodWidth = p_woodWidth * MULTIPLIER;

int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;



//  calculation x Axis speed 

//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed	<= INITIAL_X_SPEED;
		frame_counterX <= 0;
	end else begin
		if ((topLeftX_tmp <= (topLeftTableX + woodWidth) ) && (Xspeed < 0) ) begin// hit left border while moving right
			Xspeed <= -Xspeed ; 			
		end else if ( ((topLeftX_tmp+BALL_SIZE) >= (topLeftTableX + tableWidth - woodWidth) ) && (Xspeed > 0 )) begin 
			Xspeed <= -Xspeed ;
		end else if (scored == 1'b1) begin
			Xspeed <= 0;
		end else if ( strike == 1'b1 ) begin
			Xspeed <= strike_velocityX ;
		end else if ( collision == 1'b1 ) begin
			Xspeed <= collision_velocityX ;
		end else if (startOfFrame == 1'b1) begin
			if ( Xspeed > 0 && (Xspeed - speed_lim) < 0) begin
				if (frame_counterX > speed_smoother) begin
					frame_counterX <= 0;
					if ( Xspeed > 0 && (Xspeed - X_ACCEL) < 0) begin
						Xspeed <= 0 ;
					end else begin
						Xspeed <= Xspeed - X_ACCEL ;
					end
				end else begin
					frame_counterX <= frame_counterX+1;
				end
			end else if ( Xspeed > 0 ) begin
				Xspeed <= Xspeed - X_ACCEL ;
			end else if ( Xspeed < 0 && (Xspeed + speed_lim) > 0) begin
				if (frame_counterX > speed_smoother) begin 
					frame_counterX <= 0;
					if ( Xspeed < 0 && (Xspeed + X_ACCEL) > 0) begin
						Xspeed <= 0 ;
					end else begin
						Xspeed <= Xspeed + X_ACCEL ;
					end
				end else begin
					frame_counterX <= frame_counterX+1;
				end
			end else if ( Xspeed < 0 ) begin
				Xspeed <= Xspeed + X_ACCEL ;
			end
		end
	end
end


//  calculation Y Axis speed 
//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Yspeed	<= INITIAL_Y_SPEED;
		frame_counterY <= 0;
	end else begin
		if ((topLeftY_tmp <= (topLeftTableY + woodWidth) ) && (Yspeed < 0) ) begin// hit left border while moving right
			Yspeed <= -Yspeed ; 			
		end else if ( ((topLeftY_tmp+BALL_SIZE) >= (topLeftTableY + tableHeight - woodWidth) ) && (Yspeed > 0 )) begin 
			Yspeed <= -Yspeed ;
		end else if (scored == 1'b1) begin
			Yspeed <= 0;
		end else if ( strike == 1'b1 ) begin
			Yspeed <=  strike_velocityY;
		end else if ( collision == 1'b1 ) begin
			Yspeed <= collision_velocityY ;
		end else if (startOfFrame == 1'b1) begin
			if ( Yspeed > 0 && (Yspeed - speed_lim) < 0) begin
				if (frame_counterY > speed_smoother) begin 
					frame_counterY <= 0;
					if ( Yspeed > 0 && (Yspeed - Y_ACCEL) < 0) begin
						Yspeed <= 0 ;
					end else begin
						Yspeed <= Yspeed - Y_ACCEL ;
					end 
				end else begin
					frame_counterY <= frame_counterY+1;
				end
			end else if ( Yspeed > 0 ) begin
				Yspeed <= Yspeed - Y_ACCEL ;
			end else if ( Yspeed < 0 && (Yspeed + speed_lim) > 0) begin
				if (frame_counterY > speed_smoother) begin 
					frame_counterY <= 0;
					if ( Yspeed < 0 && (Yspeed + Y_ACCEL) > 0) begin
						Yspeed <= 0 ;
					end else begin
						Yspeed <= Yspeed + Y_ACCEL ;
					end 
				end else begin
					frame_counterY <= frame_counterY+1;
				end
			end else if ( Yspeed < 0 ) begin
				Yspeed <= Yspeed + Y_ACCEL ;
			end
		end
	end
end

// position calculate 
int topLeftX_tmp_d; 
int topLeftY_tmp_d; 
//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN)
begin
	
	if (!resetN) begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
	end else if (startOfFrame == 1'b1) begin
		topLeftX_tmp_d <= topLeftX_tmp; 
		topLeftY_tmp_d <= topLeftY_tmp; 
		topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
		topLeftY_tmp  <= topLeftY_tmp + Yspeed; 			
	end
	else if (collision == 1'b1) begin
		topLeftX_tmp  <= topLeftX_tmp_d; 
		topLeftY_tmp  <= topLeftY_tmp_d; 
	end
end

//----------------------------------------------------------------------------------------------
//get a better (64 times) resolution using integer   
always_comb begin
	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
	topLeftY = topLeftY_tmp / MULTIPLIER ;   
	velocityX = Xspeed;
	velocityY = Yspeed; 

end

endmodule
