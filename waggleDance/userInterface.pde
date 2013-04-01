
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
    case 's': {
      saveFrame("bee.png");
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
