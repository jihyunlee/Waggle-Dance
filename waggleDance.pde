
//
// Jihyun Lee
// jihyun.lee@nyu.edu
// www.hellojihyun.com
// www.github.com/jihyunlee

// The Nature of Code - Daniel Shiffman <http://www.shiffman.net>
// Spring 2012, ITP NYU

boolean bHD = false;

import netscape.javascript.*;
JSObject window;

int mode;
PFont font;

Honeybee honeybee;
ArrayList<Honeybee> bees = new ArrayList<Honeybee>();

Attractor a = new Attractor(); // bee is attracted to this position
HScrollbar windScroll;


void setup() {
  if (bHD) size(1920, 1080);
  else    size(1280, 720);

  smooth();
  frameRate(30);
  background(255);  

  mode = 1;

  if (bHD) {
    font = createFont("AmericanTypewriter-Light", 96);
    windScroll = new HScrollbar(20, 50, 200, 20, 3*5+1);
  } 
  else {
    font = createFont("AmericanTypewriter-Light", 45);
    windScroll = new HScrollbar(20, 40, 100, 10, 3*5+1);
  }

  initialization();
}

void draw() {
  switch(mode) {
  case 1: 
    drawIntro(); 
    break;
  case 2: 
    drawHoneycomb(); 
    break;
  case 3: 
    drawForage(); 
    break;
  case 4: 
    drawDance(); 
    break;
  }
}

void drawIntro() {

  background(255);
  fill(0);
  textFont(font);
  textAlign(CENTER);
  if (bHD) {
    text("The Waggle Dance of the Honeybee", width/2, 250);
  } 
  else {
    text("The Waggle Dance of the Honeybee", width/2, 100);
  }

  if (bHD) {
    textFont(font, 56);
    text("Please hit the SPACE BAR to start!", width/2, 900);
  } 
  else {
    textFont(font, 30);
    text("Please hit the SPACE BAR to start!", width/2, 600);
  }

  fill(#999999);
  if (bHD) {
    textFont(font, 28);
    text("The Nature of Code  |   Jihyun Lee", width/2, 1000);
  } 
  else {
    textFont(font, 18);
    text("The Nature of Code  |   Jihyun Lee", width/2, 680);
  }

  strokeWeight(5);
  honeybee.walk();
  honeybee.draw();
}

void initialization() {
  for (int i=bees.size()-1; i>=0; i--) {
    bees.remove(i);
  }

  if (trail != null) {
    if (trail.size()>0) {
      for (int i=trail.size()-1; i>=0; i--) {
        trail.remove(i);
      }
    }
  }

  honeybee = new Honeybee(width/2, height/2);
  bees.add(honeybee);

  bForaging = false;  
  backHome = false;

  flowerX = 0;
  flowerY = 0;

  arcIndex = 0;
  waveIndex = 0;

  bDrawArc = false;
  bDrawCW = false;

  waggleAngle = 0;

  windScroll.reset();
}


class Attractor {

  PVector location;

  Attractor() {
    location = new PVector(width/2, height/2);
  }
  
  void setLocation(float x, float y) {
    location = new PVector(x,y);  
  }

}



class HScrollbar
{
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if(isOver()) {
      over = true;
    } else {
      over = false;
    }
    
    if(mousePressed && over) {
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    
    if(locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    
    if(abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  void display() {
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(153, 102, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }
  
  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean isOver() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  void reset() {
    spos = xpos + swidth/2 - sheight/2;
  }
}

// Random Walker (No Vectors)
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code
// A random walker class!

class Honeybee {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector noff;
  float mass;
  float orientation;
  boolean direction;
  
  ArrayList<PVector> history;
  
  Honeybee(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector(0,0);
    noff = new PVector(random(1000), random(1000));
    mass = 1;
    orientation = random(-180, 180);

    history = new ArrayList<PVector>();
    addToHistory(x, y);
    
    if(orientation >= 0)
      direction = true; // left to right
    else
      direction = false;
      
    if(bees.size() == 0) {
      location.x = width/2;
      location.y = height/2;
      orientation = 0;
      direction = true;      
    }
  }
  
  void addToHistory(float x, float y) {
    PVector v = new PVector(x, y);
    history.add(v);
    location = v;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);  
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void render(boolean d_) {
    direction = d_;
    draw();  
  }
  
  // Randomly move up, down, left, right, or stay in one place
  void walk() {
    
    for(int i=0; i<history.size(); i++) {
      PVector vel = new PVector(random(-2,2),random(-2,2));
      PVector t = history.get(i);
      t.add(vel);
    
      // Stay on the screen
      t.x = constrain(t.x,-width/2,width-1);
      t.y = constrain(t.y,-height/2,height-1);
    }
    
    if(history.size() > listMax) {
      history.remove(0);
    }
  }

  void walk(PVector origin, PVector dest) {
    PVector k = new PVector(random(-1,1), random(-1,1));
    k.normalize();
    k.mult(random(2));
    applyForce(k);
    
    PVector temp = PVector.sub(origin, dest); 
    velocity.add(temp);
    velocity.normalize();
    velocity.mult(-2);
     
    location.add(velocity);
    
    location.x = constrain(location.x, min(origin.x, dest.x), max(origin.x, dest.x));
    location.y = constrain(location.y, min(origin.y, dest.y), max(origin.y, dest.y));

    addToHistory(location.x, location.y);

    if(history.size() > listMax) {
      history.remove(0);
    }

    if(origin.x < dest.x) {
      direction = true;
    } else {
      direction = false;
    }
  }
  
  void draw() {

    pushMatrix();
    if(orientation != 0)
      rotate(PI/orientation);
    translate(location.x, location.y);
    
    // head & tail
    if(direction == true) { // left -> right
      stroke(0);
      line(-35-4, 0, -35, 1);
      fill(255);
      ellipse(35, 0, 15, 15);
    } else {
      stroke(0);
      line(35, 0, 35+4, 1);
      fill(255);
      ellipse(-35, 0, 15, 15);
    }
    
    
    // body
    fill(#fdd017);
    ellipse(0, 0, 70, 40);
    fill(0);
    rect(-15, -17, 8, 34);
    rect(+11, -16, 8, 32);

    // wing
    noStroke();
    fill(#ffffff, 130); 
    if(direction == true) {
      rotate(PI/3);
      ellipse(15, 5, 25, 50);
      rotate(-PI/3*2);
      ellipse(15, -5, 25, 50);
    } else {
      rotate(-PI/3*2);   
      ellipse(15, 5, 25, 50);
      rotate(PI/3);
      ellipse(-15, 5, 25, 50);      
    }

    popMatrix();    
  }  

}

ArrayList<PVector> trail = new ArrayList<PVector>();


int listMax = 1200;

int arcIndex = 0;
int waveIndex = 0;

boolean bDrawArc = false;
boolean bDrawCW = false;

float waggleAngle = 0;

float foodTheta = 0;

void drawDance() {
  drawBackgroundHexagons();

  for(int i=1; i< bees.size(); i++) {
    Honeybee b = bees.get(i);
    b.walk();
    b.draw();
  }
  
  pushMatrix();
  translate(width/2, height/2);
  float ta = random(-5,5);
  if(flowerX < width/2)
    rotate(3*PI/2 - foodTheta);
  else
    rotate(3*PI/2 + foodTheta);
    
  honeybee.walk();
  honeybee.draw();
  
  popMatrix();
  
  fill(255, 255, 255, 70);
  rect(0,0,width,height);
  
  float offsetX = (width - duration)/2;
  float offsetY = height/2;
  
  noStroke();
  fill(0, 180);
  if (bHD) {
    rect(0, height-120, width, 100);
  } 
  else {
    rect(0, height-50, width, 40);
  }
  fill(color(255));
  textAlign(LEFT, CENTER);

  if (bHD) {
    textFont(font, 48);
    text("He shares information about the food source with his friends when back home.", 50, height-75);
  } else {
    textFont(font, 20);
    text("He shares information about the food source with his friends when back home.", 40, height-30);
  }

  pushMatrix();
  translate(width/2, height/2);
  if(flowerX < width/2)
    rotate(3*PI/2 - foodTheta);
  else
    rotate(3*PI/2 + foodTheta);
  
  drawArrow();
  drawReturnPhase();
  drawWagglePhase();  
  
  popMatrix();
}


void drawWagglePhase() {  
  if(bDrawArc == true)
    return;
  
  float amplitude = 17;
  float frequency = PI/30; 
  float posy = sin(waggleAngle)*amplitude;
  waggleAngle += frequency/2;    

  addList(waveIndex, posy);
  
  waveIndex++;
  if(waveIndex > duration) {
    bDrawArc = true;
    waveIndex = 0;
    waggleAngle = 0;
  }  
}

void drawReturnPhase() {  
  if(bDrawArc == false)
    return;
  
  int r = duration/2;
  float posy = sqrt(r*r - (r-arcIndex)*(r-arcIndex));
  posy = posy/2;
  if(bDrawCW == false)
    posy = -posy;

  addList(arcIndex, posy);
  
  arcIndex--;
  if(arcIndex<0) {
    bDrawArc = false;
    bDrawCW = !(bDrawCW);
    arcIndex = duration;
  }
}

void addList(float x, float y) {
  PVector pt = new PVector(x, y);    
  trail.add(pt);
 
  for(int j=trail.size()-1; j>=0; j-=3) {
      PVector ptDraw = trail.get(j);
      if(ptDraw != null) {
        stroke(255,255,255);
        point(ptDraw.x, ptDraw.y);
      }
  }
  
  honeybee.addToHistory(x, y);
  honeybee.walk();

  if(bDrawArc == true)
    honeybee.render(false);
  else
    honeybee.render(true);  
  
  if(trail.size() > listMax)
    trail.remove(0); 
}

void drawArrow() {
  strokeWeight(5);
  stroke(255,0,0);
  line(0,0,duration, 0);
  line(duration, 0, duration - 15, -15);
  line(duration, 0, duration - 15, 15);
}

void drawHiveFriends(float x, float y) {
  stroke(0);
  line(x-35-4, y, x-35, y+1);
  fill(255);
  ellipse(x+35, y, 15, 15);
    
  fill(#fdd017);
  ellipse(x, y, 70, 40);
  fill(0);
  rect(x-15, y-17, 8, 34);
  rect(x+11, y-16, 8, 32);       
}
int flowerX=0;
int flowerY=0;
float distance=0; // distance from flower to hive
int duration=0; // how many cycle bee goes

boolean bForaging = false;
int trailX;
int trailY;

boolean backHome = false;
float landTime = 0;
float angle=0;

float hiveWidth = 80;

void drawForage() {

  background(255);
  noStroke();
  fill(#82caff);
  rect(0, 0, width, 150);
  fill(#c3fdb8);
  rect(0, 150, width, height-150);

  noStroke();
  fill(0, 180);
  if (bHD) {
    rect(0, height-120, width, 100);
  } 
  else {
    rect(0, height-50, width, 40);
  }

  fill(color(255));
  textAlign(LEFT, CENTER);

  if (bHD) {
    textFont(font, 48);
    if (!bForaging) {
      text("Place a flower for a scout bee and knock his door to get him out.", 50, height-75);
    } 
    else {
      text("Help the bee flying by controling speed and direction of the wind on the left top.", 50, height-75);
    }
  } 
  else {
    textFont(font, 20);
    if (!bForaging) {
      text("Place a flower for a scout bee and knock his door to get him out.", 40, height-35);
    } 
    else {
      text("Help the bee flying by controling speed and direction of the wind on the left top.", 40, height-35);
    }
  }

  stroke(2);
  drawHive();
  drawSun();
  drawFlower();
   
  if (bForaging == true) {
    drawBee();  

    fill(color(#666666));
    
    if(bHD) {
      textFont(font, 28);
      text("wind", 20, 20);
    } else {
      textFont(font, 16);
      text("wind", 20, 20);
    }
  
    noStroke();  
    windScroll.update();
    windScroll.display();
  }
}

void drawHive() {

  float hiveHeight = -70;
  float posy = 0;
  
  // arc
  beginShape();
  fill(#fdd017);
  for (int theta=0; theta<=hiveWidth; theta++) {
    posy = sin(theta*PI/hiveWidth)*hiveHeight+height/2;
    vertex(theta+(width-hiveWidth)/2, posy);
  }
  endShape(CLOSE);

  // door
  fill(0);
  rect((width-20)/2, height/2-20, 20, 20);
  line((width-hiveWidth)/2, height/2, (width+hiveWidth)/2, height/2);
}

void drawSun() {
  noStroke();
  fill(#f87431);
  ellipse(width/2, 50, 60, 60);
  stroke(2);
}

void drawFlower() {
  if (flowerX == 0 && flowerY==0) {
    flowerX = width/4;
    flowerY = 3*height/8;

    distance = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-450)*(flowerY-450) );
    duration = int(map(distance, 0, 540, 0, 360));
    arcIndex = duration;
  }

  int r = 40;  
  fill(#00ff00);
  rect(flowerX-7, flowerY+r, 14, 100);
  fill(#ff0000);
  ellipse(flowerX, flowerY-r, r, r);
  ellipse(flowerX+r, flowerY-r/2, r, r);
  ellipse(flowerX+r, flowerY+r/2, r, r);
  ellipse(flowerX, flowerY+r, r, r);
  ellipse(flowerX-r, flowerY-r/2, r, r);
  ellipse(flowerX-r, flowerY+r/2, r, r);
  fill(#ffff00);
  ellipse(flowerX, flowerY, 2*r, 2*r);
}

void drawBee() {
  PVector last = honeybee.history.get(honeybee.history.size()-1);
  PVector pOrigin = new PVector(width/2, 450);
  PVector pDestination = new PVector(flowerX, flowerY);

  if ( (abs(flowerX-last.x) < 1) && (abs(flowerY-last.y) < 1) ) {
    if (backHome == false)
      landTime = millis();

    backHome = true;
  }

  if (backHome) {
    if ( (abs(width/2-last.x) < 5) && (abs(height/2-last.y) < 5)) {
      mode = 4;
      float a = 400;
      float b = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-height/2)*(flowerY-height/2) );
      float c = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-50)*(flowerY-50) );
      foodTheta = acos((a*a + b*b -c*c) / (2*a*b));       
      return;
    } 
    else {
      if (millis() - landTime > 2000) {
        pOrigin = new PVector(flowerX, flowerY);
        pDestination = new PVector(width/2, height/2);
      }
    }
  }

  float pos = windScroll.getPos();
  
  PVector wind = new PVector((pos-(windScroll.xpos + windScroll.swidth/2))/5, 0);
  honeybee.applyForce(wind);

  honeybee.walk(pOrigin, pDestination);
  honeybee.update();
  if (pDestination.x > pOrigin.x)
    honeybee.render(true);
  else
    honeybee.render(false);
}


float r = 28;
float lineLength = 0;

void drawHoneycomb() {

  drawBackgroundHexagons();

  // draw Honeybee
  for (Honeybee b:bees) {
    b.walk();
    b.draw();
  }

  noStroke();
  fill(0, 180);
  if (bHD) {
    rect(0, height-120, width, 100);
  } 
  else {
    rect(0, height-50, width, 40);
  }

  fill(color(255));
  textAlign(LEFT, CENTER);

  if (bHD) {
    textFont(font, 48);
    text("Press 'a' key to add honeybee friends and hit the 'SPACE BAR' to start to forage!", 50, height-75);
    //    text("Press 'UP(↑)' key to gather bee friends and hit 'SPACE BAR' to start to forage!", 50, height-75);
  } 
  else {
    textFont(font, 20);
    text("Press 'a' key to add honeybee friends and hit the 'SPACE BAR' to forage", 40, height-35);
  }
}

void drawBackgroundHexagons() {  
  stroke(0);
  strokeWeight(5);

  fill(#E8A317);

  lineLength = sqrt( (r * r) - (r/2 * r/2) );

  int i = 1;
  pushMatrix();  
  for (int k=1; k<=((height/(2*lineLength))+2); k++) { 
    for (int j=1; j<=2; j++) {
      for (i=1; i<=((width/(3*r))+3); i++) {
        drawHexagon();
        translate(r*3, 0);
      }
      translate(-(i*r*3), 0);
      translate(r+r/2, lineLength);
    }
    translate(3*r, 0);
  }
  popMatrix();
}

void drawHexagon() {
  beginShape();
  float angle = 0;
  for (int v=0; v<6; v++) {
    vertex(cos(angle)*r, sin(angle)*r);
    angle += (TWO_PI/6.0);
  }
  endShape(CLOSE);
}


void keyPressed(){
  switch(key) {
    case ' ': {
      mode++;
      if(mode == 4) {
        initialization();
        
        // sun(300,50), hive(300,450)
        // a : sun & hive
        // b : hive & flower
        // c : sun & flower
        
        // cos C = (a*a + b*b -c*c) / 2*a*b
        
        float a = 400;
        float b = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-height/2)*(flowerY-height/2) );
        float c = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-50)*(flowerY-50) );
        
        foodTheta = acos((a*a + b*b -c*c) / 2*a*b);
      }
      if(mode > 4) {
        mode = 1;
        initialization();      
      }
    } break;
    case 'a':
    case 'A': {
      Honeybee bee = new Honeybee(random(0,width), random(0,height));
      bees.add(bee);      
    } break;
    case CODED: {
      if(mode == 2) {
        if(keyCode == UP) {
          Honeybee bee = new Honeybee(random(0,width), random(0,height));
          bees.add(bee);
        }
      }       
    } break;     
  }
}

void mouseReleased() {
  if(mode == 3) { // forage  
    rect((width-20)/2, height/2-20, 20, 20);
      
    if((mouseX >= (width-hiveWidth)/2 && mouseX <= (width+hiveWidth)/2) && (mouseY >=height/2-70 && mouseY <= height/2)) {
      
    } else {
      if(bForaging == false) {
        flowerX = mouseX;
        flowerY = mouseY;
        a.setLocation(flowerX, flowerY);
        
        distance = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-height/2)*(flowerY-height/2) );       
        duration = int(map(distance, 0, 540, 0, 360));
        arcIndex = duration;
      }
    }
  }   
}

void mouseClicked() {
  if(mode == 3) { // forage  
    rect((width-20)/2, height/2-20, 20, 20);
      
    if((mouseX >= (width-hiveWidth)/2 && mouseX <= (width+hiveWidth)/2) && (mouseY >=height/2-70 && mouseY <= height/2)) {
      // start to forage
      bForaging = true;
    }
  } 
}

void mouseDragged() {
  if(mode == 3) { // forage
    if(bForaging == false) {
      flowerX = mouseX;
      flowerY = mouseY;
    }
  }  
}

