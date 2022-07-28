int numBalls = 5;
float bounce = 0.25;
int ballsize = 40;
Ball[] balls = new Ball[numBalls];

void setup() {
  size(640, 640);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball( random(width), random(height), random(80,80), i, balls);
  }
  noStroke();
  fill(255, 204);
}

void draw() {
  background(0);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
  }
}

class Ball {
  
  float x, y, xSpeed, ySpeed;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
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
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      vx*=-1;
      x = width - diameter/2;

    }
    else if (x - diameter/2 < 0) {
      vx*=-1;
      x = diameter/2;
    }
    if (y + diameter/2 > height) {
      vy*=-1;
      y = height - diameter/2;
    } 
    else if (y - diameter/2 < 0) {
      vy*=-1;
      y = diameter/2;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
