// (c) Technion IIT, Department of Electrical Engineering 2019 
// Written By Natan Kaminsky and Nimrod Barazani June 2019

module GameController	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input		logic	 [3:0] level,
	input		logic	 level_is_valid,
	input		logic	 strike,
	input	   logic  ballIn,
	input	   logic  whiteballIn,
	input		logic  startOfFrame,
	input		logic  no_moving_flag,
	
	input		logic  win_cheatN,
	
	output	logic  menu_state,
	output 	logic  game_state,
	output	logic  end_state,
	output	logic  win,
	
	output	logic  [3:0] strikes_units_digit,
	output	logic  [3:0] strikes_tens_digit,
	output 	logic	 lastThree
	 
  ) ;

 int strikes_number;
  int temp_tens,temp_units; //temporary integers for calculating tens and units digts
 int balls_left = 8;
 
 
 const int EASY_MODE = 25;//TBD
 const int MEDIUM_MODE = 20;//TBD
 const int HARD_MODE = 15;//TBD

 
enum logic [1:0] {Sidle, Sgame, Send_win,Send_lose} prState, nxtState;
 
 always @(posedge clk or negedge resetN) begin
	   
		if ( !resetN )  // Asynchronic reset
			prState <= Sidle;
		else 		// Synchronic logic FSM
			prState <= nxtState;	
end // always

	
//STRIKES left calculations
 always @(posedge clk or negedge resetN) begin
	   
   if ( !resetN ) begin // Asynchronic reset
		balls_left <= 8;
		strikes_number <= 0;
	end
   else begin// Synchronic logic 
		//when game started
		if (prState == Sidle)
			balls_left<=8;
		if (prState == Sidle && level_is_valid) begin
			if(level == 4'b0001)
				strikes_number<=EASY_MODE;
			if(level == 4'b0010)
				strikes_number<=MEDIUM_MODE;
			if(level == 4'b0011)
				strikes_number<=HARD_MODE;
		end
		
		//during game
		if (prState == Sgame && ballIn)
			balls_left <= balls_left-1;
		if (prState == Sgame && strike)
			strikes_number <= strikes_number-1;
	end
			
end // always
 
 

 	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		
		
		menu_state = 1'b0;
		game_state = 1'b0;
		end_state = 1'b0;
		win = 1'b0;
		
		temp_tens = strikes_number/10;
		temp_units = strikes_number%10;
		
		
		
		
			
		case (prState)
				
			Sidle: begin
				if (win_cheatN == 1'b0)
					nxtState = Send_win;
				else if(level_is_valid)
					nxtState = Sgame;
				menu_state = 1'b1;
			end // idle
						
						
						
			Sgame: begin
				if (win_cheatN == 1'b0)
					nxtState = Send_win;
				else if(balls_left == 0)
					nxtState = Send_win;
				else if ((strikes_number == 0 && no_moving_flag == 1'b1) || whiteballIn)
					nxtState = Send_lose;
				game_state = 1'b1;	
			end // Sgame
			
			
						
			Send_win: begin
				end_state = 1'b1;
				win = 1'b1;		
			end // Send_win
					
					
					
			Send_lose: begin
				if (win_cheatN == 1'b0)
					nxtState = Send_win;
				end_state = 1'b1;
			end // Send_lose
						
						
		endcase
	end // always comb
	
assign strikes_tens_digit = temp_tens;
assign strikes_units_digit = temp_units;
assign lastThree = strikes_number<=3;
 
 
endmodule



