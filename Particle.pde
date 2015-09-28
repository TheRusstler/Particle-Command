class Particle 
{
  final static float DRAG = .999f;
  final float diameter;
  final float r, g, b;
  
  PVector position, velocity, gravity;
    
  Particle(int round) 
  { 
    this.gravity = new PVector(0f, 0.002f);
    this.diameter = random(2, 25);
    this.r = random(50, 255);
    this.g = random(50, 255);
    this.b = random(50, 255);
    
    randomise(round);
  }
  
  void randomise(int round)
  {
    int x, y;
    float xVelocity, yVelocity, roundVelocityMultiplier;
    
    roundVelocityMultiplier = 1 + round/10.0;
    
    x = (int)random(0, width);
    y = (int)random(-400, -20);
    xVelocity = random(0, 1*roundVelocityMultiplier);
    yVelocity = random(0, 2*roundVelocityMultiplier);
    
    // Choose xVelocity direction according to starting half of screen
    if(x < width/2 && xVelocity < 0 || x > width/2 && xVelocity > 0) 
    {
      xVelocity *= -1;
    }
    
    position = new PVector(x, y);
    velocity = new PVector(xVelocity, yVelocity);
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
