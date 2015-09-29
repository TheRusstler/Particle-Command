class Particle 
{
  final static float DRAG = .996f;
  float diameter;
  float r, g, b;
  
  PVector position, velocity, gravity;
  int round, startDelay;
  boolean started = false;
    
  Particle(int round, float diameter, int startDelay)
  { 
    this.round = round;
    this.gravity = new PVector(0f, 0.008f);
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
  
  boolean isOutOfBounds()
  {
    return hasHitGround() 
          || position.x - diameter/2 < 0 
          || position.x + diameter/2 > width;
  }
  
  boolean isVisible()
  {
    return isOutOfBounds() == false && position.y > 0;
  }
  
  boolean hasHitGround() 
  {
    return position.y + diameter / 2 >= height - 50;
  }
  
  ArrayList<Particle> split()
  {
    ArrayList<Particle> newFromSplitting = new ArrayList<Particle>();
    
    if(random(-1,1) < 0)
    {
      splitInto3(newFromSplitting);
    }
    else
    {
      splitInto2(newFromSplitting);
    }

    return newFromSplitting;
  }
  
  private void splitInto2(ArrayList<Particle> newFromSplitting) 
  {
    float newDiameter = diameter * 2/3, newXVelocity = velocity.x/2;
    
    Particle p1 = new Particle(round, newDiameter, 0);
    p1.setMotion(position.get(), velocity.get());
    p1.velocity.x = -newXVelocity;
    p1.r = r;
    p1.g = g;
    p1.b = b;
 
    newFromSplitting.add(p1);   
    diameter = newDiameter;
    velocity.x = newXVelocity;
  }
  
  private void splitInto3(ArrayList<Particle> newFromSplitting)
  {
    float newDiameter = diameter * 1/3, newXVelocity = velocity.x/2;
    
    Particle p1 = new Particle(round, newDiameter, 0);
    p1.setMotion(position.get(), velocity.get());
    p1.velocity.x = -newXVelocity;
    p1.r = r;
    p1.g = g;
    p1.b = b;
    
    Particle p2 = new Particle(round, newDiameter, 0);
    p2.setMotion(position.get(), velocity.get());
    p2.velocity.x = 0;
    p2.r = r;
    p2.g = g;
    p2.b = b;
 
    newFromSplitting.add(p1);   
    newFromSplitting.add(p2);   
    diameter = newDiameter;
    velocity.x = newXVelocity;
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
    
    roundVelocityMultiplier = 1 + round/5.0;
    
    x = (int)random(5, width - 5);
    xVelocity = random(0.5, 1*roundVelocityMultiplier);
    yVelocity = random(0, 1.5*roundVelocityMultiplier);
    
    // Choose xVelocity direction according to starting half of screen
    if(x < width/2 && xVelocity < 0 || x > width/2 && xVelocity > 0) 
    {
      xVelocity *= -1;
    }
    
    position = new PVector(x, -20);
    velocity = new PVector(xVelocity, yVelocity);
  }
}
