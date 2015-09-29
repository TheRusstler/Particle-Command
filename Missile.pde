class Missile
{
  final PVector position;
  int diameter;
  boolean exploded;
  
  public Missile(int x, int y)
  {
    position = new PVector(x, y);
    diameter = 0;
  }
  
  private int increasing = 35;
  private int decreasing = 36;
  void integrate()
  {
    if(exploded == false)
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
  }
}
