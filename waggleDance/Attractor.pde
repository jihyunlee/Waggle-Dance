
class Attractor {

  PVector location;

  Attractor() {
    location = new PVector(width/2, height/2);
  }
  
  void setLocation(float x, float y) {
    location = new PVector(x,y);  
  }

}


