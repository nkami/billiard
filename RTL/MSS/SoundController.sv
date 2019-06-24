// (c) Technion IIT, Department of Electrical Engineering 2019 
// Written By Natan Kaminsky and Nimrod Barazani June 2019

module SoundController	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input		logic	 strike,
	input		logic	[10:0] colisions,
	input	   logic  ballIn,
	input		logic  end_state,
	input		logic  win,
	output 	logic  EnableSound,
	output	logic [31:0] preScaleValue
	
	
	

	 
  ) ;
  
  
  parameter logic [31:0] colissionOrStrikePreScale = 32'd160000;//TB
  
  parameter logic [31:0] EndWinPreScale1 = 32'd746;//TBD
  parameter logic [31:0] EndWinPreScale2 = 32'd627;//TBD
  parameter logic [31:0] EndWinPreScale3 = 32'd498;//TBD
  
  parameter logic [31:0] EndLosePreScale1 = 32'd3986;//TBD
  parameter logic [31:0] EndLosePreScale2 = 32'd4740;//TBD
  parameter logic [31:0] EndLosePreScale3 = 32'd5972;//TBD
  
  parameter logic [31:0] ballInPreScale = 32'd627;//TBD
  
  parameter int SoundTime = 12_500_000;
  
  int counter, nxtCounter;
  logic [31:0] nxtpreScaleValue;
  logic resetCounter;
  


 
enum logic [2:0] {Sidle, SballIn, ScolisionOrStrike, Send_win,Send_lose} prState, nxtState;
 
 //State assignment + counter update
 always @(posedge clk or negedge resetN) begin
	   
		if ( !resetN )  begin// Asynchronic reset
			prState <= Sidle;
			counter <= 0;
			preScaleValue = 31'b0;
		end
		else begin		// Synchronic logic FSM
			prState <= nxtState;	
			preScaleValue <= nxtpreScaleValue;
			if (resetCounter == 1'b1)
				counter <= nxtCounter;
			else
				counter <= counter == 0 ? 0 : counter-1;
		end
end // always


 	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		nxtpreScaleValue = preScaleValue;
		EnableSound = 1'b0;
		resetCounter = 1'b0;
		nxtCounter = 0;
		
		
		case (prState)
			
			
			//~~~~~~~~~~~~~~~~~~~IDLE~~~~~~~~~~~~~~~~~~~~~~~~~~
			Sidle: begin
				if(strike == 1'b1 || colisions[0] == 1'b1 || colisions[1] == 1'b1 || colisions[2] == 1'b1 || colisions[3] == 1'b1 || colisions[4] == 1'b1 || 
						colisions[5] == 1'b1 || colisions[6] == 1'b1 || colisions[7] == 1'b1 || colisions[8] == 1'b1 || colisions[9] == 1'b1 || colisions[10] == 1'b1) begin
					nxtState = ScolisionOrStrike;
					nxtCounter = SoundTime;
					nxtpreScaleValue = colissionOrStrikePreScale;
					resetCounter = 1'b1;
				end
				
				else if (ballIn == 1'b1) begin
					nxtState = SballIn;
					nxtCounter = SoundTime;
					nxtpreScaleValue = ballInPreScale;
					resetCounter = 1'b1;
				end
				
				else if (end_state == 1'b1 && win == 1'b1) begin
					nxtState = Send_win;
					nxtCounter = SoundTime;
					nxtpreScaleValue = EndWinPreScale1;
					resetCounter = 1'b1;
				end
				
				else if (end_state == 1'b1) begin
					nxtState = Send_lose;
					nxtCounter = SoundTime;
					nxtpreScaleValue = EndLosePreScale1;
					resetCounter = 1'b1;
				end
			end // idle
						
						
			//~~~~~~~~~~~~~~~~~~~colisionOrStrike~~~~~~~~~~~~~~~~~~~~~~~~~~			
			ScolisionOrStrike: begin
				EnableSound = 1'b1;
				if(strike == 1'b1 || colisions[0] == 1'b1 || colisions[1] == 1'b1 || colisions[2] == 1'b1 || colisions[3] == 1'b1 || colisions[4] == 1'b1 || 
						colisions[5] == 1'b1 || colisions[6] == 1'b1 || colisions[7] == 1'b1 || colisions[8] == 1'b1 || colisions[9] == 1'b1 || colisions[10] == 1'b1) begin
					nxtCounter = SoundTime;
					resetCounter = 1'b1;
				end
				else if (counter == 0)
					nxtState = Sidle;
			end // ScolisionOrStrike
									
			SballIn: begin
				EnableSound = 1'b1;
				if (counter == 0) begin
					nxtState = Sidle;
				end
			end // SballIn
			
			//~~~~~~~~~~~~~~~~~~~END_WIN~~~~~~~~~~~~~~~~~~~~~~~~~~
			Send_win: begin
				if (counter == 0) begin
					if (preScaleValue == EndWinPreScale1) begin
						EnableSound = 1'b1;
						resetCounter = 1'b1;
						nxtpreScaleValue = EndWinPreScale2;
						nxtCounter = 2*SoundTime;
					end else if (preScaleValue == EndWinPreScale2) begin
						EnableSound = 1'b1;
						resetCounter = 1'b1;
						nxtpreScaleValue = EndWinPreScale3;
						nxtCounter = 4*SoundTime;
					end else begin
						EnableSound = 1'b0;
					end
				end
				else
					EnableSound = 1'b1;
			end // Send_win
			
			//~~~~~~~~~~~~~~~~~~~END_LOSE~~~~~~~~~~~~~~~~~~~~~~~~~~
			Send_lose: begin
				
				if (counter == 0) begin
					if (preScaleValue == EndLosePreScale1) begin
						EnableSound = 1'b1;
						resetCounter = 1'b1;
						nxtpreScaleValue = EndLosePreScale2;
						nxtCounter = 2*SoundTime;
					end else if (preScaleValue == EndLosePreScale2) begin
						EnableSound = 1'b1;
						resetCounter = 1'b1;
						nxtpreScaleValue = EndLosePreScale3;
						nxtCounter = 4*SoundTime;
					end else begin
						EnableSound = 1'b0;
					end
				end
				else
					EnableSound = 1'b1;
			end // Send_lose
						
						
		endcase
	end // always comb

 
 
endmodule