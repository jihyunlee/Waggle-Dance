
// Jihyun Lee < jihyun.lee@nyu.edu >
// The Nature of Code


import netscape.javascript.*;
JSObject window;

int mode;
PFont font;

Walker honeybee = null;

HScrollbar windScroll; //, gravityScroll;

/* @pjs globalKeyEvents ="true"; */


void setup() {
  
  size(600, 600);
  smooth();
  frameRate(30);
  background(255);  
  font = createFont("FFScala", 45);
  
  mode = 1;
  
  honeybee = new Walker(300, 300);
  honeybee.addToHistory(300,300);


  windScroll = new HScrollbar(10,20,100,5,3*5+1);
//  gravityScroll = new HScrollbar(10,30, 100, 5, 3*5+1);
}

void draw() {
  switch(mode) {
    case 1: 
    { 
      initialization();
      drawIntro();
    }  break;
    case 2: drawHoneycomb(); break;
    case 3: drawForage(); break;
    case 4: drawDance(); break;
  }
}

void drawIntro() {
  
  background(255);
  fill(0);
  textFont(font);
  text("The Waggle Dance", 100, 100);
  text("of the Honeybee", 130, 160);
  
  textFont(font, 30);
  text("Please hit the SPACE BAR to start!", 60, 420);
  
  fill(#666666);
  textFont(font, 20);
  text("Nature of Code  |   Jihyun Lee", 260, 550);
  
  strokeWeight(5);
  honeybee.walk();
  honeybee.render(0, 1, false, true);
}

void initialization()
{
  if(honeybee != null)
  {
    honeybee.clearHistory();
  }
  
  if(trail != null)
  {
    if(trail.size()>0)
    {
      for(int i=0; i<trail.size(); i++)
      {
        trail.remove(i);
      }
    }
  }
  
  honeybee = new Walker(width/2, height/2);
  honeybee.addToHistory(width/2, height/2);
  
  bForaging = false;  
  backHome = false;
  
  flowerX = 0;
  flowerY = 0;
  
  arcIndex = 0;
  waveIndex = 0;
  
  bDrawArc = false;
  bDrawCW = false;
  
  waggleAngle = 0;
}

// Attraction
// Daniel Shiffman <http://www.shiffman.net>

// A class for a draggable attractive body in our world

class Attractor {
  float mass;    // Mass, tied to size
  float G;       // Gravitational Constant
  PVector location;   // Location
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?
  PVector drag;  // holds the offset for when object is clicked on

  Attractor() {
    location = new PVector(width/2, height/2);
    mass = 20;
    G = 1;
    drag = new PVector(0.0,0.0);
  }
  void setLocation(float x, float y) {
    location = new PVector(x,y);  
  }
  
  PVector attract(Walker w) {
    PVector force = PVector.sub(location,w.location);   // Calculate direction of force
    float d = force.mag();                              // Distance between objects
    d = constrain(d,5.0,25.0);                        // Limiting the distance to eliminate "extreme" results for very close or very far objects
    force.normalize();                                  // Normalize vector (distance doesn't matter here, we just want this vector for direction)
    float strength = (G * mass * w.mass) / (d * d);      // Calculate gravitional force magnitude
    force.mult(strength);                                  // Get force vector --> magnitude * direction
    return force;
  }

  // Method to display
  void display() {
    ellipseMode(CENTER);
    stroke(0);
    if (dragging) fill (50);
    else if (rollover) fill(100);
    else fill(175,200);
    ellipse(location.x,location.y,mass*2,mass*2);
  }

  // The methods below are for mouse interaction
  void clicked(int mx, int my) {
    float d = dist(mx,my,location.x,location.y);
    if (d < mass) {
      dragging = true;
      drag.x = location.x-mx;
      drag.y = location.y-my;
    }
  }

  void rollover(int mx, int my) {
    float d = dist(mx,my,location.x,location.y);
    if (d < mass) {
      rollover = true;
    } 
    else {
      rollover = false;
    }
  }

  void stopDragging() {
    dragging = false;
  }



  void drag() {
    if (dragging) {
      location.x = mouseX + drag.x;
      location.y = mouseY + drag.y;
    }
  }

}



ArrayList<PVector> trail = new ArrayList<PVector>();
ArrayList<Walker> hiveFriends = new ArrayList<Walker>();

int listMax = 1000;

int arcIndex = 0;
int waveIndex = 0;

boolean bDrawArc = false;
boolean bDrawCW = false;

float waggleAngle = 0;

float foodTheta = 0;

void drawDance() {

  drawBackgroundHexagons();
  
  pushMatrix();
  translate(width/2, height/2);
  float ta = random(-5,5);
  if(flowerX < width/2)
    rotate(3*PI/2 - foodTheta);
  else
    rotate(3*PI/2 + foodTheta);
    
  for(int i=0; i< hiveFriends.size(); i++)
  {
    hiveFriends.get(i).walk();
    hiveFriends.get(i).render(0,1,false,true);
  }
  popMatrix();
  
  fill(255, 255, 255, 127);
  rect(0,0,width,height);
  
  float offsetX = (width - duration)/2;
  float offsetY = height/2;
   
  textFont(font, 13); 
  noStroke();
  fill(0);
  rect(40, height-90, width-80, 65);
  fill(color(255));
  textFont(font, 20);
  text("The honeybee share with hive friends information ", 55 , height-65);
  text("about the direction and distance to the food source.", 55, height-40);

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
  if(waveIndex > duration)
  {
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
  if(arcIndex<0)
  {
    bDrawArc = false;
    bDrawCW = !(bDrawCW);
    arcIndex = duration;
  }
}

void addList(float x, float y) {
  PVector pt = new PVector(x, y);    
  trail.add(pt);
 
  for(int j=trail.size()-1; j>=0; j--) {
      PVector ptDraw = trail.get(j);
      if(ptDraw != null)
      {
        stroke(255,255,255);
        point(ptDraw.x, ptDraw.y);
      }
  }
  
  honeybee.addToHistory(x, y);
    honeybee.walk();

    if(bDrawArc == true)
    {
      honeybee.render(false);
    }
    else
    {
      honeybee.render(true);
    }  
  
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
Attractor a = new Attractor();


void drawForage() {
  
  background(255);
  noStroke();
  fill(#82caff);
  rect(0,0,width,150);
  fill(#c3fdb8);
  rect(0,150,width,height-150);
 
  color textColor = color(#666666);
  fill(textColor);
  textFont(font, 13);
  text("wind", 120,25);
  
  noStroke();
  fill(0);
  rect(40, height-90, width-80, 65);
  textColor = color(255);
  fill(textColor);
  textFont(font, 20);
  text("Place a flower for a scout bee and knock his door.", 60 , height-65);
  text("And then control speed and direction of wind.", 60 , height-40);
  
  stroke(2);
  drawHive();
  drawSun();
  drawFlower();
    
  if(bForaging == true)
    drawBee();  
  
  noStroke();  
  windScroll.update();
  windScroll.display();

//  gravityScroll.update();
//  gravityScroll.display();
}

void drawHive() {

  float amplitude = -70;
  float frequency = PI/30; 
  float posy = 0;
  
  beginShape();
  fill(#fdd017);
  for(int theta=0; theta<=60; theta++) {
    posy = sin(theta*PI/60)*amplitude+450;
    vertex(theta+(width-60)/2, posy);
    angle += frequency/2;    
  }
  endShape(CLOSE);

  line((width-60)/2, 450, (width+60)/2, 450);
  
  fill(0);
  rect((width-20)/2, 450-20, 20, 20);
}

void drawSun() {
  noStroke();
  fill(#f87431);
  ellipse(width/2, 50, 60, 60);
  stroke(2);
}

void drawFlower() {
  if(flowerX == 0 && flowerY==0)
  {
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
    
  if(flowerX == last.x && flowerY == last.y)
  {
      if(backHome == false)
        landTime = millis();
      
      backHome = true;      
  }

  if(backHome)
  {
    if(last.x == width/2 && last.y == 450)
    {
      mode = 4;
        float a = 400;
        float b = sqrt( (flowerX-300)*(flowerX-300) + (flowerY-450)*(flowerY-450) );
        float c = sqrt( (flowerX-300)*(flowerX-300) + (flowerY-50)*(flowerY-50) );
        foodTheta = acos((a*a + b*b -c*c) / (2*a*b));      
    
      for(int i=0; i<80; i++)
      {
        float tempX = random(-width,width);
        float tempY = random(-height,height);
        Walker friend = new Walker(tempX, tempY);
        friend.addToHistory(tempX, tempY);
        hiveFriends.add(friend);
        
      }    
      return;
    }
    else
    {
      if(millis() - landTime > 3000)
      {
        pOrigin = new PVector(flowerX, flowerY);
        pDestination = new PVector(width/2, 450);
      }
      else
      {
  //      PVector force = a.attract(honeybee);
//        honeybee.applyForce(force);
//        honeybee.update();
  //      honeybee.render(true);
    //    return;
      }
    }
  }

  float pos = windScroll.getPos();
  PVector wind = new PVector((pos-60)/5, 0);
//  PVector gravity = new PVector(0, 1);
  honeybee.applyForce(wind);
//  honeybee.applyForce(gravity);
    
  honeybee.walk(pOrigin, pDestination);
  honeybee.update();
  if(pDestination.x > pOrigin.x)
    honeybee.render(true);
  else
    honeybee.render(false);  
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

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}


float r = 28;
float lineLength = 0;

void drawHoneycomb() {
  
  drawBackgroundHexagons();
  
  // draw Honeybee
  honeybee.walk();
  honeybee.render(honeybee.history.size(), honeybee.history.size(), true, true);
 
  noStroke();
  fill(0);
  rect(32, height-70, width-64, 40);
  color textColor = color(255);
  fill(textColor);
  textFont(font, 20);
  text("Press 'G or g' to gather bees and 'SPACE BAR' to forage", 40, height-45);
}

void drawBackgroundHexagons() {  
  stroke(0);
  strokeWeight(5);

  fill(#E8A317);
  
  lineLength = sqrt( (r * r) - (r/2 * r/2) );
  
  int i = 1;
  pushMatrix();  
  for (int k=1; k<=((height/(2*lineLength))+1); k++) { 
    for (int j=1; j<=2; j++) {
      for (i=1; i<=((width/(3*r))+3); i++) {
        drawHexagon();
        translate(r*3,0);
      }
      translate(-(i*r*3),0);
      translate(r+r/2,lineLength);
    }
    translate(3*r,0);
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

// Random Walker (No Vectors)
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code
// A random walker class!

class Walker {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector noff;
  float mass;
  
  ArrayList<PVector> history;
  

  Walker(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector(0,0);
    noff = new PVector(random(1000), random(1000));
    history = new ArrayList<PVector>();
    mass = 1;
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
  
  void render(boolean direction) {   
    drawBee(location.x, location.y, direction);     
  }
  void renderTrail() {
      beginShape();
    stroke(0);
    noFill();
 
    for (int i=history.size()-1; i>=0; i--) {
   
      PVector v = history.get(i);
      if(v != null)
      {

        {
          point(v.x, v.y);
          //point(v.x, v.y);
        }   
      }  

    }
    endShape();    
  }
  
  void render(int lastIndex, int trailLength, boolean drawAllHistory, boolean direction) {
    
    beginShape();
    stroke(0);
    noFill();
 
    for (int i=lastIndex-1; i>=0; i--) {
   
      PVector v = history.get(i);
      if(v != null)
      {
        if(drawAllHistory)
        {         
          drawBee(v.x, v.y, direction);
        }
        else
        {
          point(v.x, v.y);
          //point(v.x, v.y);
        }   
      }  
      else
      {
        println(" vector is null!!!!!!!!!!");
      } 
    }
    endShape();
    
    drawBee(location.x, location.y, direction);   
  }

  // Randomly move up, down, left, right, or stay in one place
  void walk() {
    
    for(int i=0; i<history.size(); i++)
    {
      PVector vel = new PVector(random(-2,2),random(-2,2));
      PVector t = history.get(i);
      t.add(vel);
    
      // Stay on the screen
      t.x = constrain(t.x,-width/2,width-1);
      t.y = constrain(t.y,-height/2,height-1);
    }
    
    if(history.size() > 1000)
    {
      history.remove(0);
    }
  }
  
  void walk(PVector origin, PVector dest) {
 /*
    acceleration = new PVector(random(-1,1), random(-1,1));
    acceleration.normalize();
    acceleration.mult(random(2));
 */
    PVector k = new PVector(random(-1,1), random(-1,1));
    k.normalize();
    k.mult(random(2));
    applyForce(k);
    
    PVector temp = PVector.sub(origin, dest); 
    velocity.add(temp);
    velocity.normalize();
    velocity.mult(-2);
     
 //   velocity.add(acceleration);
 //   velocity.limit(3);      
    
    location.add(velocity);
    
    location.x = constrain(location.x, min(origin.x, dest.x), max(origin.x, dest.x));
    location.y = constrain(location.y, min(origin.y, dest.y), max(origin.y, dest.y));

    addToHistory();
    
    if(history.size() > 1000)
    {
      history.remove(0);
    }    
  }
  
  void addToHistory() {
    history.add(location.get());
  }
  
  void addToHistory(float x, float y) {
    PVector v = new PVector(x, y);
    history.add(v);
    location = v;
  }
  
  void clearHistory() {
    for(int i=0; i<history.size(); i++)
    {
      history.remove(i);
    }
  }
  
  
    
  void drawBee(float x, float y, boolean direction) {
    stroke(0);
    if(direction == true) // left -> right
    {
      line(x-35-4, y, x-35, y+1);
      fill(255);
      ellipse(x+35, y, 15, 15);
    }
    else
    {
      line(x+35, y, x+35+4, y+1);
      fill(255);
      ellipse(x-35, y, 15, 15);
    }
    
    fill(#fdd017);
    ellipse(x, y, 70, 40);
    fill(0);
    rect(x-15, y-17, 8, 34);
    rect(x+11, y-16, 8, 32);    
  }
  
}

void keyPressed(){
  switch(key) {
    case ' ':
    {
      mode++;
      if(mode == 3)
      {
        honeybee.clearHistory();
        honeybee.addToHistory(width/2, 450);
      }
      if(mode == 4)
      {
        initialization();
        
        // sun(300,50), hive(300,450)
        // a : sun & hive
        // b : hive & flower
        // c : sun & flower
        
        // cos C = (a*a + b*b -c*c) / 2*a*b
        
        float a = 400;
        float b = sqrt( (flowerX-300)*(flowerX-300) + (flowerY-450)*(flowerY-450) );
        float c = sqrt( (flowerX-300)*(flowerX-300) + (flowerY-50)*(flowerY-50) );
        
        foodTheta = acos((a*a + b*b -c*c) / 2*a*b);
      }
      if(mode > 4)
      {
        mode = 1;
        initialization();      
      }
    }
     break;
    case 'g':
    case 'G':
    {
       if(mode == 2)
      {
        honeybee.addToHistory(random(0,width), random(0,height));
      }    
    }   
      break;
    case CODED:
    {
      if(mode == 2)
      {
        if(keyCode == UP)
        {
          honeybee.addToHistory(random(0,width), random(0,height));
        }
        /*
        else if(keyCode == DOWN)
        {
          if(bees.size() > 0)
            bees.remove(0);
        }
        */
      }       
    }
     break;
     
  }
}

void mouseReleased() {
  if(mode == 3)  // forage
  {
      rect((width-20)/2, 450-20, 20, 20);
      
    if((mouseX >= (width-60)/2 && mouseX <= (width+60)/2) && (mouseY >=450-70 && mouseY <= 450))
    {
    }
    else
    {
      if(bForaging == false)
      {
        flowerX = mouseX;
        flowerY = mouseY;
        a.setLocation(flowerX, flowerY);
        
        distance = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-450)*(flowerY-450) );       
        duration = int(map(distance, 0, 540, 0, 360));
        arcIndex = duration;
      }
    }
  }   
}

void mouseClicked() {
  if(mode == 3)  // forage
  {
    rect((width-20)/2, 450-20, 20, 20);
      
    if((mouseX >= (width-60)/2 && mouseX <= (width+60)/2) && (mouseY >=450-70 && mouseY <= 450))
    {
      // start to forage
      bForaging = true;
    }
  } 
}

void mouseDragged() {
  if(mode == 3)  // forage
  {
    if(bForaging == false)
    {
      flowerX = mouseX;
      flowerY = mouseY;
    }
  }  
}

