class Missile
{
  final PVector position;
  int diameter;
  
  public Missile(int x, int y)
  {
    position = new PVector(x, y);
    diameter = 0;
  }
  
  private int increasing = 40;
  private int decreasing = 40;
  void integrate()
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
  }
}
