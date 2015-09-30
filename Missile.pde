class Missile
{
  final int SPEED = 40;
  PVector target, position, velocity;
  private float distanceToTarget = 9999;
  int diameter;
  boolean exploded, reached;
  
  public Missile(PVector target)
  {
    this.target = target;
    this.position = getStartPosition();    
    this.diameter = 0;
    this.velocity = calculateVelocity();
  }
  
  PVector getStartPosition()
  {
    PVector position;
    if(target.x < width/2)
    {
      position = new PVector(0, height);
    }
    else
    {
      position = new PVector(width, height);
    }
    
    return position;
  }
  
  PVector calculateVelocity()
  {
    PVector vel = target.get();
    vel.sub(position);
    vel.normalize();
    vel.mult(SPEED);
    return vel;
  }
  
  void integrate()
  {
    if(reachedTarget() == false)
    {
      position.add(velocity);
      distanceToTarget = PVector.dist(position, target);
      return;
    }
    
    if(exploded == false)
    {
      explode();
    }
  }
  
  private int increasing = 35, decreasing = 36;
  void explode()
  {
    if(increasing > 0)
    {
      diameter++;
      increasing--;
    }
    else if(decreasing > 0)
    {
      diameter--;
      decreasing--;
    }
    else
    {
      exploded = true;
    }
  }
  
  boolean reachedTarget()
  {
    PVector newPos = position.get();
    newPos.add(velocity);
    
    if(PVector.dist(target, newPos) > PVector.dist(target, position))
    {
      position = target;
      return true;
    }
    
    return false;
  }
}
