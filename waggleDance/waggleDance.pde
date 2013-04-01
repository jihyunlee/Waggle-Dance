
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

