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
