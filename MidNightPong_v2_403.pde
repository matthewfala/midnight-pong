
//keys
boolean isKeyWPressed = false;
boolean isKeySPressed = false;
boolean isKeyOPressed = false;
boolean isKeyKPressed = false;


///gameManager//////////////////////
float splashDisplayTime = 5;


//CreateGlobal Imgs
PImage splashImageStill;
PImage titleImageStill;
PImage aboutScreen1;
PImage aboutScreen2;
PImage gameImageStill;
PImage gamePausedStill;
PImage playerStill;
PImage fireFlyStill;
PImage oneWinsImage;
PImage twoWinsImage;

//CreateClock
float tempClock;
float clock = 0;





//createObjects
ball fireFly = new ball(width/2, height/2, 0,0);
paddle player1 = new paddle(40, isKeyWPressed, isKeySPressed);
paddle player2 = new paddle(1500-40,isKeyOPressed, isKeyKPressed);


// LayerRendering
String gameRenderLayer   = "SplashScreen";

//gameRenderLayer        = "GameScreen" ;
int pauseScreenRendered  = 0;      //dont reneder pause screen
color clsColor = color(10,80,100);

//Constants (change these)
int pointsPerGame = 500;
int fireFlyDiameter = 100;
int paddleHeight = 150;

//////////////////////////////////////
//Node VARIABLES

//SplashScreen
int splashScreenOpacity = 255;

//titlescreen
float upDownDir = 0;
float upDown    = 0;
float titleScreenOpacity = 0;

//aboutScreen
float aboutScreenOpacity = 0;
int aboutScreenPhase = 0;

//GameScreen
float fireFlySpeedInc= 0.25;
int pointEnded     = 0;
int scorePlayerOne = 0;
int scorePlayerTwo = 0;
//int pointEnded = 0; //(0 - game in play, 1 - player one wins, 2- player two wins)
int gameEnded    = 0; //(0 - game in session, 2 - game stops go to start screen)
int gameStartQue = 0; //


//PausedScreen
int pausedImageLocation = -(height);

//endScreen
int endOpacity = 0;

void setup(){
  fill(10,80,100);
  stroke(255);
  size(1500,800);
  textSize(30);
  
  //loadImages and resize 
  splashImageStill = loadImage("splashImage.png");
  splashImageStill.resize(width,height);
  
  titleImageStill  = loadImage("titleScreen2.png");
  titleImageStill.resize(width,height);
  
  aboutScreen1     = loadImage("aboutScreen1.png");
  aboutScreen1.resize(width,height);
  
  aboutScreen2     = loadImage("aboutScreen2.png");
  aboutScreen2.resize(width,height);
  
  gameImageStill   = loadImage("gameBackground2.png");
  gameImageStill.resize(width,height);
  
  gamePausedStill = loadImage("gamePaused2.png");
  gamePausedStill.resize(width,height);
  
  playerStill  = loadImage("player.png");
  playerStill.resize(0, paddleHeight);
  
  fireFlyStill    = loadImage("fireFly.png");
  fireFlyStill.resize(0, fireFlyDiameter);
  
  oneWinsImage    = loadImage("playerOneWins.png");
  oneWinsImage.resize(width, height);
  
  twoWinsImage    = loadImage("playerTwoWins.png");
  twoWinsImage.resize(width,height);
  

  clock = second()+ minute()*60; 
}





void draw() {
  splashScreen();
  titleScreen();
  aboutScreen();
  gameScreen();
  gamePaused();
  manageGameLayers();
  scoreKeepPoints();
  //println(gameRenderLayer);
}




//draw the splashScreen
void splashScreen() {
  if (gameRenderLayer == "SplashScreen") {
    background(0,0,0);
    image(splashImageStill,0,0);
    if (second()+ minute() * 60 -clock >= splashDisplayTime-3 && splashScreenOpacity>0) splashScreenOpacity -= 15;
    tint(255, splashScreenOpacity);
      
    
    //displayTWOSeconds
    if((second() + minute()* 60 -clock) >= splashDisplayTime){
      gameRenderLayer = "TitleScreen";
      tint(255,255);
    }
  }
}



void titleScreen() {
  if (gameRenderLayer == "TitleScreen") {
    //fadein
    if (titleScreenOpacity<255){
      titleScreenOpacity += .5;
      tint(255,titleScreenOpacity);
      image(titleImageStill,0,0);
      tint(255,255);
      //sprintln("brightened");
    } else{
      background(titleImageStill);
    }
    
    //space hit go to game if in title screen
    if (keyPressed) {
        if (key == ' ' || key == ' ') {
          gameStartQue = 1;
          //println("game start");
        }
    }
    
    //a hit go to game if in about screen
    if (keyPressed) {
        if (key == 'a' || key == 'A') {
           gameRenderLayer = "AboutScreen";
        }
    }
  }
}

//the ABOUT SCREEN
void aboutScreen() {
if (gameRenderLayer == "AboutScreen") {
  
  if (aboutScreenPhase == 0) {//fade in phase
    if (aboutScreenOpacity< 255) {
      tint(255, aboutScreenOpacity);
      image(aboutScreen1, 0,0);
      aboutScreenOpacity+= 5;
    } else { //done fading
      aboutScreenPhase = 1;
      aboutScreenOpacity = 0;
      clock = second()+ minute()*60; // start clock
    }
    
  } else if (aboutScreenPhase == 1) { // show About screen
    if (second()+ minute()*60-clock < 5) {
      background(aboutScreen1);
      
       // if key pressed go to phase 2
      if (keyPressed) {
         aboutScreenPhase = 2;
      }
      
    } else {
      aboutScreenPhase = 2;

    }
  } else if (aboutScreenPhase == 2) { //fade in
    if (aboutScreenOpacity< 255) {
      background(aboutScreen1);
      tint(255, aboutScreenOpacity);
      image(aboutScreen2,0,0);
      aboutScreenOpacity += 5;
    } else { 
      aboutScreenPhase = 3; 
      aboutScreenOpacity = 0;
      clock = second() + minute()*60; //start clock again
    }
  } else if (aboutScreenPhase == 3) { // show Instructions 10 seconds
    if (minute()*60 + second() - clock< 20 ) {
      background(aboutScreen2);
      
      // if key pressed go to phase 4
      if (keyPressed) {
         aboutScreenPhase = 4;
         aboutScreenOpacity = 0;
         
      }
    } else {
      aboutScreenPhase = 4;
      aboutScreenOpacity = 0; 
    }
      
  } else if (aboutScreenPhase == 4) { //fade in title
    if (aboutScreenOpacity< 255) {
      background(aboutScreen2);
      tint(255, aboutScreenOpacity);
      image(titleImageStill,0,0);
      aboutScreenOpacity += 5;
    } else { 
      aboutScreenPhase = 5; 
      clock = second(); //start clock again
    
    }
 } else if (aboutScreenPhase == 5) { //exit to titlescreen
    gameRenderLayer = "TitleScreen";
    aboutScreenPhase = 0;
    aboutScreenOpacity = 0;
  }
 }
    
    
    
} 




//The game
void gameScreen() {
 if (gameRenderLayer == "GameScreen"){
   //clearscreen
   background(gameImageStill);
   textSize(70);
   fill(1,8,10);
   text(scorePlayerOne, 300, 200);
   text(scorePlayerTwo, width-500, 200);
   
   fireFly.update();
   fireFly.drawBall();
   
   player1.update(isKeyWPressed, isKeySPressed);
   player1.render();
   
   player2.update(isKeyOPressed, isKeyKPressed);
   player2.render();
   
   
  //Paused pause game
  if (keyPressed) {
      if (key == 'p' || key == 'q') {
        pausedImageLocation = -(height);
        gameRenderLayer = "PauseScreen";
        
      }
  }
  
  //end game 
  if ( scorePlayerOne  > pointsPerGame || scorePlayerTwo > pointsPerGame) {
    gameEnded = 1;
  }
  
 }
}


  
void gamePaused() {
if (gameRenderLayer == "PauseScreen"){
   //fade in then display
   if (pausedImageLocation < 0) {
     tint(255, (255+pausedImageLocation));
     image(gamePausedStill, 0, pausedImageLocation);
     pausedImageLocation+= 5;
     tint(255,255);
   } else {
     background(gamePausedStill);
   }
   //resume if space hit
   if (keyPressed) {
        if (key == ' ') {
          gameRenderLayer = "GameScreen";
        }
   }
   
   //exit if r hold
   if (keyPressed) {
        if (key == 'r' || key == 'R') {
          gameRenderLayer = "TitleScreen";
        }
   }
}   
}


void scoreKeepPoints() {
  
  //resetball and whatnot for each point
  if (pointEnded == 1 || pointEnded == 2){
    if (pointEnded == 2) scorePlayerOne +=100; //point ends by player two add to player 1
    if (pointEnded == 1) scorePlayerTwo +=100;
    fireFly.x = width/2;
    fireFly.y = height/2;
    //make the ball alternate directions between games;
    if (pointEnded == 2) fireFly.speedX = -4;
    if (pointEnded == 1) fireFly.speedX =  4;
    //random speedY
    fireFly.speedY = random(-3,3);
    pointEnded = 0;
  }
  

}



void manageGameLayers() {
  
  if (gameEnded == 1){
    gameRenderLayer = "NONE";
    println("score1:" + scorePlayerOne + ". Score2:" + scorePlayerTwo); 
    //player 1 wins
    if (scorePlayerOne < scorePlayerTwo){ //all scores are backwards
        if (endOpacity<255){
          endOpacity += 1;
          tint(255,endOpacity);
          image(oneWinsImage,0,0);
          tint(255,255);
          //sprintln("brightened");
          clock = second() + minute()*60;
         } else{
          background(oneWinsImage);
          endOpacity += 1;
          if (second() + minute()*60 - clock > 10) {// > time to display
            endOpacity = 0;
            gameEnded = 2;
          }
        }
      
    } 
    
    if (scorePlayerTwo < scorePlayerOne) {
      gameRenderLayer = "NONE";
        if (endOpacity<255){
          endOpacity += 1;
          tint(255,endOpacity);
          image(twoWinsImage,0,0);
          tint(255,255);
          clock = second() + minute()*60;
          //sprintln("brightened");
        } else{
          background(twoWinsImage);
          endOpacity += 1;
          if (second() + minute()*60 - clock > 10) {//timed go to phase 2
            endOpacity = 0;
            gameEnded = 2;
          }
       }
   }
  }
      
  //Game ended phase 2
  if (gameEnded == 2) {
    //show title Screen
    gameRenderLayer   = "TitleScreen";
    fireFly.x = width/2;
    fireFly.y = height/2;
    fireFly.speedX = 0;
    fireFly.speedY = 0;
    gameEnded = 0;   
    println("gameDone");
    
  }
  
//Manage the colisions with the paddles;

  //player1
   if (fireFly.y-fireFlyDiameter < player1.y && fireFly.y+fireFlyDiameter +fireFlyDiameter > player1.y + paddleHeight){
     if (fireFly.x < player1.x) {
      //moveforward
       fireFly.speedX = abs(fireFly.speedX)+ fireFlySpeedInc;
     }
   }
  //player2
   if (fireFly.y-fireFlyDiameter < player2.y && fireFly.y + fireFlyDiameter + fireFlyDiameter > player2.y + paddleHeight){
     if (fireFly.x+fireFlyDiameter > player2.x) {
      //moveBackward
       fireFly.speedX = -(abs(fireFly.speedX)+fireFlySpeedInc);
     }
   }
/////////////////////////////////////////


  //WINS Point
  //initialize Game stuff happens right after title screen
  if (gameStartQue == 1) {
    //start game screen
    gameRenderLayer = "GameScreen";
    
    //reset  
    scorePlayerOne = 0;
    scorePlayerTwo = 0;
    fireFly.x = width/2;
    fireFly.y = height/2 ;
    fireFly.speedX = 4;
    fireFly.speedY = random(-3,3);
    //reset start que
    gameStartQue = 0;
  }
  
 
}
  
    
   
   
    
class ball {
  float x,y, speedX, speedY;
  float rotation = 0;
  float addHover;
  color ballColor;
  
  //constructor
  ball (float tempX, float tempY, float tempSpeedX, float tempSpeedY) {
    x = tempX;
    y = tempY;
    speedX = tempSpeedX;
    speedY = tempSpeedY;
  }
  
  void drawBall() {
    stroke(10,80,100);
    fill(0,0,0);
    image(fireFlyStill, x, y+addHover);
  }
  
  
  void update() {
    //NEW HOVER EFFECT fireFly style!
    addHover = sin(x/50); //(x/factor of unelongation)
    addHover = addHover*25; //durastify up and down
    
    
    //update rotation
    rotation = sin(rotation) + 1;
    
    //make new color(unused)
    ballColor = color(random(0,255),random(0,255),random(0,255));
   

    //deal with y wall collisions
    if (y < 0) {
      speedY = abs(speedY);
      speedY = speedY + random(-3,3);

    }
     
    //deal with y roof collisions
    if (y > height-fireFlyDiameter) {
      speedY = -1 * abs(speedY);
      speedY = speedY + random(-3,3);

    }

    //deal with x wall collisions///////////////////
    if (x > width) {
      //reverse speed
      speedX = -1 * abs(speedX);
      speedX = speedX + random(-3,3);
      //que counter
      pointEnded = 2; //add to player 2 and score
    }
    
    if (x < 0) {
     //reverse speed
     speedX = abs(speedX);
     speedX = speedX + random(-3,3);
     //que counter
     pointEnded = 1; //add to player 2 and score
    }
    

    //update the location of the ball
    x = x + speedX;
    y = y + speedY;
    
  } 
  
} 






   
class paddle {
  float x, y;
  boolean buttonUp, buttonDown;
  //constructor
  paddle(float tempX, boolean tempButtonUp, boolean tempButtonDown){
    x = tempX;
    y = height/2;
    buttonUp = tempButtonUp;
    buttonDown = tempButtonDown;
  }
  
  void render(){
      image(playerStill,x,y);
  }
  void update(boolean GlobalButtonUp, boolean GlobalButtonDown){
    
    //make the up and down work
      buttonUp = GlobalButtonUp;
      buttonDown = GlobalButtonDown;
      
    
    //if going up 
    if (buttonUp) {
      y -= 4;
      //println("up");
    }


    if (buttonDown) {
      y+= 4;
     // println("down");
    }

  }
  
  
}

void keyPressed() {
if (char(keyCode) == 'W' && isKeyWPressed == false) {
  isKeyWPressed = true;
  println("keyWPRessed");
}
if (char(keyCode) == 'S' && isKeySPressed == false) isKeySPressed = true;
if (char(keyCode) == 'O' && isKeyOPressed == false) isKeyOPressed = true;
if (char(keyCode) == 'K' && isKeyKPressed == false) isKeyKPressed = true;


}

void keyReleased() {
if (char(keyCode) == 'W' && isKeyWPressed == true) isKeyWPressed = false;
if (char(keyCode) == 'S' && isKeySPressed == true) isKeySPressed = false;
if (char(keyCode) == 'O' && isKeyOPressed == true) isKeyOPressed = false;
if (char(keyCode) == 'K' && isKeyKPressed == true) isKeyKPressed = false;

}

    