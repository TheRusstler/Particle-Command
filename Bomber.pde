class Bomber
{
  int startDelay;
  boolean started;
  PVector position, velocity;
  
  public Bomber(int delay)
  {
    this.startDelay = delay;
    velocity = new PVector(-1, 0);
    position = new PVector(width + 50, 50);
  }
  
  void bomb()
  {
    PVector pos, vel;
    
    Particle p = new Particle(round.number, 10, 0);
    pos = new PVector(position.x, position.y + 50);
    vel = new PVector(0, 1);
    p.setMotion(pos, vel);
    p.r = 0;
    p.g = 255;
    p.b = 0;
    
    round.particles.add(p);
  }
  
  void integrate() 
  { 
    if(started)
    {
      position.add(velocity); 
      if(frameCount % 100 == 0)
      {
        bomb();
      }
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
}
