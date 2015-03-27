module //later
//Ashish! I haven't initialized any reg or variable yet. Sorry! :P
input reset, up, down, fire, pause, clk;
var i, j;
reg firstScreen, counter321, gameStart, bulletFired, bulletX, bullet Y, shipHealth, shipY, gameOver;//shipX needed?
//also needed invaderX[i], invaderY[i], invaderHealth[i], invaderActive[i]
//while initializing bulletX, keep in mind that if we keep it 0, bullet will show on the screen and we can't keep it negative.
//I suggest, we keep bulletY >15;
initial begin
//Ashish! Initialize other things too.
i=5'd0;
j=5'd0;
end
always @ (posedge clk) begin
	if (reset) begin
		firstScreen = 1'b1;
		counter321 = 0;//2'b0? 0 1 2 3
	end
	else if (gameStart) begin
	//Ashish! Scoring Scheme
		for (j=5'd0; j<=5'd4; j=j+1) begin
			if (invaderHealth[j]>1'b0&invaderActive[j]==1'b1)	begin//Greater than 1'b0? Is that correct?
				invaderX[j]=invaderX[j]-1;// Ashish! Huge changes needed here, if we want to vary the speed of invaders with time.
				//Below is the invader-spaceship crash condition.
				if((invaderX[j]==4&invaderY[j]==shipY)|(invaderX[j]==3&(invaderY[j]==shipY+1|invaderY[j]=shipY-1))|(invaderX[j]==2&(invaderY[j]==shipY+2|invaderY[j]=shipY-2)))
				begin
					shipHealth=shipHealth-1;
					//Score Update required?
					invaderActive[j]=1'b0;
				end
				else if (invaderX[j]==1'b0) invaderActive=1'b0;//invader passes by, without crashing.
			end
			else if (invaderHealth[j]==1'b0) invaderActive[j]=1'b0;//Actually, even invaderActive is also redundant.
			else if (invaderActive[j]==1'b0) begin
				invaderX[j]=5'd27; invaderY[j]=randomNum;
				invaderActive[j]=1'b1;
				//Ashish! Random Number daal de yahan pe. Should be between 1 and 14.
				//X ko 27 isilye daala hai ki 3 second lage wapas se screen pe aane me.
				//and if you can, try to ensure that no two invaders overlap;
				//and maybe, the height of 16 LEDs is a bit less for 5 invaders of 3 LEDs height. I think 4 invaders will do. 
			end
		end
		// Ashish! if (pause-->not a pushbutton)....... kya karna hai? 
		if (~up) shipY= shipY+1;
		else if (~down) shipY= shipY-1;
		else if (~(fire|bulletFired)) begin
			bulletFired=1'b1;//crashed was redundant. bulletfired is basically ~crashed. Look at it that way.
			bulletX=5'd0;
			bulletY=shipY;
		end
		else if (bulletFired) begin
			bulletX=bulletX+1;
			if (bulletX==5'd23)//bullet passes by, withouth crashing.
				bulletFired=1'b0;
			else
			for (i=5'd0; i<=5'd4; i=i+1) begin
				//Below is the crash condition
				if (((bulletX==invaderX[i]-3)&(bulletY==invaderY[i]))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]+1))|((bulletX==invaderX[i]-2)&(bulletY==invaderY[i]-1)))
				begin
					invaderHealth[i]=invaderHealth[i]-1;
					bulletFired=1'b0;//crashed=1;
					//Ashish! Score Update
				end
			end
		
		end
		
		else if (shipHealth==2'b0) begin
			gameStart=0;
			gameOver=1;
			//gameover Screen, Score Display.
		end	
	end
	//else if (gameOver==1)....
end