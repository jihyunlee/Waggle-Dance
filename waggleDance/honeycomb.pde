
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

