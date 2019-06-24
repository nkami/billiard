

module	hole_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					output	logic	drawingRequest // indicates pixel inside the bracket 
);

parameter  int OBJECT_WIDTH_X = 10;
parameter  int OBJECT_HEIGHT_Y = 10;
parameter  logic [10:0] topLeftX = 0;
parameter  logic [10:0] topLeftY = 0;

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
	end
	else begin 
	
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket ) // test if it is inside the hole 
		begin 
			drawingRequest <= 1'b1 ;
		end 
		
		else begin   
			drawingRequest <= 1'b0 ;
		end 
		
	end
end 
endmodule 