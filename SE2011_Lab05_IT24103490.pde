int state = 0;

int startTime;
int duration = 30;

float px = 350,py = 250;
float vx = 0,vy = 0;

float accel = 0.6;
float friction = 0.90;
float gravity = 0.6;
float jumpForce = -12;

float pR= 20;

int n = 8;

float[] ex = new float[n];
float[] ey = new float [n];
float[] evx = new float[n];
float[] evy = new float[n];

float eR = 15;

int lives =3;

boolean canHit= true;
int lastHitTime = 0;
int hitCooldownMs = 800;

void setup(){
  size(750,350);
  frameRate(60);
  initEnemies();
}
  void draw(){
  background(240);
  
  if(state == 0){
  drawStartScreen();
  }
  else if (state == 1 ){
  runGame();
  }
  else if (state == 2){
  drawGameOver();
  }
  else if ( state == 3){
  drawWinScreen();
  }
 }
 
void drawStartScreen(){
  fill(0);
  textAlign(CENTER);
  textSize(30);
  text("Dodge & Survive", width/2, height/2 -20);
  
  textSize(16);
  text("Press ENTER to Start" , width/2, height/2 + 20);
  
  
}
void runGame(){
  int currentTime = (millis() - startTime) /1000;
  int timeLeft = duration - currentTime;
  
  if(timeLeft <= 0){
    state = 3;
  }
  
  if (keyPressed){
    if (keyCode == RIGHT){
    vx += accel;
  }
    if(keyCode == LEFT){
    vx -= accel;
  }
}

  vx *= friction;
  vy += gravity;
  
  px += vx;
  py += vy;
  
  float groundY = height -40;
   if (py > groundY){
     py = groundY;
     vy = 0;
     }
     
  px = constrain(px,pR, width - pR);
  
  noStroke();
  fill(54,23,111);
  ellipse(px,py,pR*2,pR*2);
  
  for (int i =0 ; i < n; i++){
    ex[i] += evx[i];
    ey[i] += evy[i];
  
    if( ex[i] > width - eR || ex[i]< eR){
        evx[i] *= -1;
    }
    if( ey[i] > height -eR || ey[i] < eR){
        evy[i] *= -1;
    }
    fill(#99D6D0);
    ellipse(ex[i],ey[i],eR*2,eR*2);
    
    float d = dist(px,py,ex[i],ey[i]);
    
    if(d < pR + eR && canHit){
    lives--;
    canHit = false;
    lastHitTime = millis();
    
    println("HIT! Lives left: " + lives);
    
    if (lives <= 0){
       state = 2;
     }
    }
  }
  if(!canHit && millis() - lastHitTime > hitCooldownMs){
    canHit = true;
  }
  fill(0);
  textAlign(LEFT);
  text("Lives: "+ lives , 20,20);
  text("Time left: "+ timeLeft,20,40);
  
  stroke(0);
  line(0,height - 20,width, height- 20);
  
}

  void drawGameOver(){
    fill(0);
    textAlign(CENTER);
    textSize(30);
    text("GAME OVER!!!!" , width/2, height/2);
    
    textSize(17);
    text("Press R to Restart", width/2, height/2 + 40);
   
  }

void drawWinScreen(){
  fill(189);
  textAlign(CENTER);
  textSize(30);
  text("YOU WIN!!!!", width/2, height/2);
  
  textSize(17);
  text("Press R to Restart", width/2, height/2 + 40);
  
}

void keyPressed(){
  if(state == 0 && keyCode == ENTER){
      state =1;
      startTime = millis();
      resetGame();
  }
   if(state == 1 && key == ' '){
      float groundY = height - 40;
      if(py >= groundY){
           vy = jumpForce;
       }
    }
    if((state == 2 || state == 3 ) && (key == 'r' || key == 'R')){
     state = 0;
    }

}
void resetGame(){
    px =  width/2;
    py = height - 40;
    
    vx = 0;
    vy = 0;
    
    lives = 3 ;
    initEnemies();
    
}
void initEnemies(){
    for (int i = 0; i < n; i++){
      
    ex[i] = random (eR, width - eR);
    ey[i] = random (eR, height - eR);
    
    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);
    
    if(abs(evx[i]) < 1){
      evx[i] = 2;
       }
    if(abs(evy[i]) < 1){
      evy[i] = -2;
      }
    
   }  

}
