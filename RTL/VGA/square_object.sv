//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest // indicates pixel inside the bracket
			
);

parameter  int OBJECT_WIDTH_X = 16;
parameter  int OBJECT_HEIGHT_Y = 32; 
parameter 	logic	[10:0] topLeftX = 550; //position on the screen 
parameter 	logic	[10:0] topLeftY = 22;
 
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
	

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		// ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
		
		if (insideBracket ) // test if it is inside the rectangle 
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
endmodule 