class Particle 
{
  final static float DRAG = .999f;
  final float diameter;
  float r, g, b;
  
  PVector position, velocity, gravity;
  int round, startDelay;
  boolean started;
    
  Particle(int round, float diameter, int startDelay) 
  { 
    this.round = round;
    this.gravity = new PVector(0f, 0.003f);
    this.diameter = diameter;
    this.startDelay = startDelay;
    this.r = random(50, 255);
    this.g = random(50, 255);
    this.b = random(50, 255);
    
    randomiseMotion();
  }
  
  void integrate() 
  { 
    if(started)
    {
      position.add(velocity); 
      velocity.add(gravity);
      velocity.mult(DRAG);
    }
    else
    {
      checkIfStarted();
    }
  }
  
  void checkIfStarted()
  {
    if(startDelay == 0)
    {
      started = true;
    }
    else
    {
      startDelay--;
    }
  }
  
  boolean hasHitGround() 
  {
    return position.y + diameter / 2 >= height - 50;
  }
  
  Particle split()
  {
    Particle p = new Particle(round, diameter, 0);
    p.setMotion(position.get(), velocity.get());
    p.velocity.x = -p.velocity.x;
    p.r = r;
    p.g = g;
    p.b = b;
    return p;
  }
  
  void setMotion(PVector position, PVector velocity)
  {
    this.position = position;
    this.velocity = velocity;
  }
  
  void randomiseMotion()
  {
    int x;
    float xVelocity, yVelocity, roundVelocityMultiplier;
    
    roundVelocityMultiplier = 1 + round/10.0;
    
    x = (int)random(0, width);
    xVelocity = random(0, 1*roundVelocityMultiplier);
    yVelocity = random(0, 2*roundVelocityMultiplier);
    
    // Choose xVelocity direction according to starting half of screen
    if(x < width/2 && xVelocity < 0 || x > width/2 && xVelocity > 0) 
    {
      xVelocity *= -1;
    }
    
    position = new PVector(x, -20);
    velocity = new PVector(xVelocity, yVelocity);
  }
}
