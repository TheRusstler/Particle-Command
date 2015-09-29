class Bomber extends Block
{
  int startDelay;
  boolean started = false;
  
  public Bomber(int delay)
  {
    super(width + 50, 50, 40, 25, new PVector(-1, 0));
    this.startDelay = delay;
  }
  
  void bomb()
  {
    PVector pos, vel;
    Particle p;
    
    p = new Particle(round.number, 10, 0);
    pos = new PVector(position.x, position.y + blockHeight/2);
    vel = new PVector(this.velocity.x/2, 1);
    p.setMotion(pos, vel);
    p.r = 0;
    p.g = 255;
    p.b = 0;
    
    round.particles.add(p);
  }
  
  void integrate() 
  { 
    super.integrate();
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
