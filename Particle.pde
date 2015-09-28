class Particle 
{
  final static float DRAG = .999f;
  
  final PVector position, velocity, gravity;
  final float diameter;
  final float r, g, b;
  
  Particle(int x, int y, float xVel, float yVel, float diameter) 
  {
    this.position = new PVector(x, y);
    this.velocity = new PVector(xVel, yVel);
    this.gravity = new PVector(0f, 0.002f);
    this.diameter = diameter;
    this.r = random(50, 255);
    this.g = random(50, 255);
    this.b = random(50, 255);
  }
  
  void integrate() 
  { 
    position.add(velocity); 
    velocity.add(gravity);
    velocity.mult(DRAG);
  }
  
  boolean hasHitGround() 
  {
    return position.y + diameter / 2 >= height - 5;
  }
}
