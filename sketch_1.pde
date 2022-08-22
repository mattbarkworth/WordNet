int numBalls = 5;
int maxBalls = 26;
float bounce = 0.25;
int ballColor = color(100,200 ,150 );
Ball[] balls = new Ball[maxBalls];
int ballSize = 50;
int circle =0;
int ballselectcolor = color(0, 255, 0);

void setup() {
  size(1000, 700);
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball( random(width), random(height), ballSize, i, balls);
  }
  noStroke();
  fill(255);
  frameRate(100);
  thread("Makeball");
}
void draw() {
  background(0);
  // repeatedly calls each program from class ball to display them on screen
  for (int i = 0; i < numBalls; i++) {
    balls[i].collide();
  }
  for (int i = 0; i < numBalls; i++) {
    balls[i].move();
  }
  for (int i = 0; i < numBalls; i++) {
    balls[i].drawNet();
  }
  for (int i = 0; i < numBalls; i++) {
    balls[i].display();
  }
  for (int i = 0; i < numBalls; i++) {
    stroke(255);
    balls[i].letters();
  }
  text(frameRate, 100, 100);
  String str = new String(balls[0].word);
  text(str, 200, 200);
}

class Ball {
  float x, y;
  float diameter;
  float xVelocity = random(0, 1);
  float yVelocity = random(0, 1);
  int id;
  char letters = char(int(random(97, 123)));
  boolean selected = false;
  char[] word = new char[0];
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
    } else if (x - diameter/2 < 0) {
      xVelocity*=-1;
      x = diameter/2;
    }
    if (y + diameter/2 > height) {
      yVelocity*=-1;
      y = height - diameter/2;
    } else if (y - diameter/2 < 0) {
      yVelocity*=-1;
      y = diameter/2;
    }
  }
  void display() {
    fill(255);
    ellipse(x, y, diameter, diameter);
  }
  void drawNet() {
    stroke(0, 200, 200);
    for (int i=0; i<numBalls; i++) {
      for (int j=i+1; j<numBalls; j=j+1)
        line(balls[i].x, balls[i].y, balls[j].x, balls[j].y);
    }
  }

  void letters() {
    textAlign(CENTER, CENTER);
    fill(255, 0, 0);
    textSize(30);
    text(letters, x, y);
  }
}



void keyPressed() {
  // checks if the all matches with what the user inputs and changes boolean selected to true and balls[0].word being an arrays of characters
  // then adding the selected balls letter to the array
  for (int i = 0; i < numBalls; i++) {
    if (key== balls[i].letters && !balls[i].selected) {
      balls[i].selected = true;
      balls[0].word = append(balls[0].word, balls[i].letters);
      break;
    }
  }
   for (int i = 0; i < numBalls; i++) {
  if (key==BACKSPACE && balls[0].word.length != 0 ) {

    
    balls[i].selected = false;  
    balls[0].word = shorten(balls[0].word);
  }
   }
}

void Makeball() {
  int i = 26;
  while (i>numBalls) {
    delay(5000);
    balls[numBalls] = new Ball( random(width), random(height), ballSize, numBalls, balls);
    numBalls++;
  }
}

