module thread1(clk50, clk1, upButton, downButton, leftButton, rightButton, col25, row16);
input clk50, clk1, upButton, downButton, leftButton, rightButton;
output reg [23:0]col24;
output reg [15:0]row16;


reg [4:0] i,j;
reg firstScreen,  gameStart, bulletFired, gameOver, clk10;
reg [4:0] bulletX;
reg [3:0] bullet Y, shipY, counter321;
reg [2:0] shipHealth;//shipX needed?
reg invaderActive[0:4];
reg [4:0]invaderX[0:4];
reg [3:0]invaderY[0:4];
reg [3:0]score;
reg [2:0] invaderHealth;
reg [2:0] shipHealth;
parameter maxHealth = 3;

initial begin
//Ashish! Initialize other things too.
i=5'd0;
j=5'd0;
end

always @(posedge clk10)begin
	if (~leftButton) begin //reset
		firstScreen = 1'b1;
		counter321 = 4'b0;//2'b0? 0 1 2 3
	end
	else if (gameStart) begin
	//check for ship health
	if (shipHealth==3'd0)begin
		gameOver=1'b1;
		gameStart=1'b0;
	end
	else begin
		if (bulletFired) begin //bullet invader crash
			for (i=5'd0; i<=5'd4; i=i+1) begin
				//Below is the crash condition
				if (invaderActive[i]&((bulletX==invaderX[i]-3)&(bulletY==invaderY[i]))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]+1))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]-1)))
				begin
					invaderHealth[i]=invaderHealth[i]-1;
					if(invaderHealth[i]==3'b0)begin
						invaderActive[i]=1'b0;
						score=score+1;
					end
					bulletFired=1'b0;//crashed=1;
				end
				if (bulletX==5'd23)bulletFired=1'b0;//bullet passes by, withouth crashing.
			end
		end
		
		//ship invader crash
		for (j=5'd0; j<=5'd4; j=j+1) begin
		//ship invader crash condition
			if (invaderHealth[j]>3'b0&invaderActive[j]==1'b1)begin//Greater than 1'b0? Is that correct?
				if((invaderX[j]==4&invaderY[j]==shipY)|(invaderX[j]==3&(invaderY[j]==shipY+1|invaderY[j]=shipY-1))|(invaderX[j]==2&(invaderY[j]==shipY+2|invaderY[j]=shipY-2)))
				begin
					shipHealth=shipHealth-1;
					score = score -1;
					invaderActive[j]=1'b0;
				end
				else if (invaderX[j]==1'b0) invaderActive=1'b0;//invader passes by, without crashing.
			end
		end
		
		// change positions
		if (bulletFired)bulletX=bulletX+1;
		for (j=5'd0; j<=5'd4; j=j+1) begin
			if(invaderActive[j])invaderX[j]=invaderX[j]-1;
		end
		if(~upButton)shipY=shipY-1;
		if(~downButton)shipY=shipY+1;
		
		// create positions
		//bullet
		if(~bulletFired)begin
			if(~rightButton)begin
				bulletX=5'd1;
				bulletFired=1'b1;
				bulletY=shipY;
			end
		end
		//invader
		for(i=0;i<5'd5;i=i+1)begin
			if(~invaderActive[i])begin
			if(invaderHealth[i]==maxHealth)begin
					invaderActive[i]=1'b1;
				    invaderX[i]=5'd23;
					invaderY[i]=randomY;
				end
			else invaderHealth[i]=invaderHealth[i]+1;
	end