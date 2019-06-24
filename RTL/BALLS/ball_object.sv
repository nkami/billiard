

module	ball_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic	[10:0] topLeftX, //position on the screen 
					input 	logic	[10:0] topLeftY,
					input		logic ball_scored, // indicates if ball went into a hole
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest // indicates pixel inside the bracket
);

enum  logic [1:0] {BALL_ON_TABLE, // initial state
						 BALL_IN_HOLE // if ball scored
						}  nxt_st, cur_st;

parameter  int OBJECT_WIDTH_X = 16;
parameter  int OBJECT_HEIGHT_Y = 16; 

 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 


//----------------------------------------------------------------------------------------------
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);


//----------------------------------------------------------------------------------------------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
		cur_st 			<= BALL_ON_TABLE;
	end
	else begin
	
		
		cur_st <= nxt_st;
		
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket && cur_st == BALL_ON_TABLE) // test if it is inside the ball 
		begin 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 

always_comb begin 
	if (ball_scored == 1'b1) begin
		nxt_st = BALL_IN_HOLE;
	end else begin
		nxt_st = cur_st;
	end

end

endmodule 