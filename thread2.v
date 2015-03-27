/*
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . 0 0 . . . . . . . . . . . . .
. 0 . . . . . . 0 0 0 . . . . . . . . . . . . .
. 0 0 . . . . . . 0 0 . . . . . . . . . . . . .
. 0 0 0 . . . . . . . . . . . . . . . . . . . .
. 0 0 . . . . . . 0 0 . . . . . . . . . . . . .
. 0 . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . 0 0 . . . . . .
. . . . . . . . . . . . . . . 0 0 0 . . . . . .
. . . . . . . . . . . . . . . . 0 0 . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . . . . . .
*/
//first index - column no.
//second index - row no.

module thread2(clk1000);
input clk1000;

reg [3:0]counter321;
reg firstScreen;
reg gameStart;
reg [6:0]i,j;
reg [3:0]shipY;
reg bulletFired;
reg [4:0]bulletX;
reg [3:0]bulletY;
reg mat[0:23][0:15];
reg invaderActive[0:4];
reg [4:0]invaderX[0:4];
reg [3:0]invaderY[0:4];
reg [3:0]score;
reg [11:0]counter1;
reg clk1;

initial begin
firstScreen=1'b1;
counter321=4'b0;
gameStart=1'b0;
i=7'b0;
j=7'b0;
shipY=4'd8;
bulletFired=1'b1;
bulletX=5'd10;
bulletY=4'd8;
for(i=0;i<24;i=i+1)for(j=0;j<16;j=j+1)mat[i][j]=1'b0;
invaderActive[0]=1'b0;
invaderActive[1]=1'b1;
invaderActive[2]=1'b0;
invaderActive[3]=1'b1;
invaderActive[4]=1'b0;
invaderX[0]=5'd2;
invaderX[1]=5'd10;
invaderX[2]=5'd10;
invaderX[3]=5'd17;
invaderX[4]=5'd10;
invaderY[0]=4'd0;
invaderY[1]=4'd5;
invaderY[2]=4'd0;
invaderY[3]=4'd11;
invaderY[4]=4'd0;
score=4'd0;
counter1=12'd0;
clk1=1'b0;
end

always @(posedge clk1000)begin
if(counter1==12'd9)begin
counter1=12'd0;
clk1=~clk1;
end
else counter1=counter1+1;
end

always @(posedge clk1)begin
if(counter321<5)counter321=counter321+1;
end

always @(posedge clk1000)begin
if (firstScreen)  // while doing firstScreen=1, do counter321=0 i.e. reset it;
  begin 
      if(counter321<=1) begin
      for(i=0;i<24;i=i+1)for(j=0;j<16;j=j+1)mat[i][j]=1'b0;
      for(i=1;i<15;i=i+1)mat[6][i]=1'b1;
      for(i=1;i<15;i=i+1)mat[8][i]=1'b1;
      for(i=1;i<15;i=i+1)mat[10][i]=1'b1;
      mat[12][14]=1'b1;
      mat[14][14]=1'b1;
      mat[16][14]=1'b1;
      end
      
      else if(counter321<=2) begin
      for(i=0;i<24;i=i+1)for(j=0;j<16;j=j+1)mat[i][j]=1'b0;
      for(i=1;i<15;i=i+1)mat[7][i]=1'b1;
      for(i=1;i<15;i=i+1)mat[9][i]=1'b1;
      mat[11][14]=1'b1;
      mat[13][14]=1'b1;
      mat[15][14]=1'b1;
      end
      
      else if(counter321<=3) begin
      for(i=0;i<24;i=i+1)for(j=0;j<16;j=j+1)mat[i][j]=1'b0;
      for(i=1;i<15;i=i+1)mat[8][i]=1'b1;
      mat[10][14]=1'b1;
      mat[12][14]=1'b1;
      mat[14][14]=1'b1;
      end
      
      else begin
      gameStart = 1'b1;
      firstScreen=1'b0;
      end
      
  end

else if (gameStart)
begin
        //reset matrix
        for(i=0;i<24;i=i+1)for(j=0;j<16;j=j+1)mat[i][j]=1'b0;
             
       //fillSpaceship
       mat[0][shipY-2]=1'b1;
		 mat[0][shipY-1]=1'b1;
		 mat[0][shipY]=1'b1;
		 mat[0][shipY+1]=1'b1;
		 mat[0][shipY+2]=1'b1;
		 mat[1][shipY-1]=1'b1;
		 mat[1][shipY]=1'b1;
		 mat[1][shipY+1]=1'b1;
		 mat[2][shipY]=1'b1;
		 
       //fillBullet
		 if(bulletFired)begin
       mat[bulletX][bulletY]=1;
       mat[bulletX+1][bulletY]=1;
		 end
       
       //fillInvaders
         if(invaderActive[0])
         mat[invaderX[0]][invaderY[0]]=1;
         mat[invaderX[0]-1][invaderY[0]]=1;
         mat[invaderX[0]+1][invaderY[0]]=1;
         mat[invaderX[0]][invaderY[0]-1]=1;
         mat[invaderX[0]][invaderY[0]+1]=1;
         mat[invaderX[0]+1][invaderY[0]-1]=1;
         mat[invaderX[0]+1][invaderY[0]+1]=1;
         
			  if(invaderActive[1])
         mat[invaderX[1]][invaderY[1]]=1;
         mat[invaderX[1]-1][invaderY[1]]=1;
         mat[invaderX[1]+1][invaderY[1]]=1;
         mat[invaderX[1]][invaderY[1]-1]=1;
         mat[invaderX[1]][invaderY[1]+1]=1;
         mat[invaderX[1]+1][invaderY[1]-1]=1;
         mat[invaderX[1]+1][invaderY[1]+1]=1;
			
			  if(invaderActive[2])
         mat[invaderX[2]][invaderY[2]]=1;
         mat[invaderX[2]-1][invaderY[2]]=1;
         mat[invaderX[2]+1][invaderY[2]]=1;
         mat[invaderX[2]][invaderY[2]-1]=1;
         mat[invaderX[2]][invaderY[2]+1]=1;
         mat[invaderX[2]+1][invaderY[2]-1]=1;
         mat[invaderX[2]+1][invaderY[2]+1]=1;
			
			  if(invaderActive[3])
         mat[invaderX[3]][invaderY[3]]=1;
         mat[invaderX[3]-1][invaderY[3]]=1;
         mat[invaderX[3]+1][invaderY[3]]=1;
         mat[invaderX[3]][invaderY[3]-1]=1;
         mat[invaderX[3]][invaderY[3]+1]=1;
         mat[invaderX[3]+1][invaderY[3]-1]=1;
         mat[invaderX[3]+1][invaderY[3]+1]=1;
			
			  if(invaderActive[4])
         mat[invaderX[4]][invaderY[4]]=1;
         mat[invaderX[4]-1][invaderY[4]]=1;
         mat[invaderX[4]+1][invaderY[4]]=1;
         mat[invaderX[4]][invaderY[4]-1]=1;
         mat[invaderX[4]][invaderY[4]+1]=1;
         mat[invaderX[4]+1][invaderY[4]-1]=1;
         mat[invaderX[4]+1][invaderY[4]+1]=1;
       //fillscore
       for(i=0;(i<=score);i=i+1)
       mat[i][15]=1;
end
//nothing for game over as of now
end
endmodule

