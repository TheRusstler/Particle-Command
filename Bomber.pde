class Bomber
{
  int startDelay;
  boolean started;
  PVector position, velocity;
  
  public Bomber(int delay)
  {
    this.startDelay = delay;
    velocity = new PVector(-2, 0);
    position = new PVector(width + 50, 50);
  }
  
  void integrate() 
  { 
    if(started)
    {
      position.add(velocity); 
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
