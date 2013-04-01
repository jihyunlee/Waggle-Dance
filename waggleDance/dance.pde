
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
