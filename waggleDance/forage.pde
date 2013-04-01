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

    distance = sqrt( (flowerX-width/2)*(flowerX-width/2) + (flowerY-height/2)*(flowerY-height/2) );
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
  PVector pOrigin = new PVector(width/2, height/2);
  PVector pDestination = new PVector(flowerX, flowerY);

  if ( (abs(flowerX-last.x) < 1) && (abs(flowerY-last.y) < 1) ) {
    if (backHome == false)
      landTime = millis();

    backHome = true;
  }

  if (backHome) {
    if ( (abs(width/2-last.x) < 5) && (abs(height/2-last.y) < 5)) {
      mode = 4;
      float a = height/2-50;
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

