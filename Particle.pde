final class Particle {
  
  public final PVector position, velocity, gravity;
  private float invMass;
  
  Particle(int x, int y, float xVel, float yVel, float diameter) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    invMass = 1/diameter;
    gravity = new PVector(0f, 0.01f);
  }
  
  void integrate() {
    
    // If infinite mass, we don't integrate
    if (invMass <= 0f) { 
      return;
    }
    
    // Stop at ground level
    if(position.y + getDiameter() / 2 >= height - 5) {
      return;
    }
    
    // Inertia
    position.add(velocity);
    
    // Gravity
    PVector acceleration = gravity.get();
    float distance = height - position.y; 
    //acceleration.mult(distance/10);
    
    // update velocity
    velocity.add(acceleration);
  }
  
  float getDiameter() {
    return 1/invMass;
  }
}
