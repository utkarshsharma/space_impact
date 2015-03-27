module thread1(clk50, clk1, upButton, downButton, leftButton, rightButton, col24, row16);
input clk50, clk1, upButton, downButton, leftButton, rightButton;
output reg [23:0]col24;
output reg [15:0]row16;


reg [4:0] i,j;
reg firstScreen,  gameStart, bulletFired, gameOver, clk10;
reg [4:0] bulletX;
reg [3:0] bulletY, shipY, counter321;
reg [2:0] shipHealth;//shipX needed = no
reg invaderActive[0:4];
reg [4:0]invaderX[0:4];
reg [3:0]invaderY[0:4];
reg [3:0]score;
reg [2:0] invaderHealth[0:4];
reg [3:0] randcounter;
reg [3:0] randomY [0:15];
parameter maxHealth = 3;

initial begin
//Ashish! Initialize other things too.
i=5'd0;
j=5'd0;
firstScreen=1'b1;
gameStart=1'b0;
gameOver=1'b0;
bulletFired=1'b0;
clk10=1'b0;
shipHealth=3'd5;
shipY=4'd8;

invaderActive[0]=1'b0;
invaderActive[1]=1'b0;
invaderActive[2]=1'b0;
invaderActive[3]=1'b0;
invaderActive[4]=1'b1;
invaderX[4]=5'd23;
invaderY[4]=4'd7;
score=4'b0;

invaderHealth[0]=3'd0;
invaderHealth[1]=3'd1;
invaderHealth[2]=3'd2;
invaderHealth[3]=3'd3;
invaderHealth[4]=3'd3;

randcounter=4'b0;
counter321=4'b0;
bulletX=5'd1;
bulletY=4'd8;

randomY[0]=4'd11;
randomY[1]=4'd2;
randomY[2]=4'd4;
randomY[3]=4'd5;
randomY[4]=4'd1;
randomY[5]=4'd7;
randomY[6]=4'd3;
randomY[7]=4'd8;
randomY[8]=4'd9;
randomY[9]=4'd12;
randomY[10]=4'd10;
randomY[11]=4'd13;
randomY[12]=4'd6;
randomY[13]=4'd14;
randomY[14]=4'd4;
randomY[15]=4'd9;
end

always @(posedge clk1)begin
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
			for (i=3'd0; i<=3'd4; i=i+1) begin
				//Below is the crash condition
				if (invaderActive[i]&((bulletX==invaderX[i]-3)&(bulletY==invaderY[i]))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]+1))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]-1)))
				begin
					invaderHealth[i]=invaderHealth[i]-1;
					bulletFired=1'b0;//crashed=1;
					if(invaderHealth[i]==3'b0)begin
						invaderActive[i]=1'b0;
						score=score+1;
					end
				end
			end
			if (bulletX==5'd23)bulletFired=1'b0;//bullet passes by, withouth crashing.
		  end
		
		//ship invader crash
		for (j=5'd0; j<=5'd4; j=j+1) begin
		//ship invader crash condition
			if (invaderHealth[j]>3'b0&invaderActive[j]==1'b1)begin   //Greater than 1'b0? Is that correct?
				if(((invaderX[j]==4)&(invaderY[j]==shipY))|((invaderX[j]==3)&((invaderY[j]==shipY+1)|(invaderY[j]=shipY-1)))|((invaderX[j]==2)&((invaderY[j]==shipY+2)|(invaderY[j]=shipY-2))))
				begin
					shipHealth=shipHealth-1;
					score = score -1;
					invaderActive[j]=1'b0;
				end
				else if (invaderX[j]==1'b0) invaderActive[i]=1'b0;//invader passes by, without crashing.
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
					invaderY[i]=randomY[randcounter];
				end
			else invaderHealth[i]=invaderHealth[i]+1;
			end
		end
	  end
	end
end

always @(posedge clk1)begin
	randcounter=randcounter+1;
	if(randcounter==4'b1111)randcounter=4'b0;
end
endmodule
