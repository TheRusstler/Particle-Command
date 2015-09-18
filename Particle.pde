class Particle 
{
  
  final PVector position, velocity, gravity;
  final float diameter;
  
  boolean stopped;
  
  Particle(int x, int y, float xVel, float yVel, float diameter) 
  {
    this.position = new PVector(x, y);
    this.velocity = new PVector(xVel, yVel);
    this.gravity = new PVector(0f, 0.002f);
    this.diameter = diameter;
  }
  
  void integrate() 
  {
    if(stopped || position.y + diameter / 2 >= height - 5) 
    {
      stopped = true;
      return;
    }
    
    position.add(velocity);
    
    applyGravity();
    applyDrag();
  }
  
  void applyGravity() 
  {
    PVector acceleration = gravity.get();
    float distance = height - position.y; 
    velocity.add(acceleration);
  }
  
  void applyDrag() 
  {
    velocity.mult(.999f);
  }
}
