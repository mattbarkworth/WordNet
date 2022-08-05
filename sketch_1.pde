int numBalls = 5;
int maxBalls = 35;
float bounce = 0.25;
int ballColor = color(255,255,255);
Ball[] balls = new Ball[maxBalls];
int ballSize = 50;
void setup() {
  size(500, 500);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball( random(width), random(height), ballSize, i, balls);
    balls[i].letters= char(int(random(97,123)));
  }
  noStroke();
  fill(255);
  frameRate(100);
  thread("makeBall");
}
void draw() {
  background(0);
  for (int i = 0; i < numBalls; i++) {
    balls[i].collide();
    balls[i].move();
    balls[i].display(); 
    balls[i].drawNet();
    fill(ballColor);
  }
}

class Ball {
  float x, y;
  float diameter;
  float xVelocity = random(0,1);
  float yVelocity = random(0,1);
  int id;
  char letters = char(int(random(97,123))); ;
  Ball[] others;
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
   //balls[numBalls].letters= char(int(random(97,123)));
  } 
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * bounce;
        float ay = (targetY - others[i].y) * bounce;
        xVelocity -= ax;
        yVelocity -= ay;
        others[i].xVelocity += ax;
        others[i].yVelocity += ay;
      }
    }   
  }
  void move() {
    x += xVelocity;
    y += yVelocity;
    if (x + diameter/2 > width) {
      xVelocity*=-1;
      x = width - diameter/2;
    }
    else if (x - diameter/2 < 0) {
      xVelocity*=-1;
      x = diameter/2;
    }
    if (y + diameter/2 > height) {
      yVelocity*=-1;
      y = height - diameter/2;
    } 
    else if (y - diameter/2 < 0) {
      yVelocity*=-1;
      y = diameter/2;
    }
  }
 
  void display() {
    ellipse(x, y, diameter, diameter);
  }
  
 void drawNet(){
   stroke(255);
   for (int i=0; i<numBalls; i++){
    for (int j=i+1; j<numBalls; j=j+1)     
     line(balls[i].x,balls[i].y, balls[j].x, balls[j].y);
      
    }
   }
  }
  void makeBall(){
    delay(3000);
    numBalls=numBalls+1;
     balls[numBalls] = new Ball( random(width), random(height), ballSize, numBalls, balls);
  }
